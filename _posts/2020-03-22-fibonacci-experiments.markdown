---
layout: post
title: 'Fibonacci Implementation Experiments'
categories: coding cpp
---

Lessons learned while calculating the 1 millionth entry in the Fibonacci
sequence


# Introduction

Ever since reading Chapter 3 in [Elements of Programming][eop], calculating
Fibonacci, pretending it's has high runtime complexity compared with other
functions, [looked silly][fib].

Later Sean Parent had a presentation on concurrency in which he asks people to
stop giving it as example for long running function, because here: he could
easily calculate [Fibonacci of 1 million in 0.72 seconds][sp], on a normal
consumer computer.

And yet, recently I indulged myself recently in this silly occupation, and
here's what I learned.


# Exponential naive

The naive implementation, follows the definition to the letter. It handles the
base case, then uses repeated recursion to calculate Fibonacci:

{% highlight c++ linenos %}
std::uint64_t exponential_naive(std::uint32_t x)
{
  if (x < 2) return x;
  return exponential_naive(x - 1) + exponential_naive(x - 2);
}
{% endhighlight %}

The problem with it is the exponential runtime growth, on my computer that
takes:
- about **1 second for `42`**
- about **6 seconds for `46`**

After that it takes quite a long time, which makes it unusable (except for
using it as an example of [compiler re-ordering of operations][reorder].


# Linear naive

It's easy to implement a function that has linear runtime growth:

{% highlight c++ linenos %}
std::uint64_t linear_naive(std::uint32_t x)
{
  if (x < 2) return x;

  std::uint64_t a = 0;
  std::uint64_t b = 1;
  for (--x; x > 0; --x)
  {
    std::uint64_t c = a + b;
    a = b;
    b = c;
  }
  return b;
}
{% endhighlight %}

It performs better, on my computer that takes:
- about **nothing for `42`**
- about **nothing for `46`**
- about **nothing for `96`**

If we want to calculate the value for 1 million, the argument `x` can fit into
an unsigned 32 bit integer, but the result won't.

Fibonacci of `96` is `12200160415121876738` and is the biggest result that we
can store on an unsigned 64 bit integer variable.


# Big O notation limitations

The big `O` notation is only part of the story. It works on assumptions of
infinity, while engineering works with finite resources. A great example is
this one we've just seen: `96` is nowhere near infinite, for such small values
we can implement the function as a lookup into an array with 96 values.


# Unsigned binary

So we need a big number. Sean Parent uses `boost::multiprecision::cpp_int`. How
hard can it be to write our own?

We can define our own arbitrary precision unsigned number as a vector of
unsigned 32 bit integers. An empty vector is zero, value at index `0` is the
least significant part.

{% highlight c++ linenos %}
using unit = std::uint32_t;
struct unsigned_binary
{
  std::vector<unit> units_;
  // ...
};
{% endhighlight %}

One implementation choise is between making it a concrete type (as above) or a
template. I think short term, we save a lot of effort by making it a concrete
type. What we loose is the ability to precisely count the operations by
substituting with instrumented types for the `unit`.

Then we can add arithmetical operators. We start with `+`, which it turn out,
is defined in a funny asymmetric way, that takes left hand side by value, which
might help with expressions like `a + b + c`.

{% highlight c++ linenos %}
using unit = std::uint32_t;
struct unsigned_binary
{
  std::vector<unit> units_;

  unsigned_binary & operator+=(const unsigned_binary & rhs);
  friend unsigned_binary operator+(unsigned_binary lhs, const unsigned_binary & rhs)
  {
    lhs += rhs;
    return lhs;
  }
};
{% endhighlight %}

To implement that we need a larger data type, where we can add the
corresponding units and the carry. The carry is `0` or `1`.

The only catch is that in the implementation the left hand side is `*this`
which mutates: we both read and write, some care is required e.g. use indexes
instead of iterators that might get invalidated as we resize.

{% highlight c++ linenos %}
using double_unit = std::uint64_t;
{% endhighlight %}

The addition for the arbitrary precision has complexity `O(n)` worst case where
`n` is the maximum of the length of the two terms of the addition (for the case
that carry propagates all the way. The average case is probably `O(n)`, but
this case the minimum of the length of the two terms, because the chances the
carry propagates decrease exponentially.

Similarly we can implement multiplication using the long multiplication
algorithm from primary school. That algorithm has a complexity if `O(n^2)`
(i.e. quadratic).


# Unsigned decimal

The next problem to solve is to display the number. My plan is to have an
associated type, that stores decimal digits in a vector, and convert between
the two types.

{% highlight c++ linenos %}
struct unsigned_decimal
{
  // vector of digits between 0 and 9
  std::vector<unsigned char> digits_;
};

unsigned_decimal make_unsigned_decimal(const unsigned_binary & value);

std::string to_string(const unsigned_decimal & value);
{% endhighlight %}

Printing is trivial: reverse iterate through `digits_` add `'0'` (which is `48`
in ASCII) to each value.

To do the conversion from `unsigned_binary`, keep a value for the current power
of 2 in decimal, go through each bit in `units_` and accumulate if the bit is
1, doubling (add to itself) the current power of two in each step. It has the
simplicity that it only needs addition for `unsigned_decimal`.


# First go

We're ready to copy/paste Sean's Parent Fibonacci implementation.

With a naive implementation for `unsigned_binary` and conversion, for Fibonacci
of `1,000,000` it took:
- about **2 seconds to calculate** Fibonacci in a `unsigned_binary`
- but a **very long time to convert** to `unsigned_decimal` (and print the decimal result).


# Improve conversion to decimal

It turns out that the conversion I used is `O(n^2)` operations. So my quick
plan was to try to reduce the value `n` to which the squaring applies.

I changed the approach used for `unsigned_decimal` and stored instead a vector
of 32 bit unsigned integers in a vector, where each value represents a number
in base `1,000,000,000` (from `0` to `999,999,999`).

{% highlight c++ linenos %}
using big_digit = std::uint32_t;

struct unsigned_decimal
{
  // vector of digits between 0 and 999,999,999
  std::vector<big_digit> digits_;
};
{% endhighlight %}

To convert I then repeatedly divided the `unsigned_binary` by `1,000,000,000`
to obtain one `big_digit` at a time.

It also turns out that the functions `from_chars` and `to_chars` from the
`<charconv>` header might not be useful in this case, as all the values from
the vector (except the one at the highest index) need to be padded with `0`s,
and those functions don't do padding.

In this approach I used a lot of info that's not impossible, but not trivial to
deduce programatically either. E.g. the fact that base `1,000,000,000` is the
best fit for a power of `10` into a 32 bit unsigned integer. Also used switches
up to `9` to calculate the lenght of the serialized string.

With an improved conversion, for Fibonacci of `1,000,000` it took:
- about **2 seconds to calculate** Fibonacci in a `unsigned_binary` (code
  unchanged)
- and about **1 second to convert** to `unsigned_decimal` (and print the
  decimal result, though most of the time is taken by the conversion).


# Karatsuba multiplication

Addition is `O(n)`, multiplication on the other side when implemented as
learned in school (long multiplication) is `O(n^2)`. There are algorithms that
do a bit better, one such is the Karatsuba algorithm that has a complexity of
about `O(n^1.58)`. It might not seem much of a difference but compare `n = 10`:
`10^2 = 100`, while `10^1.58 ~= 38`, which is less the half.

Unfortunately it also comes with constants due to additional allocations
(unless one is willing to go into custom allocators territory), so empirically
it seems that the threshold for using Karatsuba vs. long multiplication is
around `100` for the size of vectors of the operands.

Using Karatsuba multiplication, for Fibonacci of `1,000,000` it took:
- about **0.5 seconds to calculate** Fibonacci in a `unsigned_binary`
- and about **1 second to convert** to `unsigned_decimal` (code unchanged).


# Elements of Programming chapter 3 - revisited

It turns out that Sean Parent's example is from "From Mathematics to Generic
Programming", not from Elements of Programming.

In Elements of Programming the implementation uses half of matrix.

Using half matrix, for Fibonacci of `1,000,000` it took:
- about **0.3 seconds to calculate** Fibonacci in a `unsigned_binary`
- and about **1 second to convert** to `unsigned_decimal` (code unchanged).

So now the calculation is dominated by the conversion (and print).

Interestingly the power in EOP uses same type for argument and return value.

{% highlight c++ linenos %}
template<typename I>
  requires(Integer(I)
I fibonacci(I n) {
  // ...
}
{% endhighlight %}

That is nice from the point of view of deducing the arguments. But we've seen
that in practice the argument is much smaller than the return value, that's why
I used different types: unsigned 32 bit for the argument of 1 million and
`unsigned_binary` for the return value. For this case in particular it would
likely not make much of a difference.


# Could have kept on going on

I stopped there. Could have tried to see what difference it makes by using a
more optimised power algorithm. Could also spend more effort on the conversion
issue. Could have also try to look at (and reduce) allocations.


# More lessons learned

I did not always go for the absolute minimum steps that I needed. I could have
saved some effort there. For example I also implemented less than operators for
the arbitrary precision numbers, where equality was enough (for tests). I also
implemented conversion from `unsigned_decimal` to `unsigned_binary`, where I
only needed conversion the other way.

Also at the beginning I spend what looked like a disproportionate amount of
time setting up build, test, debugging environment so that it's trivially easy
and convenient to perform those activities. This did pay off as when I
refactored (e.g. multiplication), test showed me regressions and after a quick
debug, 5 minutes later the issue was fixed.


# References

- Alexander A. Stepanov and Paul McJones: [Elements of Programming][eop]
- Sean Parent's [concurrency presentation][sp]
- [More notes][fib] on Fibonacci
- [Compiler reordering][reorder]



[eop]: http://elementsofprogramming.com/
[sp]: https://sean-parent.stlab.cc/presentations/2017-01-18-concurrency/2017-01-18-concurrency.pdf
[fib]: {% post_url 2016-12-14-eop-fibonacci %}
[reorder]: /presentations/2020-03-20-threading.html#4

