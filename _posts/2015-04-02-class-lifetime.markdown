---
layout: post
title: 'Class Lifetime'
categories: coding cpp
---

Not all the parts of a C++ class have the same lifespan. Distinct steps are
executed in sequence in the order to build or cleanup a C++ class instance.


## Lifetime

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
};
{% endhighlight %}

Say we have a `SomeClass` derived from a `Base` class, with two member
variables `a` and `b`, and with at least a virtual method that overrides the
base class method:

{% highlight c++ linenos %}
class SomeClass :
  public Base
{
  SomeType a;
  SomeOtherType b;

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

The lifetime of the various parts of such a class are illustrated on the diagram
below. The dotted lines indicate what happens if an exception is thrown when
something fails to construct, in which case the caller needs to deal with the
exception and can't use the instance. The full loop indicates the successful path.

![Lifetime diagram](/assets/2015-04-02-class-lifetime/lifetime.png)

First the memory must be allocated, either on the stack, or on the heap. The
memory required for an instance of `SomeClass` is the sum of:

- the size of the `Base` class (which also includes the pointer to the virtual
  functions table; most of the C++ implementations use this technique for
  virtual functions)
- the size of the member variables `a` and `b`
- and potentially additional bytes due to alignment and padding issues

Then the constructor for the base class is invoked. If that fails, the memory
is deallocated. The constructor for `SomeClass` can pass additional arguments to
the base class in the constructor's initialization list, for example:

{% highlight c++ linenos %}
SomeClass::SomeClass(int i, int j, int k) :
  // initialization list
  Base{ i, j }
{
  // constructor body
};
{% endhighlight %}

At some point, after the base class is constructed, the pointer to the virtual
functions table is set to point to the `SomeClass` vtable. Before that if
`Base` class has virtual functions, it would have been pointing to the `Base`
class vtable.

The member variables are then initialized **in the order in which they are
declared**, not in the order they appear (if they appear) in the constructor's
initialization list, though it is good practice to put them in the same order
in the initialization list, if possible. The same is true if there is more than
one base classes, they are also initialized in the order in which they are
declared.

{% highlight c++ linenos %}
SomeClass::SomeClass(int i, int j, int k) :
  // initialization list
  Base{ i, j },
  a{ k },
  b{}
{
  // constructor body
};
{% endhighlight %}

The dotted arrows indicate what happens if an exception is thrown when
something fails to construct. For example if the constructor of a class fails,
then the destructor is not called. Another example is that if the constructor
of the second member variable fails, then the first variable is destructed.

For example a **naive implementation** of a class that handles to `FILE` pointers
would look like:

{% highlight c++ linenos %}
class two_files
{
  FILE * src;
  FILE * dst;

public:
  two_files(const char * src_name, const char * dst_name) :
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

  ~two_files()
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
};
{% endhighlight %}

The problem is that if the `two_files` constructor fails while opening the
destination file, the destructor is not called, and the source file is not
closed. The smell in this case is that the `two_files` class tries to directly
manage two resources.

The better option is to have a class that manage a single resource, and have
`two_files` have two member variables of that class:

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
    ::fclose(f);
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
`two_files` fails, but not before the source file is closed. It also comes to
pretty much the same number of code lines.

## Summary

Understand and take advantage of the initialization sequence for C++ classes.
