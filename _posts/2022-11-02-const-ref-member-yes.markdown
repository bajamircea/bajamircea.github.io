---
layout: post
title: 'Const ref member: Yes'
categories: coding cpp
---

Are there cases where you might want a const reference member? Yes.


This article is part of a series of [articles on programming
idioms][idioms-intro].

We've just seen that we wanted to store the used interfaces as references and
not mark them `const`, and [we criticised const usage in that
context][constrefno]. Before hurrying to create a simplistic, but wrong, rule
that member references should never be `const`, let's look at an example
where a `const` reference member is good.


# Canonical example

This is a slightly simplified example from [Elements of Programming][eop]

{% highlight c++ linenos %}
template<typename T>
class lower_bound_predicate {
  const T & a; // const reference is good here
public:
  lower_bound_predicate(const T & a) : a(a)
  {}

  bool operator()(const T & x) {
    return !(x < a);
  }
};

template<typename I, typename T>
I lower_bound(I f, I l, const T & a) {
  lower_bound_predicate<T> p(a);
  return partition_point(f, l, p);
}
{% endhighlight %}

or you might do it with an equivalent lambda, but the mechanics is the same:

{% highlight c++ linenos %}
template<typename I, typename T>
I lower_bound(I f, I l, const T & a) {
  auto p = [&a](const T & x) {
      return !(x < a);
  };
  return partition_point(f, l, p);
}
{% endhighlight %}

though note that some details are more logical in the Elements of Programming
than in the C++ standard library e.g. with regards to partition.


# Explanation

Despite its initially unintuitive name, `lower_bound` is a great algorithm
that basically uses divide and conquer to do what most people thing of a binary
search on `O(lg(N))` time. I [already covered how it works][lowerbound] in
glorious details.

What I illustrate here is that `lower_bound` uses `parition_point` which finds
a boundary given a predicate. The `lower_bound_predicate` creates the predicate
that we want: for the values smaller than `a` it returns `false`, for equal or
grater it returns `true`. `partition_point` finds the point where the predicate
transitions from `false` to `true`.

To achieve that, `lower_bound_predicate` captures `a` by `const` reference. In
general that would raise dangling reference concerns, but it's clear from this
particular context that the scope of `a` as a function parameter for
`lower_bound` extends the scope of the instance of `lower_bound_predicate`.

So we do something potentially dangerous for a tangible gain: the algorithm
does not need to copy the type `T` which sometimes might need to allocate on
the heap (e.g. if `T` is a `std::string`).


# Similarities

Notice the similarities between a function object and classes in the mockable
interfaces idiom: they are does, things that do stuff, though in the case of
the function object they are refined to only do one thing which is what the
`operator()` captures. Them using references in member variables might come
from the similarities they share in their intent.


[eop]: http://elementsofprogramming.com/
[idioms-intro]:    {% post_url 2022-10-17-idioms %}
[constrefno]:      {% post_url 2022-10-29-const-ref-member-no %}
[lowerbound]:      {% post_url 2018-08-09-lower-bound %}
