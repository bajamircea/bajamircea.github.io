---
layout: post
title: 'Destructors: Recommended Idiom for C++11/17'
categories: coding cpp
---

This is the second of three articles about C++ destructors. It describes the
recommended idiom for most C++ applications.


# Introduction

Here is the executive summary for a good idiom given the current language
rules: **Do not exit with exceptions from destructors. If you still contemplate
exiting with exception from a destructor: avoid it.** Avoidance options
include:

- Catch thrown exceptions inside the destructor.
- Terminate for fatal errors.
- Create a separate function that throws and don't forget to call it (outside
  destructors).

The most common question programmers ask is "yes, but why not?" . I'll allude
to it at the end of this article, but it's really the point of the next article
to explore that question.

Here I'll restrict to describing in detail realistic cases of how to handle
code that destructors call. I ignore cosmic rays damaging CPU or memory and
bugs (OS, compiler, hardware).

# Simplest: resource release that do not fail

This section deals with functions that release resources, have no reason to
fail as long as we meet the preconditions, and do not provide error codes or
exceptions. We deal with them by ensuring elsewhere that we meet the
preconditions and we just call them in destructors.

## free

A typical example is `free`.

{% highlight c++ linenos %}
void free(void * ptr);
{% endhighlight %}

`free` is releasing memory, with the precondition that the argument is a
non-null pointer that was returned by `malloc`. Assuming the precondition is
met, it has no reason to fail (it does not depend on anything outside the CPU
and memory). Therefore it does not even have a return code.

Example: `simple_c_heap_ptr` below just calls `free` in the destructor and makes
a good effort to ensure the preconditions will be met.

{% highlight c++ linenos %}
class simple_c_heap_ptr
{
  void * p_;

public:
  explicit simple_c_heap_ptr(size_t size) :
    p_{ malloc(size) }
  {
    if (p_ == nullptr)
    {
      throw std::bad_alloc();
    }
  }

  ~simple_c_heap_ptr()
  {
    free(p_); // <-
  }

  simple_c_heap_ptr(const simple_c_heap_ptr &) = delete;
  simple_c_heap_ptr & operator=(const simple_c_heap_ptr &) = delete;

  void * get()
  {
    return p_;
  }
};
{% endhighlight %}

## Move semantics

Move is related to destruction because of two reasons.

Reason 1: If we move from an object it's destructor is still called, but the
resource is gone, the destructor has nothing to do. Therefore once we add move
to a class we need to add a test in the destructor to decide if we need to
release the resource or not. The test usually involves testing for a invalid
value (often `nullptr`) or testing for a `bool` member variable.

Reason 2: Move assignment involves releasing the resource of the target object
before assigning it the value of the source. Releasing the resource in move
assignment is very similar to the work done by the destructor. Therefore there
is a link between the destructor being `noexcept` and move assignment being
`noexcept`.

Addressing move constructor or assignment that throw is a separate topic,
though the destructor idiom presented here assumes you'll probably want to take
the approach of not throwing from move constructor and assignment either.

Example: In the code below the `c_heap_ptr` is a version of `simple_c_heap_ptr`
that was extended to support move semantics.

NOTE: The noexcept defaults are currently different for move hence the need to
be explicit.

{% highlight c++ linenos %}
class c_heap_ptr
{
  void * p_;

public:
  c_heap_ptr() noexcept :
    p_{ nullptr }
  {
  }

  explicit c_heap_ptr(size_t size) :
    p_{ malloc(size) }
  {
    if (p_ == nullptr)
    {
      throw std::bad_alloc();
    }
  }

  ~c_heap_ptr()
  {
    if (p_ != nullptr) // <-
    {
      free(p_); // <-
    }
  }

  c_heap_ptr(const c_heap_ptr &) = delete;
  c_heap_ptr & operator=(const c_heap_ptr &) = delete;

  c_heap_ptr(c_heap_ptr && other) noexcept :
    p_{ other.p_ }
  {
    other.p_ = nullptr;
  }

