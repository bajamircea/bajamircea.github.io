---
layout: post
title: 'The things we know'
categories: coding cpp
---

Algorithmic efficiency often has at its roots things we know, and therefore
skip unnecessary calculations. Not all the things we know can be checked by the
computer.

This article is part of a series on [the history of regular data type in
C++][regular-intro].


For the end of this series I'd like to make the case that the regular concept
is part of a larger idea that traverses the "Elements of Programming". And that
is that **it's things that we know that we can use for algorithmic efficiency
to reorganize calculations and eventually skip unnecessary calculations**.

I'm going to try to illustrate this using some memorable canonical examples.

# Add

{% highlight c++ linenos %}
// domain of the function are x and y such that `x + y` does not overflow
unsigned int add(unsigned int x, unsigned int y) {
  return x + y;
}
{% endhighlight %}

In this case the precondition could be checked using this predicated, but the
calculation is about as costly as the work inside `add` itself

{% highlight c++ linenos %}
bool in_domain_of_add(unsigned int x, unsigned int y) {
  return ((UINT_MAX - x) >= y);
}
{% endhighlight %}

This is an example where a check could be done, with some loss of efficiency,
but also some efficiency gained if skipped when it is known that overflow will
not happen for those specific input values.


# Binary search, lower bound, partition point

There is a family of algorithms that use divide and conquer on a already
ordered range. Here is for example `binary_search` that can efficiently find in
the `value` is in the range by halving the search range at each step leading to
`O(lg(N))` time complexity.

{% highlight c++ linenos %}
template<class It, class T>
// It is random access iterator
bool binary_search(It first, It last, const T & value);
{% endhighlight %}

But itself it does not check if the sequence is sorted. Similar issues apply to
lower bound and partition point for the requirement that the sequence is
partitioned for the comparison used (defaults to '<').

A runtime check that the input range is sorted would degrade the time
complexity to `O(N)`.

This is an example where a check could be done, but at a meaningful performance
cost.


# first and last

A lot of the algorithms operate on ranges of data that are often expressed as
two iterators as generalized pointers, as in the case of `binary_search`. They
take `first` and `last` then for linear traversal there is a loop like:

{% highlight c++ linenos %}
while(; first != last ; ++first) {
  // use value pointed by first
}
{% endhighlight %}

But it does not check that `last` is reachable from `first`. The caller needs
to know that. Such a check is often not even possible for certain data
structures.


# Rotate

The algorithm rotate takes three iterators:

{% highlight c++ linenos %}
template<class It, class T>
// It is random access iterator
It rotate(It first, It middle, It last);
{% endhighlight %}

The result is that between `first` and `last` we end up with the values that
were between `middle` and `last`, followed by the values that were between
`first` and `middle`. It does that in a surprisingly `O(N)` time complexity
with constant memory requirements.

Roughly the code idea to make that work is that it figures out where the value
at `first` needs to go. It saves the target value in a temporary and stores the
value from `first`.  Then it figures out where that temporary needs to go and
so on until we complete a cycle going back all the way to `first`. And then
there are `GCD(M, N)` such cycles where `N` is the total number of values between
`first` and `last`, `M` is the number of values between `first` and `middle`
and `GCD` is the greatest common divisor.

This is interesting because, in the C++ world of destructing moves, every time
we move from a value, the move (constructor or assignment) also changes the
moved from object. This is not required in the case of `rotate` because "we
know" based on the clever reasoning that each of the `GCD(M, N)` number of
cycles will be complete. Currently this might be an optimisation that does not
take place in C++ because the compiler does not know that.


# Replace

The replace traverses a linear sequence and replaces a value with another:

{% highlight c++ linenos %}
template<class It, class T>
// It is forward iterator
It rotate(It first, It last, const T & old_value, const T & new_value);
{% endhighlight %}

But what if we use like this with references to values from the sequence?

{% highlight c++ linenos %}
std::replace(v.begin(), v.end(), v[3], v[2]);
{% endhighlight %}

Although `const` the problem is that the `old_value` is alised, it's also part
of the sequence. Another way to look at it is that `v[3]` is accessed both via
the pointer behind the `const T &` and the pointer behind the `It first` after
it gets incremented a few times.

In correct usage we know we're not doing that, but it's an interesting fact
that in many cases (correct, unlike the incorrect usage of `replace` above),
the compiler does not know that we're not aliasing and inserts more code to
cope with that.

Note that one of the reason Fortran is faster than C/C++ is that Fortran
assumes that function arguments do not alias.

# Fibonacci and associativity

