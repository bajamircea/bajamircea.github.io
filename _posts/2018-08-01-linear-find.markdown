---
layout: post
title: 'Linear find basics'
categories: coding cpp
---

Finding a value by linear traversal


# Introduction

`find` is a function that performs linear traversal to find a value.
Essentially we're going to implement `std::find` from the standard C++ library
(see the article on `min` [as to why][min]).

There are some subtly different choices, mainly because the focus here is on
what's ideal, without any pressure to be backwards compatible.

{% highlight c++ linenos %}
namespace algs {
  struct equal
  {
    template<typename T, typename U>
    bool operator()(T && a, U && b) const {
      return std::forward<T>(a) == std::forward<U>(b);
    }
  };

  struct identity
  {
    template<typename T>
    T && operator()(T && x) const {
      return std::forward<T>(x);
    }
  };

  // generalized find taking comparison and projection
  template<typename I, typename S, typename T, typename Cmp, typename Proj>
  // requires I is an InputIterator,
  //   S is a sentinel for I,
  //   Cmp is an equivalence relation between T and projection Proj of ValueType(I)
  I find(I f, S l, const T & v, Cmp cmp, Proj proj) {
    while (f != l) {
      if (cmp(v, std::invoke(proj, *f))) {
        return f;
      }
      ++f;
    }
    return f;
  }

  // generalized find taking comparison
  template<typename I, typename S, typename T, typename Cmp>
  // requires I is an InputIterator,
  //   S is a sentinel for I,
  //   Cmp is an equivalence relation between T and ValueType(I)
  I find(I f, S l, const T & v, Cmp cmp) {
    return find(f, l, v, cmp, algs::identity());
  }

  // straight forward find
  template<typename I, typename S, typename T>
  // requires I is an InputIterator,
  //   S is a sentinel for I,
  //   T is equality comparable with ValueType(I)
  I find(I f, S l, const T & v) {
    return find(f, l, v, algs::equal());
  }

  namespace range {
    // range find

    // generalized range find taking comparison and projection
    template<typename Range, typename T, typename Cmp, typename Proj>
    // requires R is an InputRange,
    //   Cmp is an equivalence relation between T and projection Proj of ValueType(Range)
    auto find(Range & r, const T & v, Cmp cmp, Proj proj) {
      return algs::find(std::begin(r), std::end(r), v, cmp, proj);
    }

    // generalized range find taking comparison
    template<typename Range, typename T, typename Cmp>
    // requires R is an InputRange,
    //   Cmp is an equivalence relation between T and ValueType(Range)
    auto find(Range & r, const T & v, Cmp cmp) {
      return algs::find(std::begin(r), std::end(r), v, cmp);
    }

    // straight forward
    template<typename Range, typename T>
    // requires R is an InputRange,
    //   T is equality comparable with ValueType(Range)
    auto find(Range & r, const T & v) {
      return algs::find(std::begin(r), std::end(r), v);
    }
  }
}
{% endhighlight %}

The rest of the article is about how did we get there.


# Basic usage

Basic usage of `find` looks like this:

{% highlight c++ linenos %}
  std::vector<int> v{3, 5, 42, 4};
  auto it = algs::range::find(v, 42);
  if (it == v.end()) {
    std::cout << "Not found\n";
  }
  else {
    std::cout << "Found: " << *it << '\n';
  }
  // Prints: Found: 42
{% endhighlight %}


# Tricks from min

I've reused some techniques that are explained in the `min` [article][min] such
as:

- using templates for a generic solution
- `algs` namespace to address unwanted ADL
- `equal` struct is similar to `less` from `min`; `identity` struct is
  identical
- comparison and projection for more flexibility


# Representing ranges

There are a few good ways to represent ranges.

One is by using a pointer to the element of an array and a count for the number
of the elements in the range. In some situations this is good way. But for the
situations when we consume from a range, this approach has the disadvantage
that the pointer has to advance and the counter has to be decremented in sync.

Another way is to use two pointers. One pointer to the first element in the
range. The second pointer points one past the last element in the range. This
second pointer is traditionally called `last`, although strictly speaking it is
one past the last. The rules inherited from C guarantee that one can point one
past the end of an array as long it is not dereferenced.

