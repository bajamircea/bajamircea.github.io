---
layout: post
title: 'Noncopyable and unintended ADL'
categories: coding cpp
---

This is an in-depth look at the noncopyable class in the C++ boost libraries
and the unintended argument dependend lookup (ADL) protection trick.


**Note:** A better alternative is to [delete the copy constructor and
assignment][cpp-copy], but this article is still useful to understand the
mechanics of inheritance and unintended ADL.

# Usage

I sometimes use `boost::noncopyable` to express/ensure that a class
cannot/should not be copied. The usage is simple: derive `private` from it.

{% highlight c++ linenos %}
#include <boost/core/noncopyable.hpp>

class some_class :
  private boost::noncopyable
{
  // ...
};

void some_fn()
{
  some_class a;
  // line below would fail to compile
  // some_class b = a;
}
{% endhighlight %}

# Code implementation and analysis

The implementation code for `boost::noncopyable` (contributed by Dave Abrahams)
looks something like:

{% highlight c++ linenos %}
namespace boost {
  namespace noncopyable_ {
    class noncopyable {
    protected:
      constexpr noncopyable() = default;
      ~noncopyable() = default;
      noncopyable(const noncopyable &) = delete;
      noncopyable & operator=(const noncopyable &) = delete;
    };
  }
  using noncopyable = noncopyable_::noncopyable;
}
{% endhighlight %}

## Empty class

Line 3 declares the `noncopyable` class to derive from. It is an empty class,
with no member variables, so in many cases deriving from it will have no size
overhead (due to the empty base class optimisation).

## Prevent copy

Lines 7 and 8 delete the copy constructor and copy assignment. This prevents a
derived class from being copied. It uses the C++ 11 syntax to delete them.
Before C++ 11 the copy constructor and copy assignment would have been made
private (and only declared, not defined).

## Copy and destruction

Lines 4,5 and 6 define the default copy and destructor. They are required
because the compiler would stop generating them once we deleted the copy
function. It uses the C++ 11 syntax to request the compiler to generate
defaults. The access is `protected` which allows the derived class to access
them, but prevents someone directly creating a `noncopyable` instance (to
re-enforce that it's supposed to be derived from).

The constructor is marked `constexpr`. Without it one could not have a
`constexpr` instance of the derived class.

## Boost namespace

Line 1 and 12. Trivial.

## Prevent unintended ADL

Lines 2, 10 and 11. This is for me the most interesting feature of the
implementation. The potential problem is caused by ADL.

ADL (of Andrew Koenig fame) allows the code below to work, because in `main`,
the function `some_fn` is not qualified with a namespace, so `some_fn` is
looked up (and found) in the namespace `X` for the type `Y` of its argument
`z`.

{% highlight c++ linenos %}
namespace X {
  struct Y {};
  void some_fn(const Y &) {}
}

int main() {
  X::Y z;
  some_fn(z);
}
{% endhighlight %}

Often that's what we want, and it's what makes `operator<<` find the right
namespace, based on the arguments provided.

However, the trick is that the lookup is also performed in the namespace of the
derived classes for the argument. We would not want a class derived from
`noncopyable` to get involved in ADL against functions in the `boost` namespace.

To avoid that, `noncopyable` is not declared in the `boost` namespace directly,
but instead in a namespace called `noncopyable_` (notice the extra ending
underscore) which has no functions, hence avoids the unintended ADL. The name
`noncopyable` is then reintroduced to the `boost` namespace with the `using` on
line 11.

# Controversies

## Taste and style

Which is better? Should one use `noncopyable`:

{% highlight c++ linenos %}
#include <boost/core/noncopyable.hpp>
struct one_class:
  private boost::noncopyable
{
};
{% endhighlight %}

or explicitly delete copy constructor an assignment:

{% highlight c++ linenos %}
struct two_class
{
  two_class(const two_class &) = delete;
  two_class & operator=(const two_class &) = delete;
};
{% endhighlight %}

or rely on side effects of implementing move:

{% highlight c++ linenos %}
struct three_class
{
  three_class(three_class &&) = default;
  three_class & operator=(three_class &&) = default;
};
{% endhighlight %}

I think people could easily argue either way.

My view is that not all classes are equal. Some are used very few times (e.g.
once or twice), others are library classes used a lot.

For library classes, especially if I need to put the effort to implement move
as well, then I'll be explicit about deleting the copy operations, not use
`noncopyable` and not rely on side effects.

But for classes that are used just a few time in my code, I find that the
`noncopyable` approach is easier to read, because it avoids the repetition of
the class name.

## Optimisation issues

Empty classes still have a `sizeof` equal to 1, the idea being that it is
required so that we can get the address of an instance of that class. The empty
class optimisation ensures that an empty base class does not add to the derived
class size.

However in a diamond derivation case like below there is an overhead for
deriving from the same `noncopyable` class (compared with just deleting copy
constructor and assignment for classes `A` and `B`.

{% highlight c++ linenos %}
#include <iostream>

struct A: private boost::noncopyable { };
struct B: private boost::noncopyable { };
struct C: public A, public B { };

int main() {
  // prints 2
  std::cout << sizeof(C) << "\n";
}
{% endhighlight %}

The size is 2 in the example above so that there are different addresses for
each `noncopyable` base class.

However in practice this overhead might not be an issue, because if for example
class `C` would have a member of type `int` of size 4, then the size of `C`
would be just 4, not 6.

# References

- [Boost documentation on noncopyable][boost-doc]
- [Howard Hinnant's stackoverflow answer on noncopyable][hh-answer]

[boost-doc]: http://www.boost.org/doc/libs/1_63_0/libs/core/doc/html/core/noncopyable.html
[hh-answer]: http://stackoverflow.com/questions/7823990/what-are-the-advantages-of-boostnoncopyable/7841332#7841332
[cpp-copy]:  {% post_url 2022-11-30-cpp-copy %}

