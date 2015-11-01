---
layout: post
title: 'Classic RAII'
categories: coding cpp
---

RAII (Resource Aquisition Is Initialization) is a difficult to say name that
does not do justice to **one of the most useful programming idioms**. This
article describes the classic way of using RAII, with the full example of the
[copy file example][copy-file] rewritten.


## Introduction

RAII is a resource management technique developed in C++ by Bjarne Stroustrup
and Andrew Koenig in the 1980s. It largely eliminates the need to collect
garbage, by not creating garbage in the first place and providing ease of use
and correctness when dealing with resources (e.g. memory, files, etc.).

In this article I'll describe what I call the **classical RAII**. As we'll see
later, there are some minor variations.

RAII fundamentally works by wrapping a resource in an object, initializing the
resource in the constructor. If the constructor succeeds, the object can be
used and the destructor will automatically cleanup the resource. If the
constructor fails, it throws an exception, the object can't be used and
conveniently the destructor is not called.

When opening a file with `fopen`, the resource that needs to be wrapped is a
`FILE *`. In the constructor we need to open the file. If opening the file
succeeds, the destructor will call `fclose`. If opening a file fails (e.g.
because of the file permissions) the constructor throws an exception and the
destructor is not called.

A class to wrap the `FILE *` using a classical RAII idiom would look like:

{% highlight c++ linenos %}
class file
{
  FILE * f_;

public:
  file(const char * file_name, const char * mode)
  {
    f_ = fopen(file_name, mode);
    if ( ! f_)
    {
      perror(0);
      throw std::runtime_error("Failed to open file");
    }
  }

  ~file()
  {
    fclose(f_);
  }

  // methods
  // that use f_
  // assume f_ is not null
};
{% endhighlight %}

Notice that the construction has two possible outcomes: the constructor
succeeds or it throws.

If `fopen` succeeds, then the constructor succeeds and the instance has a `f_`
that is not null. `f_` can be used in other `file` class methods without the
need to test for null, including in the destructor. This behaviour explains the
complicated RAII name (Resource Aquisition Is Initialization): when the
resource is aquired, the object is fully initialized.

If `fopen` fails, the constructor throws: the object is not constructed, the
user can't call methods and the destructor is not called.


## Advantages

First of all notice how `fclose` can be arranged to be placed close to the
matching `fopen` (**locality**), they are no longer getting further away as
non-related code gets added.

Secondly notice how the `file` class **encapsulates** the logic of managing the
`FILE *`. To open and use two files, one needs to construct them like this:

{% highlight c++ linenos %}
file src{ "src.bin", "rb" };
file dst{ "dst.bin", "wb" };
// more
// code
// here
{% endhighlight %}

On the happy path this will create two `file` instances, each in charge with
its own `FILE *`. When they go out of scope they will each be destructed,
closing each file, in the reverse order of the declaration: `src` is created
first, and destructed last. The scope of `dst` is surrounded by the scope of
`dst`.

If say the creation of `dst` fails, then the execution exits the scope,
ensuring that the destructor if `src` is called closing its already opened
`FILE *`. This provides **exception safety** for the resources on the stack.


## Issues

No real issues, more like things to pay attention to:

- Ensure the destructors don't throw
- Pay attention to the copy constructor and assignment operator. One easy
  option is to delete them to ensure that destructor does not try to release
  twice the same resource.

Note: I used std::unique_ptr as a buffer to have a comparable solution that
allocates on the heap like the C example, without initializing with 0 like
std::vector would.

## Full code

### main.cpp
{% highlight c++ linenos %}
#include "file.h"
#include <iostream>
#include <memory>

void copy_file()
{
  file src{ "src.bin", "rb" };
  file dst{ "dst.bin", "wb" };
  constexpr size_t buffer_size{ 1024 };
  auto buffer = std::make_unique<char[]>(buffer_size);

  do
  {
    size_t read_count = src.read(buffer.get(), buffer_size);

    if (read_count > 0)
    {
      dst.write(buffer.get(), read_count);
      std::cout << '.';
    }
  } while ( ! src.is_eof());
}

int main ()
{
  try
  {
    copy_file();

    std::cout << "\nSUCCESS\n";
    return 0;
  }
  catch(const std::exception & e)
  {
    std::cerr << e.what() << std::endl;
    return 1;
  }
}
{% endhighlight %}


### file.h
{% highlight c++ linenos %}
#pragma once

#include <cstdio>

class file
{
  FILE * f_;

public:
  file(const char * file_name, const char * mode);
  ~file();

private:
  file(const file &) = delete;
  file & operator=(const file &) = delete;

public:
  size_t read(char * buffer, size_t size);
  void write(const char * buffer, size_t size);
  bool is_eof();

private:
  void log_and_throw(const char * message);
};
{% endhighlight %}


### file.cpp
{% highlight c++ linenos %}
#include "file.h"
#include <stdexcept>

file::file(const char * file_name, const char * mode)
{
  f_ = fopen(file_name, mode);
  if ( ! f_)
  {
    log_and_throw("Failed to open file");
  }
}

file::~file()
{
  fclose(f_);
}

size_t file::read(char * buffer, size_t size)
{
  size_t read_count = fread(buffer, 1, size, f_);
  if ((read_count != size) && ferror(f_))
  {
    log_and_throw("Failed to read from file");
  }
  return read_count;
}

void file::write(const char * buffer, size_t size)
{
  size_t write_count = fwrite(buffer, 1, size, f_);
  if (write_count != size)
  {
    log_and_throw("Failed to write to file");
  }
}

bool file::is_eof()
{
  return feof(f_);
}

void file::log_and_throw(const char * message)
{
  perror(0);
  throw std::runtime_error(message);
}
{% endhighlight %}


## Code discussion

We now have three source files, with a total of 108 lines of code. The code to
actually copy the file (in `copy-file` in `main.cpp`) takes **15 lines** of
code however, which is shorter even than the 20 lines of code in [the version
without any error checking][copy-file] mainly because the `file` class takes
care of the now trivial issues of checking for errors and releasing resources.

I believe this is one aspect of what Bjarne Stroustrup [means when he
says][finally-explain] that **"in realistic systems, there are far more
resource acquisitions than kinds of resources, so the RAII technique leads to
less code**. In this example the `file` class is used only twice but this is
compensated by the fact that library classes are used a lot (e.g. think
`std::vector`).


## Summary

RAII coding style avoids repetition and reduces errors through encapsulation
and locality of resource management. It is a very important programming idiom,
with a difficult name unfortunately. **Usage of some RAII variant is highly
recommended**.


[copy-file]:     {% post_url 2015-03-12-copy-file-no-error %}
[if-error-else]: {% post_url 2015-03-14-if-error-else %}
[finally-explain]:     http://www.stroustrup.com/bs_faq2.html#finally
