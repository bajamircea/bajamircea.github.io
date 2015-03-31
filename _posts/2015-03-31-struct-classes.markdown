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
    p(x)
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


## Summary

Use `struct` to convey the message: "this is a class with (mostly) public
members".

[slim-raii]:    {% post_url 2015-03-22-slim-raii %}