  c_heap_ptr & operator=(c_heap_ptr && other) noexcept
  {
    if (this != &other)
    {
      if (p_ != nullptr) // <-
      {
        free(p_); // <-
      }
      p_ = other.p_;
      other.p_ = nullptr;
    }
    return *this;
  }

  void * get()
  {
    return p_;
  }
};
{% endhighlight %}

## More than one resource

How do we deal with code in the destructor if we need to free more than one
resource?

For reference here is a naive example, likely bad:

{% highlight c++ linenos %}
class bad_two_resources
{
  void * p_;
  void * q_;

public:
  bad_two_resources(size_t size_p, size_t size_q) :
  {
    p_ = malloc(size_p);
    if (p_ == nullptr)
    {
      throw std::bad_alloc();
    }
    q_ = malloc(size_q);
    if (q_ == nullptr)
    {
      free(p_);
      throw std::bad_alloc();
    }
  }

  ~bad_two_resources()
  {
    free(p_);
    free(q_);
  }

  bad_two_resources(const bad_two_resources &) = delete;
  bad_two_resources & operator=(const bad_two_resources &) = delete;

  void * get_p()
  {
    return p_;
  }

  void * get_q()
  {
    return q_;
  }
};
{% endhighlight %}

**There is a simple solution to the problem of creating a class that aggregates
two resources**:

{% highlight c++ linenos %}
struct two_resources
{
  simple_c_heap_ptr p;
  simple_c_heap_ptr q;
};
{% endhighlight %}

# Other resources releases that do not fail

## delete

First of all, instead of using `delete` directly, consider using something like
`std::unique_ptr` if possible. I'll continue for the sake of completeness. It
is similar with `free` in that it largely operates on heap allocation,
releasing memory. It is different in that it calls the destructor of the
object. That theoretically could throw, but if you follow this idiom it won't.
Another minor difference is that `delete` is documented to accept a (otherwise
invalid value) of `nullptr` (and does nothing).

{% highlight c++ linenos %}
template<class T>
class dummy_int_ptr
{
  int * p_;

public:
  explicit dummy_int_ptr(int x) :
    p_{ new int(x) }
  {
  }

  ~dummy_int_ptr()
  {
    delete p_; // <-
  }

  dummy_int_ptr(const dummy_int_ptr &) = delete;
  dummy_int_ptr & operator=(const dummy_int_ptr &) = delete;

  dummy_int_ptr(dummy_int_ptr && other) noexcept :
    p_{ other.p_ }
  {
    other.p_ = nullptr;
  }

  dummy_int_ptr & operator=(dummy_int_ptr && other) noexcept
  {
    if (this != &other)
    {
      delete p_; // <-
      p_ = other.p_;
      other.p_ = nullptr;
    }
    return *this;
  }

  int * get()
  {
    return p_;
  }
};
{% endhighlight %}


## Return code that should allways be success

There are C functions that return an error code, but there is no reason for the
function to fail assuming that preconditions are met.

Say for example `CloseHandle` in Windows to close a handle returned by
`CreateEvent`. The documentation is not very clear, but there is no reason for
it to fail if the handle is valid: to close the handle for an event only the
CPU and memory get involved.


-----------------
# WORK IN PROGRESS:

- Ignore error

- Termination is sometimes a good option

- also see std::thread

{% highlight c++ linenos %}
class relocker
{
  std::mutex & m_;

public:
  explicit relocker(std::mutex & m) :
    m_{ m }
  {
    m_.unlock();
  }

  ~relocker() // <- this terminates
  {
    m_.lock(); // <- if this throws
  }
};
{% endhighlight %}

- Flushing

- fclose

- Bad APIs

- Rollback

- Scope guard: cleanup

- Scope guard: flushing

# References

ReleaseMutex function<br/>
[https://msdn.microsoft.com/en-us/library/windows/desktop/ms685066(v=vs.85).aspx][release-mutex]

[release-mutex]: https://msdn.microsoft.com/en-us/library/windows/desktop/ms685066(v=vs.85).aspx
