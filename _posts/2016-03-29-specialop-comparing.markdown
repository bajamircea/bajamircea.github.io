---
layout: post
title: 'Special class operations. Comparing'
categories: coding cpp
---

This article looks at the next layer of fundamental behaviour of a class:
how two instances compare (for equality and order).


## Syntax

There are 6 comparison operators in C++: `==`, `!=`, `<`, `>`, `<=`, `>=`.

{% highlight c++ linenos %}
if (a == b) // 'operator ==' used here
{
  // ...
}

if (a!= b) // 'operator !=' used here
{
  // ...
}

if (a < b) // 'operator <' used here
{
  // ...
}

//...
{% endhighlight %}

The operators, to take `==` for example, return `bool` and can be defined as
members for a class (with one argument, in addition to `this`) or as a free
function with two arguments and return a `bool`.

{% highlight c++ linenos %}
class X
{
  // as a member function
  bool operator== (const X & other) const noexcept
  {
    // ...
  }

  // when as a free function ofen declared as a friend
  // to allow it to access private members
  friend bool operator== (const X & left, const X & right) noexcept;
};

// OR as a free function
bool operator== (const X & left, const X & right) noexcept
{
  // ...
}
{% endhighlight %}

You really need to define at most two of them: `==` and `<`, the others can be
(and should be, to maintain sanity) implemented in terms of them e.g.:

{% highlight c++ linenos %}
bool operator!= (const X & left, const X & right) noexcept
{
  // calls 'operator ==' implementation
  // and negates result
  return !(left == right);
}

bool operator> (const X & left, const X & right) noexcept
{
  // calls 'operator <' implementation
  // but with switched positions for left and right
  return right < left;
}
{% endhighlight %}


## Practicalities

Often a simple way to implement comparison operators for a class is to write a
function to tie the member variables together and rely on the `tuple`
comparison implementation.

{% highlight c++ linenos %}
#include <string>
#include <tuple>

struct X
{
  int i;
  std::string s;

  auto members() noexcept const
  {
    // return tuple of const references to member variables
    return std::tie(i, s);
  }
};

bool operator== (const X & left, const X & right) noexcept
{
  // rely on the std::tuple.operator== implementation
  return left.members() == right.members();
}

bool operator< (const X & left, const X & right) noexcept
{
  // rely on the std::tuple.operator< implementation
  return left.members() < right.members();
}

// Implement the rest in terms of the two above
// example below for !=, but similar for >, <=, >=
bool operator!= (const X & left, const X & right) noexcept
{
  return !(left == right);
}

#include <iostream>

int main()
{
  X one { 42, "one"};
  X two { 42, "two" };
  std::cout << ((one == two) ? "same" : "different") << std::endl;
  std::cout << ((one < two) ? "smaller" : "bigger") << std::endl;
}
// Compile with $ g++ --std=c++1y main.cpp
// Running ./a.out will print:
// different
// smaller
{% endhighlight %}


## Meaning

On one side we have [regular][regular] classes. Think of `int`. We can construct
it (with a default constructor), we can copy and move it (both construct and
assign), we can compare for equality and less than. And all of these properties
play together as you would expect them to: the order is total (e.g. given
two variables they are either equal, or one is smaller), a copy is equal to the
variable we copied from etc.

On the other side we have classes for which comparison just does not make
sense. See `noncopyable`.

And then there are the inbetweeners. This is not an exclusive list but here are
some examples.

Pointers (including say `shared_ptr`) do a shallow comparison, comparing the
addresses, not the actual pointed data.

`float` and `double` are almost regular, except for `NaN` (all comparisons with
`NaN` return `false`).

Most basic containers are regular (assuming the `value_type` is regular)
though, unlike an `int`, copy might throw.  When compared, they do what you
would expect, e.g. compare lexicographically.

The unordered containers however only compare for equality, not for less than.
The reason is runtime cost.

Another example where the equality is not implementable because of cost are
functions. Two functions that for the identical inputs provide the same result
are equal in mathematical sense, but good luck with implementing a `operator==`
with this meaning.

Another issue is that sometimes is better to have a comparison function that
returns 3 possible values (less, equal or greater), than the comparison
operators that return a `bool`.

The above issues just scratch the surface of the subject, I'll leave to that
for the moment.

[regular]:     {% post_url 2016-12-15-eop-regular %}
