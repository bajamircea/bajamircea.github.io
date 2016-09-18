---
layout: post
title: 'Special class operations. Lifetime syntax'
categories: coding cpp
---

This article looks at how we can define in C++ the most fundamentals behaviour
of a class: what it does when it's created, copied, moved and destroyed.


## Introduction

C++ provides a lot of control over the fundamental behaviour of user defined
types while at the same time preserving runtime efficiency.

This is a first article that covers ways of defining aspects of a class related
to it's [regularity][eop].

The most fundamental/special part about a class is what the class does when it's
created, copied, moved and destroyed. That is defined by:

- constructors
- copy constructor and copy assignment
- move constructor and move assignment
- destructor

I'm going to skip some obscure features like the funny `try/catch` block for
constructors and `explicit` for copy constructors and focus on the core parts.

## Constructors

In C++ the constructors are special functions that define what happens when we
create a new instance of a class.

{% highlight c++ linenos %}
{
  // Constructors define initialization of an instance
  // that can for example
  X a; // happen here
  X b(42); // or here
  X c{ 3, 4 }; // or here
  X * d = new X(); // or here
}
{% endhighlight %}

The syntax for a constructor looks like a weird member function for the class.

Like a member function it has:

- a name
- followed by arguments in the round brackets (there can be multiple overloads
  with different arguments)
- and a body in curly brackets

Unlike a regular member function:

- the name must be the same as the class name
- it has no return value
- it has an optional initializing section between the arguments and the body
- and it has a special try catch syntax we can ignore most of the time

The initialization section for a constructor is used to initialize things
before the body is exectued. You can initialize base class(es), member
variables, or delegate to another of the constructors of the class.

The body of the constructor is used for additional work, after initialization.

Because there is no return value, constructors fail by throwing.

In the example below the class has a constructor that accepts two integer
arguments. It initializes a member variables to the sum and difference of the
arguments. In the constructor body it does additional work: it checks that the
sum is not smaller than the difference.


{% highlight c++ linenos %}
struct X
{
  int sum;
  int diff;

  X(
    int a, int b
    ) :
    sum{ a + b },
    diff{ a - b}
  {
    if (sum < diff)
    {
      throw std::exception();
    }
  }
};
{% endhighlight %}

In the example above `sum` is initialized before `diff`[because of the order
of declaration][class-lifetime], not because of the order in the constructor.
However it's good practice to maintain in code a consistent order.

Based on the arguments, some constructors are even more special:

- default constructor: is the constructor with no arguments. For some classes
  having a constructor with no arguments does not make sense. Some algorithms.
  require types that have a default constructor which at minimum gets the
  object in such a state that [it can be destroyed and it can be assigned
  to][eop] (and can't be used in other ways unless it's assigned to).
- copy and move constructors: I'll cover them later in this article
- constructors that accept just one argument (other than copy and move). **Most
  of the time you want to make such a constructor explicit**. That is because
  most of the time you want code as below to fail to compile by preventing
  automatic conversion from the argument of the constructor.

{% highlight c++ linenos %}
struct X
{
  explicit X(int) { }
};

void some_fn(const X&) { }

int main()
{
  some_fn(42); // explicit makes this fail at compile time
}
{% endhighlight %}


## Destructor

Destructors define how to cleanup for a class instance.

{% highlight c++ linenos %}
{
  X a;

  // except catastrophic events the destructor for a
  // will be called if we reach this point
  // even if for example constructing b throws an exception

  X b(42);
  X c{ 3, 4 };
  X * d = new X();

  // Unless the cleanup happens earlier
  // because an exception or early return
  delete d; // then it happens here for d

  // or here for c, b, a
  // in the reverse order of creation
}
{% endhighlight %}

A class can have at most one destructor. The name of the destructor is the name
of the class prefixed with a `~` (like in "not a constructor"). It has no
arguments.

