---
layout: post
title: 'Pragmatic Regular structs'
categories: coding cpp
---

How to implement Regular data structures, using the spaceship operator, before
better capabilities are added to C++

This article is part of a series on [the history of regular data type in
C++][regular-intro]. It also revisits [the old
way][legacy-strict-ordered-structs] of achieving the same functionality.


# Introduction

Say you define a custom data structure, `person` and want to ensure it's
regular: just data, copyable, movable, strictly totally ordered and all that.
Here is the recipe using the spaceship operator for comparisons that the
compiler does not automatically generate yet.

{% highlight c++ linenos %}
struct person {
  std::string first_name;
  std::string last_name;
  int age{};

  constexpr std::strong_ordering
    operator<=>(const person &) const noexcept = default;
};
{% endhighlight %}


# default operator <=>

Well, all the other aspects are easy to understand, the compiler will generate
default constructor, destructor, copy, move, but not comparison. For that we
currently have to still provide a magic incantation. This will generate all the
comparisons though: the predicates `==`, `!=`, `<`, `>`, `<=`, `>=` and the three
way `<=>`.


# const member

We've added `operator<=>(const person & other) const` to reduce the amount of typing
compared with `friend operator<=>(const person & x, const person & y)`. The
member version still takes two arguments: one via hidden `this`, the other via
the `other` parameter. Because we default it, we don't even need to name the
`other` parameter.


# constexpr

The naive explanation is that `constexpr` means that it might be executed at
compile time. That is wrong. The compiler can figure out what can be executed
at compile time and execute it at compile time. The correct explanation is that
here `constexpr` is a promise that we're not going to change the implementation
to do things that can't be executed at compile time.

To be able to use it here requires that all the members have `<=>` defined
`constexpr`. That is currently the case for `std::string` used above, but not
for e.g. `std::set`, so weather you can use `constexpr` here depends on the
types you're using and the quality of the standard library you're using.

Practically, you might care about this e.g. to check that a static array of
`person` is sorted at compile time, or you might not, but the lack of
consistence is annoying.


# strong_ordering

How do we ensure that of all the comparisons we get the proper strong version:
strictly totally ordered where `<` is really less than and `==` is really
equality?

We return `std::string_ordering`. This protects e.g. against loosing the
strength of the comparison e.g. if the type of `age` is changed from `int` to
`float`. Unfortunately you might get an error when you try to use `<` and the
defaulted operator `<` is actually generated, rather than when you just
declared the class `person`.


[legacy-strict-ordered-structs]: {% post_url 2018-07-27-strict-ordered-structs %}
[regular-intro]:    {% post_url 2022-11-16-regular-history %}