Naive implementations of Fibonacci sequences take exponential time with the
argument, so they get slow very fast taking seconds for an argument of 40
something. A slightly better option is linear in time. But efficient
implementations can calculate it [in logarithmic time][fibonacci1] taking [less
than a second for an argument of 1 million][fibonacci2]. The idea is that to
calculate the values for `N` and `N - 1`, one multiplies a matrix with the
values at `N - 1` and `N - 2`. Repeat the process and you end with multiplying
the matrix with itself. We know that the matrix multiplication is associative
and that's what enables it to be done in `O(lg(N))` time.

Note that's covered in chapter 3 of EOP.


# Orbits and regularity

When you apply a function `T f(T x)` repeatedly the outcome can be:
- infinite: it goes on without getting back to a previous value, e.g. append a
  char to a string (until we run out of memory)
- terminating: eventually cannot go further: e.g. `unsigned int` increment
  terminates at the max value if we don't want it to overflow
- circular: it comes back to where we started: e.g. `usigned int` increment
  that goes back to `0` after the max value
- ρ-shaped: it creates a loop, but not to where we started, e.g. increment then
  take modulo(3) then leads to a sequence like `7, 2, 0, 1 , 2, 0, 1, ...`

For this domain if the shape is not infinite one can use algorithms that
determine the shape by having a fast traversal followed by a slow traversal and
testing for end (terminating) or the two traversal giving the same value
(circular or ρ-shaped).

Here is the core idea:

{% highlight c++ linenos %}
auto slow = x;
auto fast = f(x);
while (fast != slow) {
  slow = f(slow);
  fast = f(fast);
  fast = f(fast);
}
{% endhighlight %}

These obit algorithms are quite obscure, but they show in the simplest setting
the reliance of algorithms on regularity (in this case it's regularity that
ensures that the slow traversal follows the fast one).

Note that's covered in chapter 2 of EOP, but regularity is fundamental for most
algorithms.


# Irregular partition

You have a vector of unique file names corresponding to files that you want to
update. You want to separate this into the file names that correspond to files
that already exist and the ones that are missing. Then further separate the
existing file names into the ones that are the correct version vs.
older/different version. That results in: files names that correspond to files
that are OK, need updating or need installing for the first time.

We could use the `partition` algorithm twice where the predicate checks if the
file exist and if the file version is correct.

{% highlight c++ linenos %}
template<class It, class UnaryPredicate>
// It is bidirectional iterator
It partition(It first, It last, UnaryPredicate p);
{% endhighlight %}

But the problem is that the predicate is not a regular function. EOP and the
C++ standard define a predicate as a regular function. But in the case of the
`partition` the predicate is meant to be called only once for each value in a
sequence of unique values. Regularity for functions involves calling repeatedly
a function with equal values. Well, that's not the case here.

This illustrates that for library/language design there is a trade-off between
elegance/simplicity and functionality/flexibility.

If you insist that the `partition` predicate has to be a regular function,
**you end up with a more elegant/simpler solution at the const of the kind of
problems that the algorithm can solve**. The example I gave is probably
dominated by IO operations, but should you aim to solve if efficiently, one
solution involves exactly the same code as the `partition` algorithm.


# A note on value semantics: actions vs. transformations

So if values are good and aliasing is so problematic, why don't we just use
values? Why do we pass vectors by reference, e.g. `auto foo(const
std::vector<T> & vec)`? The aliasing problems come from multiple pointers to
the same data, where the pointers are either embedded into iterators or through
the usage of references.

I guess that partly the answer is in EOP chapter 2.5. After describing orbits
in terms of transformations in most of chapter 2, at the end of chapter it
describes the duality between actions and transformations: they can be each
described in terms of the other:

{% highlight c++ linenos %}
// action defined in terms of transformation
void a(T & x) {
  x = f(x);
}

// transformation defined in terms of action
T f(T x) {
  a(x);
  return x;
}
{% endhighlight %}

Mathematically they are equivalent, the difference is in efficiency: if `T` is
a large object and the change is small, actions could be much faster. When
passing a large object and there is no change we use `const` reference.

Fundamentally it comes to: when we know that the data is not aliased and the
data is large, transferring data by just transferring a pointer to the data is
faster than transferring a copy of the data.


# References

Alex Stepanov and Paul McJones: Elements of Programming aka. EOP

[Value Semantics: Safety, Independence, Projection, & Future of Programming -
Dave Abrahams CppCon 22](https://www.youtube.com/watch?v=QthAU-t3PQ4) for the
`std::replace` example

[regular-intro]:   {% post_url 2022-11-16-regular-history %}
[fibonacci1]:      {% post_url 2016-12-14-eop-fibonacci %}
[fibonacci2]:      {% post_url 2020-03-22-fibonacci-experiments %}
