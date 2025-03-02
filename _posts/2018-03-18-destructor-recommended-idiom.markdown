---
layout: post
title: 'Destructors: Recommended Idiom for C++11/17'
categories: coding cpp
---

The C++11/17 recommended idiom for destructor exception safety for most C++
applications. Realistic cases of how to handle code that destructors call.
Cosmic rays damaging CPU or memory and bugs (OS, compiler, hardware) not
included.


# Introduction

Here is the executive summary for a good idiom given the current language
rules: **Do not exit with exceptions from destructors. If you still contemplate
exiting with exception from a destructor: avoid it.** Avoidance options
include:

- Catch thrown exceptions inside the destructor.
- Terminate for fatal errors.
- Create a separate function that throws and don't forget to call it (outside
  destructors).


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
value (often `nullptr`) or testing for a `bool` member variable or sometimes
can be skipped because it's performed elsewhere.

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

NOTE: The `noexcept` defaults are currently different for move hence the need to
be explicit.

NOTE: The test can be skipped for things like `free` and `delete` that are
documented to do nothing if the pointer is zero/`nullptr`. In the code below
the test is commented, but left as an example for other cases.

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
    // if (p_ != nullptr) // <-
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
      // if (p_ != nullptr) // <-
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

Also note that in the destructor I'm not setting the resource value to invalid.
The compiler might optimise it out as it knows that after the object is
destroyed, it can't be accessed (except that everything can be accessed if one
uses dangling pointers/references which you shouldn't).

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
releasing memory.  Also like `free`, `delete` is documented to accept a
(otherwise invalid value) of `nullptr` (and does nothing).  It is different in
that it calls the destructor of the object. That theoretically could throw, but
if you follow this idiom it won't.

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


## Return code that should always be success

There are C functions that return an error code, but there is no reason for the
function to fail assuming that preconditions are met.

Say for example `CloseHandle` in Windows to close a handle returned by
`CreateEvent`. The documentation is not very clear, but there is no reason for
it to fail if the handle is valid: to close the handle for an event only the
CPU and memory get involved.

Sometimes the preconditions are more complex with regards to the validity of
the input. For example [ReleaseMutex][release-mutex] requires that the calling
thread owns the mutex object, but still this can be relatively easy ensured by
correct code.

There are two options of dealing with the returned error code for this
situations: ignore the error, or terminate. Ignoring the error is less code.
Terminating will give you the best chance to discover that the assumption or
usage is incorrect. People argue at length for one option or another, but I
think that if you're confident something will not happen neither choice will
make much of a difference.

{% highlight c++ linenos %}
// here are the two options,
// assuming the invalid value is NULL
// (which is not true for all HANDLE)

~X::X()
{
  if (NULL != h_) {
    static_cast<void>(::CloseHandle(h_));
  }
}

~Y::Y()
{
  if (NULL != h_) {
    BOOL result = ::CloseHandle(h_);
    if (0 == result) {
      std::terminate();
    }
  }
};
{% endhighlight %}

Just to make clear: `CloseHandle` for files might or might not be different from
the one for events. For the files see the flushing/`fclose` section below. It
will turn out that if you're not sure what happens for files and you reuse the
same class to `CloseHandle` on destruction, then you're better off ignoring the
return code.

# Complex cases

In this section I'll describe situations that are counter-intuitive and error
prone.

## Termination is a better option

Termination is sometimes a better option. There is a good explanation why
`std::thread` [terminates if not joined][std-thread]. The summary of it is that
the underlying APIs expect the user to come with a strategy to stop the thread
in a controlled way. If the `std::thread` is destroyed, but the thread is still
running, it means that the strategy to stop the thread was not implemented (or
not implemented correctly) and the risk is that the thread continues to access
shared data that will go out of scope, corrupting and crashing in ways that are
difficult to point to a cause (as opposed to termination that points to the
relevant `std::thread` object corresponding to the still running thread).

Example: The class below can be used to create a scope where a `std::mutex` is
unlocked and the mutex is locked back on scope exit (including exceptions). The
`lock` method could throw (it should not for correct usage, but the
documentation is not 100% clear as it depends on platform APIs). If it does,
the mutex is not locked. The same reasoning as for `std::thread` applies.
Better to terminate then corrupt and crash in unpredictable ways.

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

  relocker(const relocker &) = delete;
  relocker & operator=(const relocker &) = delete;
};
{% endhighlight %}


## Flushing required

This is the case of APIs that buffer writes, where to improve performance write
returns success early, after it just copied data to a buffer, before it
actually writes to the destination. This type of APIs require you to flush and
it's then that an error is returned for data from a previous write.

The reality of most distributed systems is that it's really difficult to ensure
the data has been persisted at the destination. Even for a computer there are
multiple levels at buffering at API level, OS level, even the hard disk might
confirm write early (maybe speculating that it will have enough capacitive
power to persist the internal buffers in case of a external power supply loss).

