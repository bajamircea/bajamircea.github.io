---
layout: post
title: 'Struct Classes'
categories: coding cpp
---

This short article reminds that C++ structs are classes too.


## Class and struct

There are two major ways of building new types. One is by putting together
multiple pices of the same type. These are arrays.

The other one is by putting together pieces of different types. There are two
keywords in C++ that allows us to do that: `class` and `struct`.

The classic usage is to use `class` for C++ classes and `struct` for
interoperability with C APIs. However the only real difference between them is
the default visibility of members, which is `private` for `class` and it is
`public` for `struct`.

Both `struct` and `class` create C++ classes. It is perfectly good to use
`struct` for classes, for example for small classes with all public members, as
we've seen for example in the [slim RAII][slim-raii] variant.

{% highlight c++ linenos %}
struct file
{
  FILE * p;

  explicit file(FILE * x) :
    p{ x }
  {
  }

  ~file()
  {
    if (p)
    {
      fclose(p);
    }
  }
};
{% endhighlight %}

If we were to use the `class` keyword, we would needed an extra line to change
visibility to `public`:

{% highlight c++ linenos %}
class file
{
public:
  ...
};
{% endhighlight %}

A good pattern for a C++ class that stores various pieces of data together is a
`struct` that uses member variable initialization.

{% highlight c++ linenos %}
struct data
{
  int value{};
  int answer{42};
  bool valid_answer{};
  std::string reason{};
};
{% endhighlight %}

This eliminates the need to write a constructor to initialize the member
variables. Also note that only fields where the default value was not desired
are initialized (default value for int-types is 0, false for bool and nullptr
for pointers).

Once initialied with data (e.g. from a stream), pass it by const reference to
make its fields read only.

## Summary

Use `struct` to convey the message: "this is a class with (mostly) public
members".

[slim-raii]:    {% post_url 2015-03-22-slim-raii %}
