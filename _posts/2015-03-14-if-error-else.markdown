---
layout: post
title: 'If Error Else'
categories: coding c
---

This article looks at handling errors in C APIs using a if-error-else codding
pattern. It describes the issues and option when using this coding stile, with
the full example of the [copy file example][copy-file] written to test error
using if-error-else blocks.


## Introduction

If opening a file fails (e.g. because of the file permissions) `fopen` returns
a null pointer. The code has to test for this case. One way is to use
if-else blocks like below:

{% highlight c++ linenos %}
FILE * f = fopen("file.name", "rb");
if (f)
{
  // more
  // code
  // here

  fclose(f);
}
else
{
  perror("Failed to open file.name");
}
{% endhighlight %}

One problem is that, as more code gets added, both releasing resources
(`fclose`) and logging the error (`perror`) move away from the call they relate
to (`fopen`). That can be partially addressed as:

{% highlight c++ linenos %}
FILE * f = fopen("file.name", "rb");
if ( ! f)
{
  perror("Failed to open file.name");
}
else
{
  // more
  // code
  // here

  fclose(f);
}
{% endhighlight %}

In this case it's just `fclose` that moves away from the related function
(`fopen`) as more code gets added. I refer to this coding style the
**if-error-else coding pattern**.

A minor issue is that I find reading the `else` in the code above involves a
double negation: it happens for `! ! f`, which I can figure out it means `f`,
which means `0 != f`. I find the following approach a bit more readable.

{% highlight c++ linenos %}
if (0 == f)
{
  // handle error
}
else // 0 != f
{
  // file opened
}
{% endhighlight %}

For functions that need not release any resource, like `fwrite`, the error
handing stays close to the function it relates to:

{% highlight c++ linenos %}
int write_count = fwrite(buffer , 1, read_count, dst);
if (write_count != read_count)
{
  perror("Failed to write to destination file");
}
else
{
  // more
  // code
  // here
}
{% endhighlight %}


## Issues

The first issue with this approach is the repetition. It's a major issue.
Every time we invoke `fopen` using this coding pattern we need to repeat:

- the if condition
- the error handling
- the else keyword
- the `fclose` call
- and 4 curly brackets

For the [copy file example][copy-file] this approach takes the code from 27
lines of code to **69 lines** of code, more than double.

So much repetition has cascading effects. Chances of coding mistakes increases:
usually there are some genuine mistakes and lots of incorrect error text
messages. For example the message `"Failed to open source file"` might be also
logged when failing to open the destination file. The code bloat distracts from
the intended functionality and slows down reading. Remember code is usually
read more times than it's written.

The code repetition can be addressed using a C++ RAII approach.

The second issue is the ever growing nesting depth. For the simple example
below we get to **6 levels** deep compared with 2 levels in the example with no
error handling.

## Full code

{% highlight c++ linenos %}
#include <stdio.h>
#include <stdlib.h>

int main ()
{
  int return_value = -1;
  FILE * src = fopen("src.bin", "rb");
  if (0 == src)
  {
    perror("Failed to open source file");
  }
  else
  {
    FILE * dst = fopen("dst.bin", "wb");
    if (0 == dst)
    {
      perror("Failed to open destination file");
    }
    else
    {
      const int buffer_size = 1024;
      char * buffer = malloc(buffer_size);
      if (0 == buffer)
      {
        fputs("Failed to allocate buffer\n", stderr);
      }
      else
      {
        for(;;)
        {
          int read_count = fread(buffer, 1, buffer_size, src);
          if (read_count != buffer_size)
          {
            if (ferror(src))
            {
              perror("Failed to read from source file");
              break;
            }
          }

          if (read_count > 0)
          {
            int write_count = fwrite(buffer , 1, read_count, dst);
            if (write_count != read_count)
            {
              perror("Failed to write to destination file");
              break;
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

        free(buffer);
      }

      fclose(dst);
    }

    fclose(src);
  }
  return return_value;
}
{% endhighlight %}


[copy-file]:    {% post_url 2015-03-12-copy-file-no-error %}
