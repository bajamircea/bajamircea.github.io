---
layout: post
title: 'Default constructor'
categories: coding cpp
---

Some C++ constructors are special, the default constructor is one of them.

This article is part of a series on [the history of regular data type in
C++][regular-intro].


# Default constructor

I've already mentioned that the constructor has more facilities that the
destructor, such that you can have function parameters, hence you can have
multiple constructors that differ in the parameters they take.

The constructor without any parameters is called the default constructor.

{% highlight c++ linenos %}
struct foo {
  foo() {
    // default constructor
  }

  foo(int i, int j) {
    // some other constructor
  }

  // ...
};
{% endhighlight %}

The default constructor is used when you "just need an instance":

{% highlight c++ linenos %}
int main() {
  foo x; // default constructor is used to initialize x
};
{% endhighlight %}


# Kinds of default constructor

When you have an `int`, there are two ways to construct one out of thin air.
Uninitialized:

{% highlight c++ linenos %}
int main() {
  int i; // some int, uninitialized
};
{% endhighlight %}

or initialized:

{% highlight c++ linenos %}
int main() {
  int i{}; // initialized to 0
  // equivalent to:
  int j = 0;
};
{% endhighlight %}

When we have a `struct` containing a pointer that is deallocated in the
destructor, in the constructor we have to do enough so that we don't try to
deallocate using an uninitialized pointer, usually at least we have to
initialize the pointer to `nullptr` in the default constructor:

{% highlight c++ linenos %}
struct foo {
  bar * p;

  foo() : p{nullptr} {
  }

  // ...
};
{% endhighlight %}

But when we have a `struct` containing an `int`:

{% highlight c++ linenos %}
struct buzz {
  int i;

  buzz() {
    // should we initialize i or not?
  }
};
{% endhighlight %}

Should we initialize the `int` member variable? Can we do both? Unfortunately
the language does not have syntax for two kinds of default constructors, so the
answer is "depends". More often than not you'll want to initialize, trading a
bit of efficiency for safety in general.

This is annoying when you just need a resizable buffer to read some data from a
file, you reach for a `std::vector<usigned char>`: when resized to the desired
size, it will also initialize values to `0`, even if they will be overwritten
later when content is read from the file.


[regular-intro]:   {% post_url 2022-11-16-regular-history %}
