---
layout: post
title: 'C++11 data race'
categories: coding cpp
---

Data races in C++11 are undefined behaviour


# Introduction

> Without appropriate synchronization, access to the same data from multiple
> threads, with at least of one of them writing (data races), is undefined.

The C++11 standard provides support for multi-threading, the description of an
abstract machine with a memory model. When synchronization is not used, the
compiler is allowed a lot of freedom, in a way similar to the DEC Alpha CPUs.

Undefined is a C++ standard legalese term. For a particular compiled binary and
a particular processor, one could theoretically figure out what could happen.
But **just because it seems to work, it does not mean that it really works and
it's not just a bug waiting to happen**.


# Multiple writes

One invalid line of defence is the claim "it's fine because I'm writing a 32
bit integer, and my processor writes it atomically". This refers to the problem
where to write a variable, the processor performs two distinct operations to
write the high and low part, and a different thread could read a old half and a
new half leading to a value that's neither old or new.

![Not atomic access](/assets/2019-10-31-cpp-data-race/not-atomic.png)

This could be a problem, but avoiding it is not sufficient. Here are two
examples.


# Integer data race

{% highlight c++ linenos %}
// Given two `int` variables `x` and `y` set initially to `0`:

// Thread 1:
if (x != 0) {
  ++y;
}

// Thread 2:
if (y != 0) {
  ++x;
}
{% endhighlight %}

The compiler could assume that the `if` statements are rarely taken, so it
would be more optimal to increment the variables first and then decrement them
if the condition was not met. It is then allowed to generate code equivalent to
the following:

{% highlight c++ linenos %}
// Thread 1:
++y;
if (x == 0) {
  --y;
}

// Thread 2:
++x;
if (y == 0) {
  --x;
}
{% endhighlight %}


# Boolean data race

Another example is:

{% highlight c++ linenos %}
// given a `bool` variable set initially to `false`

// Thread 1:
while (!stop) {
  // do work
}

// Thread 2:
stop = true;
{% endhighlight %}

The compiler can decide to test only once early for the `stop` variable if it's
value is never changed in the `while` loop and generate code equivalent to:

{% highlight c++ linenos %}
// Thread 1:
if (!stop) {
  while (true) {
    // do work
  }
}

// Thread 2:
stop = true;
{% endhighlight %}


# Conclusion

If more than one thread access the same variable/memory location with no
appropriate synchronization: it's a bug.


# References

- Hans-J. Boehm: [Threads Cannot be Implemented as a Library][library], 12 Nov
  2004

[library]: http://www.hpl.hp.com/techreports/2004/HPL-2004-209.pdf
