---
layout: post
title: 'The future of regular'
categories: coding cpp
---

It's good and common to want to use regular data types. But still creating them
is more difficult than it should be.


This article is part of a series on [the history of regular data type in
C++][regular-intro].


Around 2018 [I showed how to do it][pragmatic-macro] using `tie_members` and
macros:

{% highlight c++ linenos %}
struct person {
  std::string first_name;
  std::string last_name;
  int age{};
};

inline auto tie_members(const person & x) noexcept {
  return tie_with_check<person>(x.first_name, x.last_name, x.age);
}

MAKE_STRICT_TOTALY_ORDERED(person)
{% endhighlight %}


Then in this series of articles [I showed hot to do it using the spaceship
operator][pragmatic-spaceship]:

{% highlight c++ linenos %}
struct person {
  std::string first_name;
  std::string last_name;
  int age{};

  constexpr std::strong_ordering
    operator<=>(const person &) const noexcept = default;
};
{% endhighlight %}

Using the spaceship operator is an improvement, but still has issues.

Where I would like to get is something like:

{% highlight c++ linenos %}
regular_struct person {
  std::string first_name;
  std::string last_name;
  int age;
};
{% endhighlight %}

The definition for the `regular_struct` (potentially user defined) should
create the regular boileplate: default constructor (including defaulting the
`int` to `0`, copy, move, comparisons, etc.


[pragmatic-macro]:    {% post_url 2018-07-27-strict-ordered-structs %}
[pragmatic-spaceship]:{% post_url 2023-03-17-pragmatic-spaceship %}
[regular-intro]:      {% post_url 2022-11-16-regular-history %}

