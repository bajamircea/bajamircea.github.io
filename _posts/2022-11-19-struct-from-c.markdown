---
layout: post
title: 'Struct from C'
categories: coding cpp
---

C++ got struct from C. The initial state of affairs. Memory, padding and first
attempts at copy.

This article is part of a series on [the history of regular data type in
C++][regular-intro].


# Struct

`struct` in C (and C++) is a language construct that defines a type by grouping
sequentially a finite number elements of other types, these are known as member
variables. It is different from arrays which group sequentially a fine number
of the same type. It's also different from the less often used `union` which
overlaps other types.


# Memory and padding

For example the type below is composed out of two `int`s and two `char`s:

{% highlight c++ linenos %}
struct sample
{
  int w;
  char x;
  int y;
  char z;
};
{% endhighlight %}

There are choices that are platform dependent, but here is what's happening on
a typical one nowadays: The `int`s take 4 bytes each, their address is usually
aligned to be a multiple of 4 and are interpreted as a two's complement signed
integer. The `char`s take a byte each, they don't have any alignment
requirements.

Because of the `int` members, the addresses for `sample` variables would be
aligned to a multiple of 4. That's where `int w` is located taking 4 bytes,
followed by `char x` taking 1 bytes. Padding is added at in the middle to align
the `int y` address as a multiple of 4. Padding is added at the end so that if
you have an array of `sample`, the address of `int w` is also aligned as a
multiple of 4. The size of `sample` is 16 bytes.

{% highlight c++ linenos %}
struct sample
{
  int w; // 4 bytes
  char x; // 1 byte
  // 3 bytes of padding here
  int y; // 4 bytes
  char z; // 1 byte
  // 3 bytes of padding at the end
}; // takes overall 16 bytes
{% endhighlight %}

Padding can be reduced by sorting members by size:

{% highlight c++ linenos %}
struct better_sample
{
  int w; // 4 bytes
  int y; // 4 bytes
  char x; // 1 byte
  char z; // 1 byte
  // 2 bytes of padding at the end
}; // takes overall 12 bytes
{% endhighlight %}


# Virtual machine

What such a `struct` type really does is **it provides an interpretation of
memory**.

This is not a small thing. Many languages create abstraction layers around data
types. For example in Lisp derived languages (Javascript included), a data type
is defined indirectly via a dictionary that is required to implement lambdas
properly (to capture creation context).

Although theoretically we imagine that the C/C++ code we write runs on some
imaginary machine, rather than an explicit virtual machine (as in Java), or an
implicit machinery like in Lisp/Javascript/Python etc, in C/C++ this imaginary
virtual machine is quite similar to the actual physical machine: it has data
and program, the data memory is split into stack, heap and static initialized
one, so little to no translation is required to make the code run efficiently.


[regular-intro]:   {% post_url 2022-11-16-regular-history %}

