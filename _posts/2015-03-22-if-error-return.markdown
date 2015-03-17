---
layout: post
title: 'If Error Return'
categories: coding cpp
---

This article looks at handling errors in C APIs using an if-error-return
codding pattern which uses a slimmed down RAII variant.  variant. It describes
the issues and options when using this coding style, with the full example of
the [copy file example][copy-file] rewritten.


## Introduction


## Issues



## Full code

{% highlight c++ linenos %}
#include <stdio.h>
#include <stdlib.h>

struct file
{
  FILE * p;

  file(FILE * x) :
    p(x)
  {
  }

  ~file()
  {
    if (p)
    {
      fclose(p);
    }
  }

  file(const file &) = delete;
  file & operator=(const file &) = delete;
};

struct mem
{
  char * p;

  mem(char * x) :
    p(x)
  {
  }

  ~mem()
  {
    if (p)
    {
      free(p);
    }
  }

  mem(const mem &) = delete;
  mem & operator=(const mem &) = delete;
};

int main ()
{
  file src(fopen("src.bin", "rb"));
  if ( ! src.p)
  {
    perror("Failed to open source file");
    return 1;
  }

  file dst(fopen("dst.bin", "wb"));
  if ( ! dst.p)
  {
    perror("Failed to open destination file");
    return 1;
  }

  const size_t buffer_size = 1024;
  mem buffer(reinterpret_cast<char *>(malloc(buffer_size)));
  if ( ! buffer.p)
  {
    fputs("Failed to allocate buffer\n", stderr);
    return 1;
  }

  do
  {
    size_t read_count = fread(buffer.p, 1, buffer_size, src.p);
    if ((read_count != buffer_size) && ferror(src.p))
    {
      perror("Failed to read from source file");
      return 1;
    }

    if (read_count > 0)
    {
      size_t write_count = fwrite(buffer.p, 1, read_count, dst.p);
      if (write_count != read_count)
      {
        perror("Failed to write to destination file");
        return 1;
      }
      fputs(".", stdout);
    }
  } while ( ! feof(src.p));

  fputs("\nSUCCESS\n", stdout);
  return 0;
}
{% endhighlight %}


## Summary



[copy-file]:     {% post_url 2015-03-12-copy-file-no-error %}