A common usage scenario is to increment the first pointer until it becomes
equal to the last:

{% highlight c++ linenos %}
  while (f != l) {
    // some code here using the dereferenced value *f
    ++f;
  }
{% endhighlight %}


This two pointers approach creates a closed-open range i.e. it includes the
element pointed by the first pointer, but it does not include the element
pointed by the last pointer. The advantage of a closed-open range is that it
can represent empty ranges (when the two pointers are equal).

A generalization of the two pointers approach is to use iterators instead of
pointers. We got to the end when the two iterators are equal.

A further generalization is to allow the types two be different so that only
the first one is an iterator, the last one can act as a sentinel. For example
the equality operator between the iterator and the sentinel can compare if the
value pointer by the iterator is zero; in this case the sentinel is just an
empty type such that the right equality operator is called. I took this
approach in this implementation of `find`.

For convenience the range can be represented by a single object that groups the
two values of either of the two approaches above by exposing methods like
`begin`, `end`, `size`. That's a range object.


# Versions accepting range objects

When creating versions of `find` that accept range objects there is the problem
of how to disambiguate between functions with the same number of arguments
e.g. both functions below have three arguments:

{% highlight c++ linenos %}
namespace algs {
  template<typename I, typename S, typename T>
  I find(I f, S l, const T & v) {
    // ...
  }

  namespace range {
    template<typename Range, typename T, typename Cmp>
    auto find(Range & r, const T & v, Cmp cmp) {
      // ...
    }

  }
}
{% endhighlight %}

The choice I've made above is to use an additional namespace for the functions
receiving a range object. That's maybe not ideal.


# Passing range objects as arguments

Standard containers such as `std::vector`, `std::list`, `std::set` etc. can be
used as range objects. That's what I've shown above for the basic usage sample.

We don't want to pass such containers when they are temporaries (rvalues) to
`find` because the returned iterator will be dangling.

In the `range::find` implementation above, I avoid this passing the range by
lvalue reference: `Range & r`.

However sometimes it's desirable to accept temporaries for range objects.
That's the case when the range object provides a view into a container. The
`range::find` implementation above does not handle this, which is not ideal.
See [ranges work][ranges-work] for proposal on how this will be dealt with by
the standard libraries.


# Return value

The return value of `find` is an iterator.

When `first` and `last` have the same type, either can be returned when they
become equal. But when `last` plays the role of a sentinel, it can have a
different type from `first`. This leads to the decision to return `first` (or a
value reached from `first`) when `first` becomes equal to `last`. Therefore the
return type of `find` is the same as the type for `first`.

The user to either use returned iterator to get the found value, or use it to
build a range e.g.: either the range from the value to the end or from the
beginning to the value (if the iterator is `ForwardIterator`).


# Related algorithms

- `find_if`, `find_if_not` (which take a predicate instead of a value)
- `lower_bound`, `upper_bound`, `equal_range` (which work on sorted ranges)
- `search` (which takes two ranges)


# Faster linear find

There are faster options for linear find (even ignoring hardware speed-ups, or
sorted input).

To start, if `last` can de dereferenced and the searched value stored, the
version below saves an extra comparison (of `first` with `last`) for every
iteration in the loop.

{% highlight c++ linenos %}
  template<typename I, typename T>
  // requires I is an ForwardIterator
  //   T is equality comparable,
  //   T is the same as ValueType(I)
  I find_by_setting_sentinel(I f, I l, const T & v) {
    // precondition: l can be dereferenced to store value as sentinel
    *l = v;
    while (*f != v) {
      ++f;
    }
    return f;
  }
{% endhighlight %}

This is an option for rare situations however, because it's usually unexpected
to a user to allow dereferencing `last` and mutating the input to find a value.


# References

- Elements of Programming (book by Alexander A. Stepanov and Paul McJones)
- [Article on implementing min][min]
- Donald Knuth: "Structured Programming with Goto Statements" (December 1974)


[min]:             {% post_url 2018-07-29-min-max %}
[ranges-work]: http://www.open-std.org/jtc1/sc22/wg21/docs/papers/2018/p0970r1.pdf
