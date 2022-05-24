---
layout: post
title: 'Class Lifetime'
categories: coding cpp
---

Not all the parts of a C++ class have the same lifespan. Distinct steps are
executed in sequence in the order to build or cleanup a C++ class instance.


## Scope

An instance of a class lives from when it's constructed, until it's destructed.
Generally the scope controls the duration of the lifetime and the bodies of the
constructor and the destructor define the actions to perform at the start and
the end of the lifetime.

{% highlight c++ linenos %}
void some_fn()
{
  SomeClass x; // x is constructed here
  SomeClass y; // y is constructed here
  // more code here
  {
    SomeClass z; // z is constructed here
    // more code here
    // z is destructed when we exit this block
  }
  // even more code here
  // x and y are destructed when we exit this block
  // y is destructed first, then x
}
{% endhighlight %}

The rationale for destructing `y` and then `x`, in the reverse order in which
they were constructed is that `y` could depend on `x`, but not the other way
around, so `y` has to be destructed first. Of course if the compiler determines
that there is no such dependency, and no side effects, it is free to re-order
assembly instructions (the **as-if rule**).

## Lifetime

Say we have a `SomeClass` derived from `Base1` and `Base2`, with two member
variables `a` and `b`, and with at least a virtual method that overrides the
a virtual method in `Base1`:

{% highlight c++ linenos %}
class SomeClass :
  // order of base classes matters
  public Base1,
  public Base2
{
  // order of member variables matters
  SomeType a;
  SomeOtherType b;

  // virtual function overrides method from Base1
  void some_method() override;

public:
  SomeClass()
    // initialization here (before the body)
  {
    // constructor body here
  }

  ~SomeClass()
  {
    // destructor body here
  }
};
{% endhighlight %}

The lifetime of the various parts of such a class is illustrated on the diagram
below. The full loop indicates the happy path: all the construction steps
succeed, the instance is used, then the destruction steps take place in reverse
order. However if something fails during the construction, the code will take
the shortcut indicated by the slanted arrows, reverting the work done up to
that point, in which case the caller needs to deal with the exception and can't
use the instance.

<div align="center">
{% include assets/2015-04-02-class-lifetime/01-lifetime.svg %}
</div>

First the memory must be allocated, either on the stack, or on the heap. The
memory required for an instance of `SomeClass` is the sum of:

- The sum of of the base classes sizes. This also includes the pointer to the
  virtual functions table (the vtable); most of the C++
  implementations use this technique for virtual functions
- The size of the member variables `a` and `b`
- Potentially additional bytes due to alignment and padding issues and
  potentially less bytes if any of base classes are empty

The constructors for the base classes are invoked, one by one, **in the order
in which they were inherited**. In this case the constructor for the `Base1`
class is invoked first, followed by the constructor for the `Base2` class. The
constructor for `SomeClass` can pass additional arguments to a base class in
the constructor's initialization list, for example:

{% highlight c++ linenos %}
SomeClass::SomeClass(int i, int j, int k) :
  // initialization list
  Base1{ i, j },
  Base2{ k }
{
  // constructor body
}
{% endhighlight %}

The member variables are then initialized **in the order in which they are
declared**, not in the order they appear (if they appear) in the constructor's
initialization list, though it is good practice to put them in the same order
in the initialization list, if possible.

{% highlight c++ linenos %}
SomeClass::SomeClass(int i, int j, int k) :
  // initialization list
  Base1{ i, j },
  Base2{ k },
  a{ k },
  b{}
{
  // constructor body
}
{% endhighlight %}

Before the body of the `SomeClass` constructor, the pointer to the virtual
functions table is set to point to the `SomeClass` vtable. Just before that, if
virtual functions are called, they would be the base class ones.

Finally the body of the `SomeClass` constructor is invoked.

If something goes wrong at any of steps during construction, the compiler will
take a shortcut indicated by the slanted arrows, and undo the steps up to that
point in reverse order, before throwing an exception.

For example if the constructor of a class fails, then the destructor is not
called (the rationale for that is that the object was not constructed), but
member variables are destructed, base classes are destructed and memory is
deallocated.

Another example is that if the constructor of the second member variable fails,
then the second member variable does not need to (will not) be destructed, but
the first variable is destructed, same for base classes, memory is deallocated.


## Example

For example an **incorrect naive implementation** of a class that handles to
`FILE` pointers might look like:

{% highlight c++ linenos %}
class bad_two_files
{
  FILE * src;
  FILE * dst;

public:
  bad_two_files(const char * src_name, const char * dst_name) :
    src{},
    dst{}
  {
    src = ::fopen(src_name, "rb");
    if ( ! src)
    {
      throw std::runtime_error("Failed to open file");
    }
    dst = ::fopen(dst_name, "wb");
    if ( ! dst)
    {
      throw std::runtime_error("Failed to open file");
    }
  }

  ~bad_two_files()
  {
    if (src)
    {
      ::fclose(src);
    }
    if (dst)
    {
      ::fclose(dst);
    }
  }

  bad_two_files(const bad_two_files &) = delete;
  bad_two_files & operator= (const bad_two_files &) = delete;

  bad_two_files(bad_two_files && other) :
    src{ other.src },
    dst{ other.dst }
  {
    other.src = nullptr;
    other.dst = nullptr;
  }

  bad_two_files & operator= (bad_two_files && other)
  {
    if (this != &other)
    {
      if (src)
      {
        ::fclose(src);
      }
      if (dst)
      {
        ::fclose(dst);
      }
      src = other.src;
      dst = other.dst;
      other.src = nullptr;
      other.dst = nullptr;
    }
    return *this;
  }
};
{% endhighlight %}

The problem is that if the `two_files` constructor fails while opening the
destination file, the destructor is not called, and the source file is not
closed. The smell in this case is that the `two_files` class tries to directly
manage two resources.

The better option is to have a class that manage a single resource, and have
`two_files` composed using two member variables of that class:

{% highlight c++ linenos %}
class file
{
  FILE * f;

public:
  file(const char * file_name, const char * mode)
  {
    f = ::fopen(file_name, mode);
    if ( ! f)
    {
      throw std::runtime_error("Failed to open file");
    }
  }

  ~file()
  {
    if (f)
    {
      ::fclose(f);
    }
  }

  file(const file &) = delete;
  file & operator= (const file &) = delete;

  file(file && other) noexcept :
    f{ other.f }
  {
    other.f = nullptr;
  }

  file & operator= (file && other) noexcept
  {
    if (this != &other)
    {
      if (f)
      {
        ::fclose(f);
      }
      f = other.f;
      other.f = nullptr;
    }
    return *this;
  }
};

class two_files
{
  file src;
  file dst;

public:
  two_files(const char * src_name, const char * dst_name) :
    src{ src_name, "rb" },
    dst{ dst_name, "wb" }
  {
  }
};
{% endhighlight %}

This way, if opening the destination file fails, then creating the instance of
`two_files` fails, but not before the source file is closed as part of it's
destructor. It also comes to pretty much the same number of code lines (fewer
lines of code in fact).

## Summary

Understand and take advantage of the initialization sequence for C++ classes.

NOTE: When using **virtual inheritance** like in `struct Derived: virtual
Base`, things are more complicated, but that's a whole separate topic on a C++
language feature that's not often used.
