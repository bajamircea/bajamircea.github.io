---
layout: post
title: 'Special class operations. Lifetime examples'
categories: coding cpp
---

A few example of customizing constructor, destructor, copy and move operations.


## Just constructor

**Most of the time, you only need to write a constructor**.

Here is a sample class that implements a thread pool.

It assumes there is a class `stoppable_thread` which requires a `void()`
function in the constructor (and starts the thread), and with a destructor that
signals to stop and joins the thread.

{% highlight c++ linenos %}
#include "stoppable_thread.h"
#include <list>

class thread_pool
{
public:
  thread_pool(size_t size, std::function<void()> fn)
  {
    for (size_t i; i < size, ++i)
    {
      threads_.emplace_back(fn);
    }
  }

private:
  std::list<stoppable_thread> threads_;
};
{% endhighlight %}

The way it works is simple. Other than the constructor, the `thread_pool` class
relies on the behaviour of the member variable.

So when the class is destructed, it relies on the list to destroy its elements
(and stop the threads in the thread pool).

If we try to copy the class, the compiler will try to copy the list. The list
will try to copy the values of type `stopable_thread`, and most likely this is
non-copiable, hence it will fail at compile time.

If we try to move the class, the compiler will try to move the list. That will
essentially just move the list sentinel pointers, so it will work.

Which leaves us with what happens if the `thread_pool` constructor fails in the
body, e.g. if it creates a few threads, but if fails for one. Then that will
throw, but the compiler will destroy the list. This will destroy its elements,
stopping the threads that were created before failing.


## Buffer

Here is a `buffer` class that can be copied and moved. This is just an example.
For production code you should consider using `std::vector` instead.

{% highlight c++ linenos %}
class buffer
{
public:
  explicit buffer(size_t size = 0) :
    p_{ new char[size] },
    size_{ size }
  {
  }

  ~buffer()
  {
    delete[] p_;
  }

  buffer(const buffer & other) :
    p_{ new char[other.size_] },
    size_{ other.size_ }
  {
    for(size_t i = 0 ; i < size_ ; ++i)
    {
      p_[i] = other.p_[i];
    }
  }

  buffer & operator=(const buffer & other)
  {
    if (this != &other)
    {
      delete[] p_;
      p_ = nullptr; // set p_ in case new fails later
      size_ = other.size_;
      p_ = new char[size_];
      for(size_t i = 0 ; i < size_ ; ++i)
      {
        p_[i] = other.p_[i];
      }
    }

    return *this;
  }

  buffer(buffer && other) noexcept :
    p_{ other.p_ },
    size_{ other.size_ }
  {
    // other.size_ need not be set, it's not used in
    // the destructor
    other.p_ = nullptr;
  }

  buffer & operator=(buffer && other) noexcept
  {
    // use temporary to deal with move assignment
    // when (this == &other)
    char * temp = other.p_;
    other.p_ = nullptr;
    delete[] p_;
    p_ = temp;
    size_ = other.size_;

    return *this;
  }

  // more methods here ...

private:
  char * p_;
  size_t size_;
};
{% endhighlight %}


## Non copyable

Here is a utility class that can be derived from to delete the copy constructor
and copy assignment (same idea as `boost::noncopyable`).

{% highlight c++ linenos %}
struct noncopyable
{
  noncopyable(const noncopyable &) = delete;
  noncopyable & operator=(const noncopyable &) = delete;
protected:
  noncopyable() { }
  ~noncopyable() { }
};
{% endhighlight %}


## Resource template

Here is a template to wrap resources to ensure they get closed/released.
Usually such resources can't be copied (we use `noncopyable` for this), but can
be moved.

{% highlight c++ linenos %}
#include "noncopyable.h"

template<class resource_traits>
struct unique_resource :
  private noncopyable
{
  explicit unique_resource(
    typename resource_traits::value_type x = resource_traits::invalid_value
    ) noexcept :
    value{ x }
  {
  }

  ~unique_resource()
  {
    if (is_valid())
    {
      resource_traits::close(value);
    }
  }

  unique_resource(unique_resource && other) noexcept :
    value{ other.value }
  {
    other.value = resource_traits::invalid_value;
  }

  unique_resource & operator=(unique_resource && other) noexcept
  {
    typename resource_traits::value_type temp = other.value;
    other.value = resource_traits::invalid_value;
    if (is_valid())
    {
      resource_traits::close(value);
    }
    value = temp;
    return *this;
  }

  bool is_valid() noexcept
  {
    return (resource_traits::invalid_value != value);
  }

  typename resource_traits::value_type value;
};
{% endhighlight %}

And here is a sample usage to handle `FILE *` [using a slim RAII][slim-raii] approach.

{% highlight c++ linenos %}
#include "unique_resource.h"
#include <cstdio>
#include <stdexcept>
#include <iostream>

struct file_resource_traits
{
  using value_type = FILE *;
  static constexpr value_type invalid_value = nullptr;
  static void close(value_type x) noexcept { fclose(x); }
};

using file = unique_resource<file_resource_traits>;

file open_a_file()
{
  file x{ fopen("a.cpp", "r") };
  if (!x.is_valid())
  {
    throw std::runtime_error("Failed to open file");
  }
  return x;
}

int main()
{
  try
  {
    file x{ open_a_file() };
    // use x.value ...
  }
  catch(const std::exception & e)
  {
    std::cerr << "Exception: " << e.what() << std::endl;
    return 1;
  }
  std::cout << "All good!\n";
  return 0;
}
{% endhighlight %}


[slim-raii]:     {% post_url 2015-03-22-slim-raii %}

