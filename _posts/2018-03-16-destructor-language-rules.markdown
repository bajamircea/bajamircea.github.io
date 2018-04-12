---
layout: post
title: 'Destructors: Exception Safety Language Rules in C++11/17'
categories: coding cpp
---

Summary of the C++11/17 language rules related to destructor exception safety.
We'll look at the language rules as informal as possible without going into too
much legalese.


# Rule 1: Orderly destruction on (unexceptional) completion

When functions (or code blocks) complete normally, e.g. by reaching end or
returning, automatic objects (created on the stack) have their destructors
called in an orderly fashion. The destruction order is the reverse order to
which objects would have been constructed. The reason for this reverse order is
the assumptions that objects declared later might depend on earlier declared
ones, hence objects created later are destroyed first.

Example: In the code below, when exiting `fn`, destructors for `y` and `x` get
automatically called, precisely in this order.

{% highlight c++ linenos %}
void fn()
{
  X x; // (2)
  Y y; // (1)
}
{% endhighlight %}


# Rule 2: Orderly destruction for subobjects

Orderly destruction applies to subobjects:

- Members and bases get destroyed in the reverse order of declaration
- Elements of an array get destroyed from the largest to the smallest index

Example: When an instance of `X` is destroyed, the order of destruction is:
first the body of the `X` destructor, then the destructors for members `b` and
`a`, and then the destructors for the bases `Z` and `Y`.

{% highlight c++ linenos %}
class X :
  public Y, // (5)
  public Z // (4)
{
  A a; // (3)
  B b; // (2)
  ~X(){} // (1)
};
{% endhighlight %}


# Rule 3: Stack unwinding

_Stack unwinding_ is a term with a specific meaning. It refers to what happens
when an exception is thrown and control is passed to it's corresponding `catch`
block. During stack unwinding automatic objects that were created since the
`try` blocked was entered get destroyed in an orderly fashion.

Example: In the code below, when the exception is thrown, `y` and `x` get
destroyed during stack unwinding (but not `w` and `z`), before resuming from
the `catch` block.

{% highlight c++ linenos %}
void fn(int i)
{
  W w; // outside try
  try
  {
    X x; // (3)
    Y y; // (2)

    if (i < 0)
    {
      throw std::exception(); // (1)
    }

    Z z; // not created if above throws
  }
  catch (const std::exception &)
  { // (4)
  }
}
{% endhighlight %}


# Rule 5: std::terminate

When `std::terminate` is called the program will stop abruptly for all intents
and purposes. The programmer can call `std::teminate` explicitely, or it will
be called automatically in some cases.

Example: In the code below, if at runtime there is not enough memory to
allocate the array for the vector a `std::bad_alloc` is thrown from within the
vector constructor. The exception would normally travel outside the function
`fn`, but because of `noexcept` the program will terminate.

{% highlight c++ linenos %}
void fn(int i) noexcept // (2)
{
  std::vector x(i); // (1)
}
{% endhighlight %}


# Rule 6: Destructors are noexcept by default

This is new rule in C++11. Destructors are `noexcept` by default. That is true
unless you specified `noexcept(true)` for it (or any subobjects). Combined with
the rule above, if exceptions propagate outside destructors, this will trigger
program termination by default.

Example: In the code below, the destructor of `X` will terminate the program.

{% highlight c++ linenos %}
struct X
{
  ~X() // (2) noexcept by default causes termination
  {
    throw std::exception(); // (1)
  }
};
{% endhighlight %}

Example: In the code below the exception in the destructor will not terminate.
The destructor of `x` is called during stack unwinding, but the second
exception thrown inside it's destructor is caught before leaving the
destructor.

{% highlight c++ linenos %}
struct X
{
  ~X()
  { // (2)
    try
    {
      throw std::exception(); // (3)
    }
    catch (const std::exception &)
    { // (4)
    }
  }
};

void fn()
{
  try
  {
    X x;
    throw std::exception(); // (1)
  }
  catch (const std::exception &)
  { // (5)
  }
}
{% endhighlight %}


# Rule 7: Exception exiting destructor

Exceptions can exit a destructor. Because of the previous rule, practically one
needs to explicitely specify `noexcept(false)` for the destructor. If an
exception exits a destructor during stack unwinding then the program is
terminated. But if the program is not terminated the rules of orderly
destruction apply.

Example: Let's first look at how an exception can exit a destructor and NOT
terminate. The destructor of `x` gets invoked because or normal block
completion, then it throws. Because of the `noexcept(false)` specifier the
expection will propagate, and because this time we're not yet stack unwinding
it will not terminate.

{% highlight c++ linenos %}
struct X
{
  ~X() noexcept(false) // (2)
  {
    throw std::exception(); // (1)
  }
};

void fn()
{
  try
  {
    X x;
  }
  catch (const std::exception &)
  { // (3)
  }
}
{% endhighlight %}

Example: Slight variations might terminate. Below by throwing an exception
inside `fn` the destructor for `x` will be called during stack unwinding and
it's exception will cause program termination

{% highlight c++ linenos %}
struct X
{
  ~X() noexcept(false) // (3) -> terminate
  {
    throw std::exception(); // (2)
  }
};

void fn()
{
  try
  {
    X x;
    throw std::exception(); // (1)
  }
  catch (const std::exception &)
  {
  }
}
{% endhighlight %}

Example: Another slight variation that terminates. Below the destructor for `b`
is fine, it throws, but the destructor for `a` exits with throw during stack
unwinding and it will cause program termination.

{% highlight c++ linenos %}
struct X
{
  ~X() noexcept(false) // (2) (4) -> terminate
  {
    throw std::exception(); // (1) (3)
  }
};

void fn()
{
  try
  {
    X a;
    X b;
  }
  catch (const std::exception &)
  {
  }
}
{% endhighlight %}

Example: However this example is fine again. The destructor of 'y' is called
before stack unwinding so together with noexcept(false) it will be fine if it
throws. And it will throw because `delete` will throw because of the destructor
of `X`. In addition, it will not leak because `delete` will free the memory
even if the destructor throws.

{% highlight c++ linenos %}
struct X
{
  ~X() noexcept(false) // (5)
  { // (3)
    throw std::exception(); //(4)
  }
};

struct Y
{
   X * x = new X();

  ~Y() noexcept(false) // (6)
  { // (1)
    delete x; // (2)
  }
};

void fn()
{
  try
  {
    Y y;
  }
  catch (const std::exception &)
  { // (7)
  }
}
{% endhighlight %}

NOTE: `std::uncaught_exceptions` can be used to detect stack unwinding. The `s`
at the end (as in plural) is very important. The version without `s` has
problems and is deprecated.

# References

The March 2017 C++ standard working draft (free, but not exactly C++17)<br/>
[http://www.open-std.org/jtc1/sc22/wg21/docs/papers/2017/n4659.pdf][standard]

[standard]: http://www.open-std.org/jtc1/sc22/wg21/docs/papers/2017/n4659.pdf
