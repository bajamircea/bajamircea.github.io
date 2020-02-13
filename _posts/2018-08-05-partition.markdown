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

See the article on `min` [as to why][min] and comments below.

{% highlight c++ linenos %}
namespace algs {
  // generalized semistable partition forward taking predicate and projection
  template<typename I, typename S, typename Pred, typename Proj>
  // requires I is an ForwardIterator,
  //   S is a sentinel for I,
  //   Pred is an unary predicate on projection Proj of ValueType(I)
  I partition_semistable(I f, S l, Pred pred, Proj proj) {
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

Basic usage of `partition_semistable` looks like this:

{% highlight c++ linenos %}
  std::vector<char> v{'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i'};
  auto is_consonant = [](char x) {
    switch(x) {
      case 'a': case 'e': case 'i': case 'o': case 'u': return false;
      default: return true;
    }
  };

  auto pr = algs::range::partition_semistable(v, is_consonant);

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


# Algorithmic complexity

The function takes `O(n)` predicate applications, precisely one for each element in the
range (unless predicate or projection throws).


# Stability

`partition_semistable` is partially stable in that it preserves the order of the
values for which the predicate returns `false`, but does not preserve the order
of the values for which the predicate retrns `true`.

Other related algorithms make different choices.

One choice is to not give any stability guarantees. That's what
`std::partition` does. For bidirectional iterators there is an algorithm that
has fewer swaps, but gives up any stability guarantees. A function like
`partition` would map to the appropriate one for the iterator type.

If the data is stored in a linked list, an algorithm `partition_linked` that is
stable is possible by traversing the list, splitting and re-linking the nodes
into two chains based on the predicate.

Another choice is to provide stability guarantees for all the values in the
sequence, at the cost of more work or space. That's what `stable_partition` does.


# Pseudo predicate

When the predicate is only applied once it does not need to be a regular
function it can be just a **pseudopredicate: it has the signature of a
predicate, but it's not regular** (a regular function consistently returns the
same results for the same values). For example the sequence can contain HTTP
URLs and it can be partitioned based on a pseudo-predicate that downloads from
the URLs and checks if the download time is less than 200ms.

Another choice is to implement `partition_postion` and
`stable_partition_position` that pass to the predicate the iterator (position)
instead of the refrence to the value. Such a predicate could use the iterator
(position) to calculate an offset in another sequence and use a pre-computed
result, also taking advantage that the predicate is only applied once, for the
item in the origial position.

Theoretically some algorithms could choose to remove the guarantee that the
predicate is applied only once for each value.


# Related algorithms

- `partition_point` (find the partition point, assuming input is partitioned)
- `partition` (no stability guarantees, predicate applied once)
- `stable_partition` (partition, but stable, higher algorithmic complexity)
- `partition_linked` (stable partition for linked lists/iterators)
- `partition_position`, `stable_partition_position` (variants that supply the
  iterator to the predicate)
- `sort` (sorts values)


# References

- Elements of Programming (book by Alexander A. Stepanov and Paul McJones)
- [Better Code: Human Interface][sphi] by Sean Parent: showing recursive
  stable_partition and stable_partition_position
- [Article on implementing min][min], followed by linear find and swap

[min]:  {% post_url 2018-07-29-min-max %}
[sphi]: https://sean-parent.stlab.cc/presentations/2018-09-28-human-interface/2018-09-28-human-interface.pdf
