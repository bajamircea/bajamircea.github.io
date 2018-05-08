---
layout: post
title: 'Destructors: Scope Guard'
categories: coding cpp
---

Using scope guard to perform ad hoc cleanup


# Introduction

The name scope guard refers to a technique developed originally by Petru
Marginean and popularized by Andrei Alexandrescu. Like RAII it uses destructors
to perform cleanup on scope exit.

# Scope exit gist

## scope_exit.h

Here is a possible implementation of a `scope_exit` class. It calls a function
when the scope is exited. The function is called in the destructor and stored
in the constructor. A helper function is used to deduce the exact type of the
function (e.g. it could be a functor, a function object, or a lambda, or just a
function).

{% highlight c++ linenos %}
#pragma once
#include <type_traits> // for remove_reference
#include <utility> // for move and forward

template<typename F>
class scope_exit
{
  F f_;

public:
  // take function by copy
  explicit scope_exit(const F & f) :
    f_{ f }
  {
  }

  // take function by move
  explicit scope_exit(F && f) :
    f_{ std::move(f) }
  {
  }

  // call provided function on destructor (scope exit)
  ~scope_exit()
  {
    f_();
  }

  // can't copy (or move), destructor called just once
  scope_exit(const scope_exit &) = delete;
  scope_exit & operator=(const scope_exit &) = delete;
};

// maker function, to auto-deduce provided function/functor's type
template<typename F>
auto make_scope_exit(F && f)
{
  // - the function/functor's type is used to instantiate the right scope_exit
  // - std::remove_reference gets the actual type without &
  // - due to copy elision can return even if scope_exit can't be copied or move
  return scope_exit<std::remove_reference_t<F>>(std::forward<F>(f));
}
{% endhighlight %}

## main.cpp

Here is a possible usage for the class

{% highlight c++ linenos %}
#include "scope_exit.h"
#include <iostream>

int main()
{
  std::cout << "Step 1\n";
  auto scope_1 = make_scope_exit([](){
    std::cout << "Cleanup 1\n";
  });

  std::cout << "Step 2\n";
  auto scope_2 = make_scope_exit([](){
    std::cout << "Cleanup 2\n";
  });

  std::cout << "Finished\n";
}
// Prints:
// Step 1
// Step 2
// Finished
// Cleanup 2
// Cleanup 1
//
{% endhighlight %}

# Scope failure gist

## scope_failure.h

`scope_exit` unconditionally calls the function, regardless on how the scope is
exited with regards to exceptions. In addition to that `scope_failure` and
`scope_success` are used to call the function when the scope is exited with an
exception, or without exception (the exception being considered the indication
of failure, it's absence the indication of success).

Here is a possible implementation of a `scope_failure` class. It uses
`uncaught_exceptions` (the `s` for plural is important) to detect additional
exceptions in flight.

{% highlight c++ linenos %}
#pragma once
#include <exception> // for uncaught_exceptions
#include <type_traits> // for remove_reference
#include <utility> // for move and forward

template<typename F>
class scope_failure
{
  F f_;
  int uncaught_exceptions_{ std::uncaught_exceptions() };

public:
  explicit scope_failure(const F & f) :
    f_{ f }
  {
  }

  explicit scope_failure(F && f) :
    f_{ std::move(f) }
  {
  }

  ~scope_failure()
  {
    // if the number of exceptions in flight
    // is larger than when instance was constucted
    // destructor is called as part of stack unwinding
    // for an exception.
    if (uncaught_exceptions_ != std::uncaught_exceptions())
    {
      f_();
    }
  }

  scope_failure(const scope_failure &) = delete;
  scope_failure & operator=(const scope_failure &) = delete;
};

template<typename F>
auto make_scope_failure(F && f)
{
  return scope_failure<std::remove_reference_t<F>>(std::forward<F>(f));
}
{% endhighlight %}

## main.cpp

Here is a possible usage for the `scope_failure` class.

{% highlight c++ linenos %}
#include "scope_failure.h"
#include <iostream>

int main()
{
  try
  {
    std::cout << "Step 1\n";
    auto scope_1 = make_scope_failure([](){
      std::cout << "Rollback 1\n";
    });

    std::cout << "Step 2\n";
    auto scope_2 = make_scope_failure([](){
      std::cout << "Rollback 2\n";
    });

    // scope_failure functions only run if exit scope with exception
    throw std::exception();
  }
  catch (...)
  {
  }
}
// Prints:
// Step 1
// Step 2
// Rollback 2
// Rollback 1
//
{% endhighlight %}


# Discussion

While it is easy to implement scope guard using a modern dialect of C++ in
2018, bear in mind that the idiom arose in about 2000.
`std::uncaught_exeption` was added to the standard and then deprecated and
replaced with `std::uncaugh_exceptions` (with an `s`, returning an `int`) as
part of the effort to provide a standard mechanism to detect if destructors are
called as part of stack unwinding.


## scope_exit

`scope_exit` is similar to RAII. The difference is that it is intended for ad
hoc cleanup. The RAII approach handcrafts a RAII class for each specific
cleanup, it provides benefits when it's reused. The scope guard approach
provides a class that gets instantiated with the operation to be performed in
destructor, it provides benefits on the assumption that each usage is unique.

Compare the `scope_exit` usage above with the code below. It is true that the
`message_on_exit` RAII class takes 12 additional lines, but we save a bit on
each reuse.

{% highlight c++ linenos %}
#include <iostream>

struct message_on_exit
{
  const char * msg;

  ~message_on_exit()
  {
    std::cout << msg;
  }

  message_on_exit(const message_on_exit &) = delete;
  message_on_exit & operator=(const message_on_exit &) = delete;
};

int main()
{
  std::cout << "Step 1\n";
  message_on_exit scope_1{ "Cleanup 1\n" };

  std::cout << "Step 2\n";
  message_on_exit scope_2{ "Cleanup 2\n" };

  std::cout << "Finished\n";
}
{% endhighlight %}


## scope_success

`scope_success` is dubious. Using a destructor to call a function when no
exception is thrown is convoluted compared with just calling the function.


## scope_failure

TODO: Work in progress
cleanup, next, rollback

{% highlight c++ linenos %}
#include "scope_failure.h"
#include <iostream>

int main()
{
  try
  {
    std::cout << "Step 1\n";

    try
    {
      std::cout << "Step 2\n";
      try
      {
        // trigger failure in this example
        throw std::exception();
      }
      catch (...)
      {
        std::cout << "Rollback 2\n";
        throw;
      }
    }
    catch (...)
    {
      std::cout << "Rollback 1\n";
      throw;
    }
  }
  catch (...)
  {
  }
}
// Prints:
// Step 1
// Step 2
// Rollback 2
// Rollback 1
//
{% endhighlight %}


## Common concerns

TODO: Work in progress


# References


Generic: Change the Way You Write Exception-Safe Code — Forever<br/>
[http://www.drdobbs.com/cpp/generic-change-the-way-you-write-excepti/184403758][scope-guard]

Andrei Alexandrescu: Three Unlikely Successful Features of D<br/>
[https://www.youtube.com/watch?v=1BRTX86DfOY][d-scope]

[d-scope]: https://www.youtube.com/watch?v=1BRTX86DfOY
[scope-guard]: http://www.drdobbs.com/cpp/generic-change-the-way-you-write-excepti/184403758
