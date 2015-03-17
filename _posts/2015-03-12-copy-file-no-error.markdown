---
layout: post
title: 'Copy File No Error'
categories: coding c
---

This short article proposes a simple example, that copies the contents of a
file to another, with no error handling. Future articles will use this example
as a base of comparison. This is the second from a series of articles that
looks at how to deal with C APIs, resources and error handling.


## Summary

I'm using the `<stdio.h>` functions from [the previous article][c-api-objects]
to copy the contents of a file `src.bin` to `dst.bin` using a 1k buffer. It
opens both files, allocates the buffer, loops reading from one and writing to
another until it gets to the end of the source file.

The code ignores all error handling. That makes it **wrong**, but otherwise an
easy read.

The sample with no error handling has **27 lines** of code.


## Full code

{% highlight c++ linenos %}
#include <stdio.h>
#include <stdlib.h>

int main ()
{
  FILE * src = fopen("src.bin", "rb");
  FILE * dst = fopen("dst.bin", "wb");
  const size_t buffer_size = 1024;
  char * buffer = malloc(buffer_size);

  for(;;)
  {
    size_t read_count = fread(buffer, 1, buffer_size, src);
    fwrite(buffer , 1, read_count, dst);
    fputs(".", stdout);

    if (feof(src))
    {
      fputs("\nSUCCESS\n", stdout);
      break;
    }
  }

  free(buffer);
  fclose(dst);
  fclose(src);
}
{% endhighlight %}


[c-api-objects]:    {% post_url 2015-03-06-c-api-objects %}
