---
layout: post
title: 'Rule of three and composing'
categories: coding cpp
---

Rule of three. Or rule of five. Or none of those rules: composing, interfaces,
reference members and pimpl.

This article is part of a series on [the history of regular data type in
C++][regular-intro].


# Traditional "rule of three"

The traditional "rule of three" states something on the lines of:

> If a class implements a destructor, copy constructor or copy assignment, then
> you should consider implementing all three

So for example this class has a pointer as a member variable, the pointed
memory is deallocated in the destructor, we need to do something about copy as
well, else the default implementation would copy the value of the pointer
leading to unwanted double deallocation.

{% highlight c++ linenos %}
class foo {
  bar * ptr;
public:
  // ...

  ~foo() {
    delete ptr;
  }

  // ...
};
{% endhighlight %}

With the advent of move the rule was expanded to also cover move constructor
and move assignment, hence renamed to be "rule of five".


# Not rule of three: composing

You apply the rule of three when writing low level types. Most of the time you
compose on top of other types without explicitly defining destructor/copy/move
and let the compiler generate them in terms of the member variables (and base
classes).

So for example:

{% highlight c++ linenos %}
class buzz {
  foo one;
  foo two;
public:
  // constructor
  buzz(/*...*/): one{/*...*/}, two{/*...*/} {
    // usually empty constructor body
  }

  // no destructor, copy, move:
  // it relies on members to do the right thing
};
{% endhighlight %}

The type `buzz` above does not have an explicit destructor. When an instance is
destructed, the destructors for the member variables are invoked (in the
reverse order).

Similarly copy and move are implemented by the compiler in terms of copy and
move of the member variables (or are respectively not available if one member
variable can't copy or move).

[Avoid managing two independent in a single class][lifetime], use aggregation
as above.


# Not rule of three: mockable interfaces idiom

For the [mockable interfaces idiom][interfaces-idiom] we defined a destructor
for the interface, but not copy or move. There were two options, here is one of
them:

{% highlight c++ linenos %}
struct foo_interface {
  virtual void some_fn() = 0;
  virtual int some_fn2() = 0;

  virtual ~foo_interface() = default;
};
{% endhighlight %}

The reason we defined the destructor was to address the question: "If one
derives from this interface and deletes an instance of the interface, what
ensures that the derived class destructor is called?". In this option the
`virtual` destructor ensures it. This is not the same as the resource case,
notice that the destructor is defaulted, this is not a rule of three case.

When we inherited and implemented the interface we did not define a destructor,
but instead we deleted the copy (which deletes move as well):

{% highlight c++ linenos %}
class foo : public foo_interface {
  bar_interface & bar_;
  buzz_interface & buzz_;
  const std::string fred_;

public:
  foo(bar_interface & bar,
      buzz_interface & buzz,
      const std::string & fred):
    bar_{ bar }, buzz_{ buzz }, fred_{ fred }
  {}

  foo(const foo &) = delete;
  foo & operator=(const foo &) = delete;

  // implement in terms of bar_, buzz_ and fred_
  void some_fn() override;
  int some_fn2() override;
};
{% endhighlight %}

We did that because the way such types are instantiated risks dangling
references if they are moved around. This is also not a rule of three case, we
just delete some operations (that happen to be copy and move).


# Not rule of three: Pimpl

When using the Pimpl idiom (pointer to implementation), the header exposes just
the pointer to the implementation class. The destructor has to be declared in
the header and implemented in the cpp file.

{% highlight c++ linenos %}
// in the header
class some_class
{
public:
  some_class();
  ~some_class();

  void some_fn();
private:
  class impl;
  std::unique_ptr<impl> pimpl_;
};

// in the cpp
// ...
some_class::~some_class()
{}
{% endhighlight %}

This is also not a rule of three case, notice that the implementation of the
destructor is implicitly a default one.  The purpose is to play with the
linking rules, the user of `some_class` will link to the existing destructor.
Were it not implemented in the cpp file, the user of the class in the header
will try to generate the destructor and fail because it does not have
visibility of the implementation class.


# Conclusion: better "rule of three"

When you design a low level class that manages a resource you need to deal with
many low level details such as: destructor, copy and move constructor and
assignment, equality and order. For higher level classes try to delegate (e.g.
compose). There are also some specialized cases where a resource is not
managed, they usually default or delete copy, move or destructor, a resource is
not managed explicitly via those operations.


[regular-intro]:    {% post_url 2022-11-16-regular-history %}
[lifetime]:         {% post_url 2015-04-02-class-lifetime %}
[interfaces-idiom]: {% post_url 2022-10-26-mockable-interfaces-idiom %}

