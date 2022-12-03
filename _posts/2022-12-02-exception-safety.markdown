---
layout: post
title: 'Exception safety, noexcept'
categories: coding cpp
---

Ideas on exception safety, leading to noexcept, in the context of the special
operations of a type.


This article is part of a series on [the history of regular data type in
C++][regular-intro].


I covered [exception safety previously][exception-safety], ideas of which were
clarified around the adoption of STL containers and algorithms, but they
already start to apply from this point, in the context of a class that manages
some memory and has constructor, destructor and copy.

Say for example this class `foo` that manages a pointer to `bar`.

{% highlight c++ linenos %}
class foo {
  bar * ptr;

public:
  // ...
};
{% endhighlight %}


# The basic guarantee: constructor

A function can throw, but it must not leak. The case of the constructor:

{% highlight c++ linenos %}
  foo(...args here...) {
    // allocate memory and initialize bar
  }
{% endhighlight %}

The constructor has no return value to indicate failure. On failure it must
throw (or terminate). If it throws, it must take steps to undo any of the
resources it has already acquired. This is usually done by having classes that
only manage a single resource and composing on top of those. Usually if you
only manage a single resource, if you fail to acquire the resource there are
no further steps to undo and you can just throw.


# No-throw guarantee: destructor and default constructor

The no-throw guarantee is that a function guarantees that it does not throw.
This eventually made for the introduction of `noexcept` to indicate that as
part of the function contract.

Consider the case of the destructor:

{% highlight c++ linenos %}
  ~foo() {
    // deallocate memory here
  }
{% endhighlight %}

There is a long tradition for the destructors to not throw. Although the C++
language allows destructors to throw, it comes with language limitations (the
program is terminated if an exception exit the destructor [during stack
unwinding][destructor-rules]) and also with practical difficulties (related to
ensuring all the cleanup is performed when parts of the cleanup such as
destructors throw).

In fact the expectations of the destructors to not throw are so ingrained that
they are implicitly marked `noexcept`.

Another case is the default constructor:

{% highlight c++ linenos %}
  foo() noexcept {
    // default constructor: set pointer to nullptr
  }
{% endhighlight %}

It does not have such a strong tradition as the destructor, but it's a good
idea to not throw. In the example above it's marked explicitly as `noexcept`
and it just sets the pointer to `nullptr`.

We'll see later that move constructor and assignment should not throw.


# The strong guarantee

The strong guarantee is that if an exception is thrown, the program state is
unchanged: “commit or rollback” semantics.

The case of the copy assignment:

{% highlight c++ linenos %}
  foo & operator=(const foo & other) {
    if (this != &other) {
      // copy other.ptr into this->ptr
    }
    return *this;
  }
{% endhighlight %}

There are two implementation choices.

One option is to copy the value from `other` in the already held location (if
one exists). This does not (in general) provide rollback guarantees.

The other option is to allocate a new value, copy from the `other` and only if
it succeed store the pointer to the new value, deallocate the old value. This
can provide rollback guarantees, but it does so at additional cost. Because of
the additional cost this is not done for the copy assignment.


[regular-intro]:      {% post_url 2022-11-16-regular-history %}
[exception-safety]:   {% post_url 2020-05-04-exception-safety %}
[destructor-rules]:  {% post_url 2018-03-16-destructor-language-rules %}
