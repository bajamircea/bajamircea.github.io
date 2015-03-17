---
layout: post
title: 'Classic RAII'
categories: coding cpp
---

RAII (Resource Aquisition Is Initialization) is a complex name that does not do
justice to one of the most useful programming idioms. This article describes
the options and issues when using this coding style, with the full example of
the [copy file example][copy-file] rewritten.


## Introduction

RAII is a resource management technique developed in C++ by Bjarne Stroustrup
and Andrew Koenig in the 1980s. It largely eliminates the need to collect
garbage, by not creating garbage in the first place.

In this article I'll describe what I call the **classical RAII**. As we'll see
later, there are some minor variations.

RAII fundamentally works by wrapping a resource in an object, initializing the
resource in the constructor. If the constructor succeeds, the destructor will
cleanup the resource. If the constructor fails, it throws an exception, and
conveniently the destructor is not called.

When opening a file with `fopen`, the resource that needs to be wrapped is a
`FILE *`. In the constructor we need to open the file. If opening the file
succeeds, the destructor will call `fclose`. If opening a file fails (e.g.
because of the file permissions) the constructor throws an exception and the
destructor is not called.

A class to wrap the `FILE *` in a classical RAII idiom would look like:

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
`FILE *`. To open two files and use them one needs to construct them like this:

{% highlight c++ linenos %}
file src("src.bin", "rb");
file dst("dst.bin", "wb");
// more
// code
// here
{% endhighlight %}

On the happy path this will create two `file` instances, each in charge with
it's own `FILE *`. When they go out of scope they will each be destructed,
closing each file, in the reverse order of the declaration: `src` is created
first, and destructed last. The scope of `dst` is surrounded by the scope of
`dst`.

If say the creation of `dst` fails, then the execution exits the scope,
ensuring that the destructor if `src` is called closing it's already opened
`FILE *`. This provides **exception safety** for the stack resources.


## Issues

No real issues, more like things to pay attention to:

- Ensure the destructors don't throw
- Pay attention to the copy constructor and assignment operator. One easy
  option is to delete them to ensure that destructor does not try to release
  twice the same resource.

## Full code

### main.cpp
{% highlight c++ linenos %}
#include "file.h"
#include <vector>
#include <iostream>

void copy_file()
{
  file src("src.bin", "rb");
  file dst("dst.bin", "wb");
  std::vector<char> buffer(1024);

  do
  {
    size_t read_count = src.read(buffer.data(), buffer.size());

    if (read_count > 0)
    {
      dst.write(buffer.data(), read_count);
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
  size_t write_count = fwrite(buffer , 1, size, f_);
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


## Summary

RAII coding style avoids repetition and reduces errors through encapsulation
and locality of resource management. It is a very important programming idiom,
with an unfortunate name unfortunately. **Usage of some RAII variant is highly
recommended**.


[copy-file]:     {% post_url 2015-03-12-copy-file-no-error %}
[if-error-else]: {% post_url 2015-03-14-if-error-else %}