{% highlight c++ linenos %}
struct X
{
  // ...
  ~X()
  {
    std::cout << "Destructor called\n";
  }
};
{% endhighlight %}

If the constructor fails (and throws), the destructor is not called ... well,
except if you use delegating constructors in which case the destructor is
called if at least one constructor succeeds.

By default destructors are `noexcept`, which is a good default. There are no
general schemes that make sense if the cleanup code throws. So the rule of the
thumb is: **don't throw from destructors**.

For the edge cases when that's not possible, the 2nd best strategy is to
terminate. `std::thread` uses this approach. Another example would be a RAII
`relocker` class that needs to `lock` back a `std::mutex`. `lock` can throw, in
which case the process will terminate: there is usually no good option
otherwise.

{% highlight c++ linenos %}
class relocker
{
public:
  explicit relocker(std::mutex & m) : m_{ m } { m_.unlock(); }
  ~relocker() { m_.lock(); }
private:
  std::mutex & m_;
};
{% endhighlight %}

For a base class you might consider making the destructor virtual. In the
example below, if `B`'s destructor is virtual, the correct destructor, for
class `D` is called in `some_fn`. But before you hurry to make the destructor
virtual give a brief thought to the idea of avoiding the situation in the
first place.

{% highlight c++ linenos %}

void some_fn(B * b)
{
  delete b;
}

int main()
{
  D * d = new D();
  some_fn(d);
}
{% endhighlight %}


## Copy

Copy is when we duplicate the information in an instance. It can happen when we
create a new instance, or when we assign to an existing variable, the
difference being: do we already have data in the object we copy into?

{% highlight c++ linenos %}
X a;
X b(a); // copy construction happens here
X c = a; // and here
X d;
d = a; // copy assignment happens here
{% endhighlight %}

The syntax looks like:

{% highlight c++ linenos %}
struct X
{
  // ...

  // Copy constructor
  X(const X & other) // : initializers here
  {
    // copy here
  }

  // Copy assignment
  X & operator=(const X & other)
  {
    // clean existing data (unless &other == this)
    // then copy here
    return *this;
  }
};
{% endhighlight %}

Bear in mind that when we copy from an object into another, the destructor is
still called for both.

But once we get over the syntax of the copy operation, what's important is the
semantics:

- is that a deep copy (e.g `std::vector`)
- or is it a shallow, pointer semantics one (e.g. `std::shared_ptr`)
- or does copy makes sense at all (e.g. copy a resource like a TCP socket)


## Move

Move is when we transfer ownership for data from an instance to another. Like
with copy it can happen at construction time or through assignment.

{% highlight c++ linenos %}
X a;
X b(std::move(a)); // copy construction happens here
X c = std::move(b); // and here
X d;
d = std::move(d); // copy assignment happens here
{% endhighlight %}

The syntax looks like:

{% highlight c++ linenos %}
struct X
{
  // ...

  // Move constructor
  X(X && other) noexcept // : initializers here (actual move)
  {
    // put other into a deletable, non-owning state
  }

  // Move assignment
  X & operator=(X && other) noexcept
  {
    // move assignent here
    return * this;
  }
};
{% endhighlight %}

The syntax looks similar to copy, appart from the usage of non-const rvalue
refences. The noexcept is theoretically optional, but you're making your life
difficult if the move opperations throw.

Bear in mind that when we move from an object into another, the destructor is
still called for both, but the source, from which we moved, only needs to be in
a good state enough to allow destruction.

When implementing move assignment, one has to bear in mind the (rare) scenario
when the `other` object is actually the current one, like in the example below.

{% highlight c++ linenos %}
X a;
a = std::move(a);
{% endhighlight %}

The naive implementation would have a `if (&other == this)` test in the move
assignment. Usually this can be avoided by using a temporary variable.

[eop]: http://www.amazon.co.uk/Elements-Programming-Alexander-A-Stepanov/dp/032163537X
[class-lifetime]:     {% post_url 2015-04-02-class-lifetime %}
