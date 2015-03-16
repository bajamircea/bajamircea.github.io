---
layout: post
title: 'If Error Else'
categories: coding c
---

This article looks at handling errors in C APIs using an if-error-else codding
pattern. It describes the issues and options when using this coding style, with
the full example of the [copy file example][copy-file] rewritten.


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
Every time we call `fopen` using this coding pattern we also need to repeat:

- the if condition
- the error handling
- the else keyword
- the `fclose` call
- and 4 curly brackets

For the [copy file example][copy-file] this approach takes the code from 27
lines of code to **68 lines** of code, more than double. So much repetition has
cascading effects that results on errors when coding and time waste when
reading code.

On one side this coding style at least tries to check systematically for
errors. But, because of the repetition, there is repeated scope for error that
for any but non-trivial projects results in mistakes that cumulate to a muddy
code quality.

One apparently trivial issue is the case of iregular error checking. Notice how
in the example below `fread` does not have a `else` bracnch, instead it breaks
out of the `for` loop on error. This kind of things have no impact on execution
they just slow down reading.

Then there are lots of incorrect error test messages. The code to open the
file was copy-pasted and the same message `"Failed to open source file"` might
also be logged when failing to open the destination file.

Then there is the case of the missing or incorrect error handling.

The **code repetition can be addressed using a C++ RAII approach**.

The second issue is the ever growing nesting depth. For the simple example
below we get to **6 levels** deep compared with 2 levels in the example with
[no error handling][copy-file].


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
          if ((read_count != buffer_size) && ferror(src))
          {
            perror("Failed to read from source file");
            break;
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


## Summary

You need to understand how to handle errors. Logically the code above does the
right thing, in that it is what we want the computer to execute. However as a
coding style the if-error-else approach is verbose and error prone. **Don't use
it**.


[copy-file]:    {% post_url 2015-03-12-copy-file-no-error %}