A typical case is `fclose`, though `fclose` does not just flush. A typical
`fclose does several things:

- It verifies for potentential invalid inputs might return early
- It might flush (it will not flush for a file that's read, but it might flush
  even if `fflush` has just been called)
- It might call some close method (that seems the case at least for network
  mapped files). A close error might override the flush error.
- It frees used memory, regardless of errors for flush and close
- It returns an error if flush or close failed

{% highlight c++ linenos %}
// WARNING: below is pseudocode, not real code
int fclose(FILE * fp)
{
  int r;
  if (failed precondition check)
  {
    return EOF;
  }
  r = flush result;
  if (failure to close)
  {
    r = EOF;
  }
  free used memory;
  return r;
}
{% endhighlight %}

To deal with the situation:

1. Wrap `FILE *` in a resource class. In the destructor ignore errors.
2. Create a function that throws on `fclose`
3. Don't forget to call that function (if you wrote to the file and all went well up to that point)

{% highlight c++ linenos %}
// 1
class file
{
  FILE * f_;
public:
  explicit file(FILE * f) : f_{ f }
  {
  }

  ~file()
  {
    if (f_ != nullptr)
    {
      static_cast<void>(fclose(f_)); // <-
    }
  }

  file(const file &) = delete;
  file & operator=(const file &) = delete;

  FILE * get()
  {
    return f_;
  }

  FILE * release() noexcept
  {
    FILE * tmp = f_;
    f_ = nullptr; // <-
    return tmp;
  }
};

// 2
void close_file(file_raii & x)
{
  int result = std::fclose(x.release()); // <-
  if (result != 0)
  {
    throw std::exception(); // <-
  }
}

void write_to_file(const char * file_name)
{
  file f{ fopen(file_name, "wb") };
  if (f.get() == nullptr)
  {
    throw std::exception();
  }

  if (1 != fwrite('x', 1, 1, f.get()))
  {
    throw std::exception();
  }

  // 3
  close_file(f); // <-
}
{% endhighlight %}

The code above checks for all errors and reports only one:
- If `fclose` fails then `write_to_file` fails with an exception (because
  `fwrite` reported success, but flushing fails later)
- If `fwrite` fails then its exception propagates, though `fclose` is called
  from the destructor and resources are cleaned

## Bad APIs

Sometimes the APIs a broken. Oh well, good luck, do your best.

{% highlight c %}
The EINTR error is a somewhat special case.  Regarding the EINTR
error, POSIX.1-2013 says:

       If close() is interrupted by a signal that is to be caught, it
       shall return -1 with errno set to EINTR and the state of
       fildes is unspecified.

This permits the behavior that occurs on Linux and many other
implementations, where, as with other errors that may be reported by
close(), the file descriptor is guaranteed to be closed.  However, it
also permits another possibility: that the implementation returns an
EINTR error and keeps the file descriptor open.  (According to its
documentation, HP-UX's close() does this.)  The caller must then once
more use close() to close the file descriptor, to avoid file
descriptor leaks.  This divergence in implementation behaviors
provides a difficult hurdle for portable applications, since on many
implementations, close() must not be called again after an EINTR
error, and on at least one, close() must be called again.  There are
plans to address this conundrum for the next major release of the
POSIX.1 standard.
{% endhighlight %}


## External cleanup/rollback

A common misconception is that destructors alone are enough to deal with
cleanup/rollback that is external to the CPU and memory machinery.

For example when writing a file on a disk, using a destructor to ensure that
the file is removed in case of failure is not enough.

`free` and `delete` can fail due to bugs in software or hardware or ... cosmic
rays, but removing a file can fail more often, hence cannot be guaranted to
succeed.

For example when writing product tests we want each test to start with a clean
state and not fail because of artefacts produced by another test. Performing
cleanup at the end of the test is frail.

{% highlight c++ linenos %}
class file_remover
{
  std::string file_name_;
public:
  explicit file_remover(const std::string & file_name) :
    file_name_{ file_name }
  {
  }

  ~file_remover()
  {
    try
    {
      remove_file(file_name_);
    } catch(...)
    {
    }
  }
};

void bad_test_1()
{
  file_remover rollback{ "file.txt" };
  write_file("file.txt"); // throws on failure
  ASSERT_TRUE(file_exits("file.txt"));
}

void bad_test_2()
{
  ASSERT_FALSE(file_exits("file.txt"));
}
{% endhighlight %}

This approach above is not correct, if the first test fails to write, removing
the file will also fail, the second test will also fail.

The correct approach often needs to accept and deal with the situation
where the file was partially written (such as from a previous failed run).
Counterintuitively cleanup has to be done before the action, not after.

{% highlight c++ linenos %}
void test_1()
{
  write_file("file.txt");
  ASSERT_TRUE(file_exits("file.txt"));
}

void test_2()
{
  remove_file{ "file.txt" };
  ASSERT_FALSE(file_exits("file.txt"));
}
{% endhighlight %}

In rare cases one could use a combination of the two approaches if cleanup has
a high chance to succeed even if the action fails.

# References

`close` function<br/>
[http://man7.org/linux/man-pages/man2/close.2.html][close]

`free` function<br/>
[http://www.cplusplus.com/reference/cstdlib/free/][free]

`fclose` function<br/>
[http://www.cplusplus.com/reference/cstdio/fclose/][fclose]

`CloseHandle` function<br/>
[https://msdn.microsoft.com/en-us/library/windows/desktop/ms724211(v=vs.85).aspx][close-handle]

`ReleaseMutex` function<br/>
[https://msdn.microsoft.com/en-us/library/windows/desktop/ms685066(v=vs.85).aspx][release-mutex]

Rationale for `std::thread` destructor terminating<br/>
[http://www.open-std.org/jtc1/sc22/wg21/docs/papers/2008/n2802.html][std-thread]


[close]: http://man7.org/linux/man-pages/man2/close.2.html
[free]: http://www.cplusplus.com/reference/cstdlib/free/
[fclose]: http://www.cplusplus.com/reference/cstdio/fclose/
[close-handle]: https://msdn.microsoft.com/en-us/library/windows/desktop/ms724211(v=vs.85).aspx
[release-mutex]: https://msdn.microsoft.com/en-us/library/windows/desktop/ms685066(v=vs.85).aspx
[std-thread]: http://www.open-std.org/jtc1/sc22/wg21/docs/papers/2008/n2802.html
