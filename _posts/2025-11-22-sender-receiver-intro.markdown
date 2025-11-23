---
layout: post
title: 'Sender/receiver intro'
categories: coding cpp
---

The idea behind sender/receiver


This article is part of the [Principia coroutines][principia-coroutines] series.

WARNING: **Code presented here is slideware quality: we use struct (not
classes), all public, disregard care for copy/move/const/noexcept, use pair
instead of expected etc. etc.**.

# What are sender/receivers?

They are a way of expressing asynchronous execution.

They came out of work that resulted in [P2300R10:
std::execution](https://www.open-std.org/jtc1/sc22/wg21/docs/papers/2024/p2300r10.html)
getting into the C++26 standard.

The terminology sender/receiver makes sense if you think that:
- **a sender** does some computation and sends the outcome of that computation
- **a receiver** receives the outcome of that computation

The computation is meant to be asynchronous (except for trivial cases).

A receiver "receives" by implementing methods like:
- `set_value(...)`: the computation provides a value (multiple overloads based
  on the value type)
  - e.g. `set_value(int)` to receive an `int` value
  - e.g. `set_value(int, char)` to receive in one go both an `int` and a `char`
- `set_error(...)`: the computation provides an error (multiple overloads based
  on the error type)
  - e.g. `set_error(errno)` to receive a `errno` error
  - e.g. `set_error(std::exception_ptr)` to receive an exception that can be
    re-thrown
- `set_stopped()`: the computation stopped without providing a value or an
  error (no arguments)

A sender "sends" by eventually calling one of those methods of a receiver.

What we got largely in C++26 are concepts to describe sender/receivers: e.g. the
equivalent of describing iterators as input iterator, bidirectional iterator,
random access iterator, but without containers implementing them.

It specifies things like:
- how a type is identified as a sender or a receiver
- how does the receiver specify the kind of values or errors that it can handle
  (the language is not very good at "find all the functions called `set_value`
  and give me the argument types of those functions")
- how they should interact via `connect`, operation state and `start`
- some useful tools like `inplace` versions of `stop_source|token|callback`


# Example 1: syncronous sender/run function

We start with an example where there is entirely synchronous. The point is to
see:
- the basics of a sender
- a run function taking that sender
- the run function creating a receiver
- how the work is started in run in two steps: `connect` to get an operation state,
  then `start` on that operation state


## main.cpp

In `main` we create a sender that just produces the `int` value that we
construct it with, `42`. This sender is passed to a `sync_run` that ends up
returning the result of the sender, `42`.

{% highlight c++ linenos %}
#include "just_int.h"
#include "sync_run.h"

int main() {
    just_int s{ 42 };
    int value = sync_run(std::move(s));
    if (value != 42) return 1;
    return 0;
}
{% endhighlight %}


## sync_run.h

The `sync_run` takes a sender. It expects this will produce an `int` value that
`sync_run` will return. It uses a `receiver` type which when `set_value` is
called, will put the value and mark done into stack variables inside
`sync_run`. It initiates the work via the `connect` and `start` sequence. It
expects that that completed synchronously, i.e. that `set_value is called on
the receiver when `start` was called.

{% highlight c++ linenos %}
#pragma once
#include <exception> // for std::terminate

template<typename Sender>
int sync_run(Sender s) {
    struct receiver {
        bool* done_;
        int* value_;

        void set_value(int value) {
            *value_ = value;
            *done_ = true;
        }
    };

    bool done{ false };
    int value{};

    auto op_state = s.connect(receiver{ &done, &value });
    op_state.start();

    if (!done) std::terminate();

    return value;
};
{% endhighlight %}


## just_int.h

`just_int` is a sender that is contructed with an `int`. Senders are expected
to implement `connect` taking a receiver. `connect` returns an operation state.
The `just_int::op_state` captures the receiver and the `int`. When `start` is
called on the operation state it synchronously completes by pusing the `int`
into the receiver using `set_value`.

{% highlight c++ linenos %}
#pragma once
#include <utility>  // for std::move

struct just_int {
    template<typename Receiver>
    struct op_state {
        Receiver r_;
        int i_;

        void start() {
            r_.set_value(i_);
        }
    };

    int i_;

    template<typename Receiver>
    op_state<Receiver> connect(Receiver&& r) {
        return {std::move(r), i_};
    }
};
{% endhighlight %}

# Example 2: composing senders

This example builds onto the previous example and shows how some senders allow
composition of further senders

## main.cpp

`main` changes by using a `then_int` sender that takes a sender and a function
and applies the function to the value of the child

{% highlight c++ linenos %}
#include "just_int.h"
#include "then_int.h"
#include "sync_run.h"

int main() {
    just_int s1{ 42 };
    auto s2 = then_int( std::move(s1), [](int i) { return -i; } );
    int value = sync_run(std::move(s2));
    if (value != -42) return 1;
    return 0;
}
{% endhighlight %}

## then_int.h

`then_int` is a sender that injects it's own receiver so that it applies a
function to the value of the upstream sender and sends the result of the
function into the downstream receiver.

{% highlight c++ linenos %}
#pragma once
#include <utility>

template<typename UpstreamSender, typename Fn>
struct then_int {
    template<typename DownstreamReceiver>
    struct receiver {
        DownstreamReceiver r_;
        Fn fn_;

        void set_value(int value) {
            r_.set_value(fn_(value));
        }
    };

    UpstreamSender s_;
    Fn fn_;

    template<typename Receiver>
    auto connect(Receiver&& r) {
        return s_.connect(receiver{ std::move(r), std::move(fn_) });
    }
};
{% endhighlight %}


# Example 3: asyncronous sender

## line_feed_counter.h

`line_feed_counter` is a sender that counts the number of `\n` (line feeds) in
a file. It takes a file name that it relays together with the receiver from
`connect` into an operation state. It uses a function `ReadFileEx` that will
call a callback later. There are lots of details, but the important bit is that
the work does not complete in the operation state `start`. When the work
completes, it calls the receiver with `set_value` with the number of line feeds
in the file, or with `set_error` with the Windows error code.

{% highlight c++ linenos %}
#pragma once
#include <utility>
#include <Windows.h>

struct line_feed_counter {
    template<typename Receiver>
    struct op_state : OVERLAPPED {
        Receiver r_;
        const char* file_name_;
        HANDLE h_{ INVALID_HANDLE_VALUE };
        char buffer_; // toy example, read one byte at a time
        int lines_{ 0 };

        op_state(Receiver&& r, const char* file_name) :
            OVERLAPPED{}, r_{ std::move(r) }, file_name_{ file_name } {}

        ~op_state() {
          if (h_ != INVALID_HANDLE_VALUE) ::CloseHandle(h_);
        }

        void start() {
            h_ = ::CreateFileA(file_name_, GENERIC_READ, FILE_SHARE_READ, nullptr,
                OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL | FILE_FLAG_OVERLAPPED, nullptr);
            if (INVALID_HANDLE_VALUE == h_) {
                r_.set_error(::GetLastError());
                return;
            }
            read();
        }

    private:
        void read() {
            auto result = ::ReadFileEx(h_, &buffer_, 1, this, static_read_completed);
            if (0 == result) {
                DWORD gle = ::GetLastError();
                if (ERROR_HANDLE_EOF == gle) {
                    r_.set_value(lines_);
                    return;
                }
                r_.set_error(gle);
            }
        }

        static void static_read_completed(DWORD error, DWORD count, LPOVERLAPPED p) {
            auto self = reinterpret_cast<op_state*>(p);
            self->read_completed(error, count);
        }

        void read_completed(DWORD error, DWORD count) {
            if ((0 == count) || (ERROR_HANDLE_EOF == error)) {
                r_.set_value(lines_);
                return;
            }
            if (0 != error) {
                r_.set_error(error);
                return;
            }
            if ('\n' == buffer_) {
                ++lines_;
            }
            ++Offset; // toy example
            read();
        }
    };

// sender members here:
    const char* file_name_;

    template<typename Receiver>
    op_state<Receiver> connect(Receiver&& r) {
        return {std::move(r), file_name_};
    }
};
{% endhighlight %}

## alertable_run.h

On top of the `sync_run`, the `alertable_run`:
- its receiver has a `set_error` as well
- needs to get the thread into an alertable state that will run the completions
  of `ReadFileEx`: it does that by calling `SleepEx` until `done`

{% highlight c++ linenos %}
#pragma once
#include <exception>
#include <utility>

template<typename Sender>
std::pair<int, DWORD> alertable_run(Sender s) {
    struct receiver {
        bool* done_;
        int* value_;
        DWORD * error_;

        void set_value(int value) {
            *value_ = value;
            *done_ = true;
        }

        void set_error(DWORD error) {
            *error_ = error;
            *done_ = true;
        }
    };

    bool done{ false };
    int value{};
    DWORD error{};

    receiver r{ &done, &value, &error };
    auto op_state = s.connect(std::move(r));
    op_state.start();

    while (!done) {
        auto sleep_result = ::SleepEx(INFINITE, TRUE);
        if (WAIT_IO_COMPLETION != sleep_result) {
            std::terminate();
        }
    }

    return {value, error};
};
{% endhighlight %}


## main.cpp

Main calls the blocking `alertable_run` with the asynchronous
`line_feed_counter`.

{% highlight c++ linenos %}
#include "line_feed_counter.h"
#include "alertable_run.h"
#include <iostream>

int main() {
    line_feed_counter s{ __FILE__ };

    auto result = alertable_run(s);
    if (0 != result.second) {
        std::cout << "error:" << result.second << '\n';
        return 1;
    }
    std::cout << "line feeds: " << result.first << '\n'; // prints 14
    return 0;
}
{% endhighlight %}

[principia-coroutines]:    {% post_url 2025-05-04-principia-coroutines %}
