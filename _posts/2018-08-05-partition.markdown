---
layout: post
title: 'Partition basics'
categories: coding cpp
---

Partitioning a range


# Introduction

We're going to have a look at a range partition. We've got a range and a unary
predicate. We'd like to rearrange the values such as the they are grouped into
two ranges based on the result of the predicate.

That's similar to `std::partition` from the standard C++ library with some
differences.

See the article on `min` [as to why][min].

{% highlight c++ linenos %}
namespace algs {
  // generalized partition forward taking predicate and projection
  template<typename I, typename S, typename Pred, typename Proj>
  // requires I is an ForwardIterator,
  //   S is a sentinel for I,
  //   Pred is an unary predicate on projection Proj of ValueType(I)
  I partition_forward(I f, S l, Pred pred, Proj proj) {
    f = algs::find_if(f, l, pred, proj);
    if (f == l) return f;

    for (I i = std::next(f); i != l; ++i) {
      if(!pred(std::invoke(proj, *i))) {
        std::iter_swap(f, i);
        ++f;
      }
    }
    return f;
  }

  // ... less general options implemented in terms of the above
}

{% endhighlight %}

The rest of the article is about how did we get there.


# Basic usage

Basic usage of `partition` looks like this:

{% highlight c++ linenos %}
  std::vector<char> v{'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i'};
  auto is_consonant = [](char x) {
    switch(x) {
      case 'a': case 'e': case 'i': case 'o': case 'u': return false;
      default: return true;
    }
  };

  auto pr = algs::range::partition_forward(v, is_consonant);

  for (auto c : v) {
    std::cout << c; // Prints aeidbfghc
  }
  std::cout << '\n';

  if (pr == v.end()) {
    std::cout << "FAIL!\n"; // we know we have consonants
  }
  std::cout << *pr << '\n'; // Prints d
{% endhighlight %}


# How it works

![Partition](/assets/2018-08-05-partition/01-partition.png)


# Which range first

This implementation is different from `std::partition` in that the range is
partitioned so that the values for which the predicate returns `false` preceed
the values for which the predicate returns `true`. It makes better sense when
thinking about similar functions where the paritioning function returns more
than two values (say -1, 0 or 1 for a three way partitioning).


# Stability

`partition_forward` is partially stable in that it preserves the order of the
values for which the predicate returns `false`, but does not preserve the order
of the values for which the predicate retrns `true`.


# Algorithmic complexity

The function takes `O(n)` predicate applications (one for each element in the
range).


# Other choices

Other related algorithms make different choices.

One choice is to not give any stability guarantees. That's what
`std::partition` does. For bidirectional iterators there is an algorithm that
has fewer swaps, but gives up any stability guarantees.

Another choice is to provide stability guarantees for all the values in the
sequence, at the cost of more work or space. That's what `stable_partition` does.

If the data is stored in a linked list, an algorithm that is stable is possible
by traversing the list, splitting the nodes into two lists based on the
predicate, then joining the two lists before returning.

When the predicate is only applied once it does not need to be a regular
function: a **pseudopredicate**. A regular function consistently returns the
same results for the same values. For example the sequence can contain HTTP
URLs and it can be partitioned based on a function that checks if the download
time is less than 200ms.

Some algorithms could choose to remove the guarantee that the predicate is
applied only once for each value.


# Related algorithms

- `partition_point` (find the partition point, assuming input is partitioned)
- `partition` (no stability guarantees, predicate applied once)
- `stable_partition` (partition, but stable, higher algorithmic complexity)
- `sort` (sorts values)


# References

- Elements of Programming (book by Alexander A. Stepanov and Paul McJones)
- [Article on implementing min][min], followed by linear find and swap


[min]:  {% post_url 2018-07-29-min-max %}
