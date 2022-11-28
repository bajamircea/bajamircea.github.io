---
layout: post
title: 'C++ constructor, destructor and class'
categories: coding cpp
---

C++ introduces innovations such as constructor, destructor and class.

This article is part of a series on [the history of regular data type in
C++][regular-intro].


C++ introduced next a lot of innovations on top the C `struct`. All these
improvements went through several iterations to become today's equivalents. I'm
going to provide today's equivalents, though the tools did not simply became
their current incarnation.


# Constructor, destructor

First it introduced the idea of a member function. A member function gets a
pointer to the instance as a hidden first argument (usually), called `this`.

{% highlight c++ linenos %}
struct foo {
  // member variable
  int bar;

  // member function
  void buzz() {
    // member function body
  }
};
{% endhighlight %}

In the member function body you can access members either directly (e.g. `bar =
42`) or via the `this` pointer (e.g. `this->bar = 42`).

The constructor syntax is to declare a member function with the same name as
the `struct` and no return type. The destructor is similar, but preceded by
`~`. `~` was/is the bitwise **NOT**, someone thought it's a funny pun that the
destructor is "NOT constructor".

{% highlight c++ linenos %}
struct foo {
  // constructor
  foo() {
    // constructor body
  }

  // destructor
  // "not constructor"
  ~foo() {
    // destructor body
  }
};
{% endhighlight %}

The constructor and destructor allow for initialisation and cleanup. They apply
automatically when an instance of the class is created or destructed. That is a
big step forward compared with the DIY approach in C where the programmer has
to remember to call equivalent functions manually.

Constructor has more facilities that the destructor, such that you can have
function parameters, hence you can have multiple constructors that differ in
the parameters they take. Also constructors have additional syntax to do
initialization before the function body.

The constructor/destructor are particularly useful when they involve some
resource, even something as simple of memory allocated on the heap. They allow
for the RAII idiom: allocate in the constructor, free in the destructor.

{% highlight c++ linenos %}
struct foo {
  bar * ptr;

  foo() {
    // allocate memory here
  }

  ~foo() {
    // deallocate memory here
  }
};
{% endhighlight %}

This pattern is particularly useful for dynamically sized containers. Due to
their variable size the content can't be stored directly in the object, so they
often allocate on the heap and store pointer(s) to the allocated data. The
member variables of the class are local parts, at constant offset from the
address of the object itself, while the pointed data are remote parts.


# Class vs. struct

You might not want the user of the class to accidentally change the pointer
member, this leads to `public`, `private` and `protected` in C++ that control
visibility from the outside of the class.

`class` is really the same as as `struct` in C++, except the default visibility
which is `private` for `class`.


[regular-intro]:   {% post_url 2022-11-16-regular-history %}
