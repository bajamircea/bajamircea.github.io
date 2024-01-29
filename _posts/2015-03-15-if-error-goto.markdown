---
layout: post
title: 'If Error Goto'
categories: coding c
---

This article looks at handling errors in C APIs using an if-error-goto coding
pattern which is an improvement over the [if-error-else][if-error-else]
variant.


## Introduction

If opening a file fails (e.g. because of the file permissions) `fopen` returns
a null pointer. The code has to test for this case. If an error happened, after
logging the error `goto` is used to jump to the section at the end of the
function where cleanup is performed.

{% highlight c++ linenos %}
FILE * f = 0;

// after all inits:
f = fopen("file.name", "rb");
if ( ! f)
{
  perror("Failed to open file.name");
  goto end_label;
}

// more
// code
// here

end_label:

if (f)
{
  fclose(f);
}
{% endhighlight %}

I refer to this coding style the **if-error-goto coding pattern**.

Compared with the [if-error-else][if-error-else] style, it addresses the
nesting problem: the sample code below goes to **3 levels** deep down from 6
levels.

It also addresses the irregular error handling. Inside the `for` loop one would
still use `goto` in case of an error (instead of choosing to `break` from the
loop).

## Issues

This style still has the issue of too much repetition, and the same comments
from the [if-error-else][if-error-else] style apply here as well. Every time we
invoke `fopen` using this coding pattern we need to repeat:

- the if condition
- the error handling
- the goto
- the if condition for `fclose`
- the `fclose` call
- and 4 curly brackets

For the [copy file example][copy-file] this approach takes the code from 28
lines of code to **78 lines** of code, almost triple.

The code repetition can be addressed using a C++ RAII approach.

The other objectionable issue is the usage of `goto`. It is a bit antiquated,
but not really harmful, because it's regular, not jumping all over the place.


## Full code

{% highlight c++ linenos %}
#include <stdio.h>
#include <stdlib.h>

int main ()
{
  int return_value = 1;
  FILE * src = 0;
  FILE * dst = 0;
  char * buffer = 0;

  src = fopen("src.bin", "rb");
  if ( ! src)
  {
    perror("Failed to open source file");
    goto end;
  }

  dst = fopen("dst.bin", "wb");
  if ( ! dst)
  {
    perror("Failed to open destination file");
    goto end;
  }

  const size_t buffer_size = 1024;
  buffer = malloc(buffer_size);
  if ( ! buffer)
  {
    fputs("Failed to allocate buffer\n", stderr);
    goto end;
  }

  for(;;)
  {
    size_t read_count = fread(buffer, 1, buffer_size, src);
    if ((read_count != buffer_size) && ferror(src))
    {
      perror("Failed to read from source file");
      goto end;
    }

    if (read_count > 0)
    {
      size_t write_count = fwrite(buffer, 1, read_count, dst);
      if (write_count != read_count)
      {
        perror("Failed to write to destination file");
        goto end;
      }
      fputs(".", stdout);
    }

    if (feof(src))
    {
      return_value = 0;
      fputs("\nSUCCESS\n", stdout);
      break;
    }
  }

end:
  if (buffer)
  {
    free(buffer);
  }

  if (dst)
  {
    fclose(dst);
  }

  if (src)
  {
    fclose(src);
  }

  return return_value;
}
{% endhighlight %}


## Summary

While an improvement over the if-error-else approach, the if-error-goto is
still verbose, repetitive and error prone.  **Don't use it**, unless for
whatever reason you can't use C++ and RAII.


[copy-file]:     {% post_url 2015-03-12-copy-file-no-error %}
[if-error-else]: {% post_url 2015-03-14-if-error-else %}
