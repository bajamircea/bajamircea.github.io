---
layout: post
title: 'Destructors: Scope Guard'
categories: coding cpp
---

Using scope guard to perform one-off cleanups


# Introduction

The name scope guard refers to a technique for performing one-off cleanups
developed originally for C++ by Petru Marginean and popularized by Andrei
Alexandrescu.

Like RAII, it uses destructors to perform cleanup on scope exit. Multiple
cleanups are performed in the reverse order of declaration.

{% highlight c++ linenos %}
#include "scope_exit.h"
#include <iostream>

void foo()
{
  std::cout << "Action 1\n";
  auto scope_1 = make_scope_exit([](){
    std::cout << "Cleanup 1\n";
  });

  std::cout << "Action 2\n";
  auto scope_2 = make_scope_exit([](){
    std::cout << "Cleanup 2\n";
  });

  std::cout << "Finished\n";
}
// Prints:
// Action 1
// Action 2
// Finished
// Cleanup 2
// Cleanup 1
//
{% endhighlight %}

In addition to the version that always cleans up on scope exit there is a
version that only calls the cleanup in a failure case. The definition of
failure is: if the scope is exited with an exception (stack unwinding in C++
legalese) then it's a failure, otherwise it's success and the cleanup will not
be performed. The cleanup is a rollback in this case.

There is a third version that calls cleanup only for successful scope exit as
opposed to failure. The cleanup is a commit in this case.

{% highlight c++ linenos %}
#include "scope_failure.h"
#include <iostream>

void foo()
{
  std::cout << "Action 1\n";
  auto scope_1 = make_scope_failure([](){
    std::cout << "Rollback 1\n";
  });
  auto scope_2 = make_scope_success([](){
    std::cout << "Commit 1\n";
  });

  // for the sake of example throw an exception
  // to trigger failure handling
  throw std::runtime_error("Failure");
}
// Prints:
// Action 1
// Rollback 1
//
// foo exits with std::runtime_error("Failure")
{% endhighlight %}


# Implementation gist

In 2018, using a modern dialect of C++, it's easy to implement scope guards,
though bear in mind that the idiom arose in about 2000 when it was not so easy:
for a start lambdas were not available, macros were used as substitutes.

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
    // this simple implementation assumes f_() does
    // not throw (see below)
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


## stack_unwinding.h

In order to support scope guard scenarios `std::uncaught_exception` (returning
a `bool`) was initially added to the standard, but [it had
issues][uncaught-exception] so then it was deprecated.

`std::uncaught_exceptions` (with `s` for plural, returning an `int`) returning
the number of exceptions in flight can then be used to detect stack unwinding.

{% highlight c++ linenos %}
#pragma once
#include <exception> // for uncaught_exceptions

class stack_unwinding
{
  int uncaught_exceptions_{ std::uncaught_exceptions() };

public:
  bool operator() {
  {
    // if the number of exceptions in flight
    // is larger than when instance was constucted
    // this function is called as part of stack unwinding
    // for an exception.
    return (uncaught_exceptions_ != std::uncaught_exceptions());
  }

  stack_unwinding(const stack_unwinding &) = delete;
  stack_unwinding & operator=(const stack_unwinding &) = delete;
};
{% endhighlight %}


## scope_failure.h

Here is a possible implementation of a `scope_failure` class. It calls the
cleanup function only if exiting with stack unwinding.

{% highlight c++ linenos %}
#pragma once
#include "stack_unwinding.h"
#include <type_traits> // for remove_reference
#include <utility> // for move and forward

template<typename F>
class scope_failure
{
  F f_;
  stack_unwinding stack_unwinding_;

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
    if (stack_unwinding_())
    {
      // this simple implementation assumes f_() does
      // not throw (see below)
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


# Comparing approaches

## Compared with RAII

The RAII approach handcrafts a RAII class for each specific cleanup, it
provides benefits when it's reused.  Compare the `scope_exit` usage above with
the code below. It is true that the `message_on_exit` RAII class takes 12
additional lines, but we save a bit on each reuse, because `std::cout <<` is
not repeated.

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
  std::cout << "Action 1\n";
  message_on_exit scope_1{ "Cleanup 1\n" };

  std::cout << "Action 2\n";
  message_on_exit scope_2{ "Cleanup 2\n" };

  std::cout << "Finished\n";
}
{% endhighlight %}


## Compared with using try-catch blocks

Should you have a situation where there is an action with cleanup, rollback and
commit the `try` `catch` approach takes the following shape.

{% highlight c++ linenos %}
#include <iostream>

void bar()
{
  // trigger failure in this example
  throw std::runtime_error("Failure");
}

void foo()
{
  std::cout << "Action 1\n";
  try
  {
    bar();
    std::cout << "Commit 1\n";
    std::cout << "Cleanup 1\n";
  }
  catch (...)
  {
    std::cout << "Rollback 1\n";
    std::cout << "Cleanup 1\n";
    throw;
  }
}
// Prints:
// Action 1
// Rollback 1
// Cleanup 1
//
// foo exits with std::runtime_error("Failure")
{% endhighlight %}


## Compared with D

Andrei Alexandrescu went to work on the D laguage where the scope guard
technique was built in the language, here is a sample usage in D.

{% highlight d linenos %}
import std.stdio : writeln;

void foo()
{
    writeln("In foo");
    throw new Exception("Foo exception");
}

void bar()
{
  writeln("Action 1");
  scope(exit) writeln("Cleanup 1");
  scope(failure) writeln("Rollback 1");
  scope(success) writeln("Commit 1");

  foo();
}
// Prints
// Action 1
// In foo
// Rollback 1
// Cleanup 1
//
// Bar exits with Foo exception
{% endhighlight %}


# Exceptions while cleaning up

TODO: Work in progress

{% highlight d linenos %}
import std.stdio : writeln;

void foo()
{
    writeln("In foo");
    throw new Exception("Foo exception");
}

void main()
{
    try
    {
        writeln("Action 1");
        scope(exit) writeln("Cleanup 1");
        scope(failure) writeln("Rollback 1");
        scope(success) writeln("Commit 1");

        writeln("Action 2");
        scope(exit) writeln("Cleanup 2");
        scope(failure) writeln("Rollback 2");
        scope(success) writeln("Commit 2");

        foo();
    }
    catch(Exception e)
    {
        writeln(e.msg);
    }
}
// Prints
// Action 1
// Action 2
// In foo
// Rollback 2
// Cleanup 2
// Rollback 1
// Cleanup 1
// Foo exception
{% endhighlight %}



## scope_success

`scope_success` is dubious. Using a destructor to call a function when no
exception is thrown is convoluted compared with just calling the function.


# Conclusion

# References

Generic: Change the Way You Write Exception-Safe Code — Forever<br/>
[http://www.drdobbs.com/cpp/generic-change-the-way-you-write-excepti/184403758][scope-guard]

Herb Sutter on the issues with uncaught_exception<br/>
[http://www.gotw.ca/gotw/047.htm][uncaught-exception]

Andrei Alexandrescu: Three Unlikely Successful Features of D<br/>
[https://www.youtube.com/watch?v=1BRTX86DfOY][d-scope]

D language exception safety<br/>
[https://dlang.org/articles/exception-safe.html][d-exception-safe]

[d-scope]: https://www.youtube.com/watch?v=1BRTX86DfOY
[scope-guard]: http://www.drdobbs.com/cpp/generic-change-the-way-you-write-excepti/184403758
[d-exception-safe]: https://dlang.org/articles/exception-safe.html
[uncaught-exception]: http://www.gotw.ca/gotw/047.htm
