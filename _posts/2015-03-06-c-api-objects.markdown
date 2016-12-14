---
layout: post
title: 'C Objects'
categories: coding c
---

This article looks at the options for implementing objects in the C language
from the C API user's point of view. This is the first from a series of
articles that looks at how to deal with such APIs, with emphasis on correctly
using such APIs (which is sadly too often not the case).


## Introduction

The C language does not have objects in the classical sense, but C language
APIs commonly implement what looks like objects by providing sets of functions
that together allow the user to construct, use and then destroy data
structures.

The set of C language functions belonging logically to an object manage the
object through a handle. The handle is usually some pointer to the object's
data.

There is a constructor function, which you need to call first. It initializes
an object instance and returns the object handle. To use the object, you pass
the object handle back to other functions, which use it to access the object
data, in addition to the other arguments. To free resources at the end, you
need to call a destructor function with the object handle. After that, the
handle should not be used any more.

For a concrete example, here are four function declarations from `stdio.h`:

{% highlight c++ linenos %}
FILE * fopen(const char * filename, const char * mode);

size_t fread(void * ptr, size_t size, size_t count, FILE * stream);
size_t fwrite(const void * ptr, size_t size, size_t count, FILE * stream);

int fclose(FILE * stream);
{% endhighlight %}

`fopen` is the constructor function. It opens a file and returns a `FILE`
pointer as the object handle. If called again (e.g. to open another file), it
returns a pointer to a new `FILE` instance. Use `fread` and `fwrite` to read or
write a buffer to the file. Pass them the appropriate `FILE` pointer, as the
handle, in addition to the three arguments related to the buffer. Call `fclose`
at the end to free resources associated with a handle.

[Documentation][fwrite-doc] of `fwrite` might include an example on how to use
it that shows a call sequence `fopen` before `fwrite`, then `fclose` at the
end:

{% highlight c++ linenos %}
#include <stdio.h>

int main ()
{
  char buffer[] = { 'x' , 'y' , 'z' };
  FILE * f = fopen("dst.bin", "wb");
  fwrite(buffer, 1, sizeof(buffer), f);
  fclose(f);
}
{% endhighlight %}

**The example above is wrong**: for example it ignores that `fopen` might fail
to open the file and continues regardless.


## Handles

In the example above, the constructor function `fopen` returns a `FILE *`.  In
this case the handle is an explicit pointer. Implementation of say `fwrite`
probably accesses fields from the `FILE` structure e.g. it would access the
`_flag` member of the `FILE` structure like `stream->_flag`.

Some APIs use an opaque approach. For example in Windows `CreateEvent` returns
a `HANDLE`. It is still a pointer because `HANDLE` is defined as `void *`.
When you pass the`HANDLE` to a function like `SetEvent`, it presumably
reinterprets it like a pointer to a internal data type that `CreateEvent`
created.

{% highlight c++ linenos %}
typedef void * HANDLE;

HANDLE CreateEvent(...);
BOOL SetEvent(HANDLE h);
{% endhighlight %}

Handles usually have an invalid value. Often a null pointer indicates that the
constructor failed.

{% highlight c++ linenos %}
FILE * f = fopen(...);
if (0 == f)
{
  // handle error
}
{% endhighlight %}

Sometimes the invalid value might be different from null, and there could be
more than one invalid value for a handle type. For example `CreateEvent`returns
`NULL` in case of error. [However][why-win-handle] `CreateFile` returns in case
of error `INVALID_HANDLE_VALUE`, which is `-1`, even if the return type is the
same as `CreateEvent`. **Ensure you check for the right invalid value depending
on the constructor function**.

{% highlight c++ linenos %}
HANDLE e = CreateEvent(...);
if (NULL == e)
{
  // handle error
}
// but
HANDLE f = CreateFile(...);
if (INVALID_HANDLE_VALUE == f)
{
  // handle error
}
{% endhighlight %}


## Construction

There might be more than one constructor for a handle type. Sometimes an
additional constructor returns essentially the same object type, but it might
have different or additional arguments. This is the case of `CreateEventEx`
versus `CreateEvent` or `freopen` versus `fopen`.

In other cases there is an implicit hierarchy and another constructor is used
to create a different type in the hierarchy.

{% highlight c++ linenos %}
HANDLE CreateEvent(...);
BOOL SetEvent(HANDLE h);

HANDLE CreateFile(...);
BOOL ReadFile(HANDLE h, ...);

DWORD WaitForSingleObject(HANDLE h, ...);
BOOL CloseHandle(HANDLE h);
{% endhighlight %}

The set of functions above suggests a hierarchy where file objects and event
objects are some sort of waitable objects. `SetEvent` is for event objects
created with `CreateEvent`. `ReadFile` is for file objects created with
`CreateFile`. `WaitForSingleObject` is for waitable objects. `CloseHandle` is
for all object types.

![Hierarchy diagram](/assets/2015-03-06-c-api-objects/waitable.png)

The object handle is not always returned, some APIs return an error code
and receive a pointer to the object handle e.g. `fopen_s`:

{% highlight c++ linenos %}
errno_t fopen_s(FILE ** streamptr, const char * filename, const char * mode);

FILE * f;
errno_t result = fopen_s(&f, ...);
if (0 != result)
{
  // handle error
}
{% endhighlight %}

For this style of constructor functions **you need to understand what happens
if you pass a unitialized value** like in the example above and **how the
handle value could change if the constructor function returns an error**.

## Usage

After the object is successfully constructed it can be used by passing the
handle to other functions, usually as the first argument. That is similar to
C++ object member methods where the `this` pointer is passed by the compiler as
a hidden first argument.

Functions like `fread` and `fwrite`, where the object handle is the last
argument, are the odd case.

Sometimes C API implementations check that the object handle is not a null
pointer and return some error code in that case instead of crashing the program
(as `fwrite` would usually do). Don't rely on this behaviour, **don't use the
object handle if the constructor fails**.


## Destruction

Failing to destruct objects returned by constructing functions leads to
resource leaks (at least memory if nothing else).

If you check for a null pointer before destroying the object, remember that not
all constructors return a null pointer (see `CreateFile` above).

Similar to the usage, the C API implementation might check that the object
handle is not a null pointer. Don't rely on this behaviour (e.g. by not
performing the check yourself) unless you're sure it's safe.  E.g. it is safe
to call `delete` with a null pointer in C++.

And finally, not all handles need destructing. For example `stdio.h` also defines:

{% highlight c++ linenos %}
FILE * stdin;
FILE * stdout;
FILE * stderr;
{% endhighlight %}

You can't close these handles.


## Summary

We've looked at the variations C APIs typically use to implement objects. In
the following articles we'll look at techniques to use the C APIs correctly and
effectively.


[fwrite-doc]:      http://www.cplusplus.com/reference/cstdio/fwrite/
[why-win-handle]:  http://blogs.msdn.com/b/oldnewthing/archive/2004/03/02/82639.aspx
