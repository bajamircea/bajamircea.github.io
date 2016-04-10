---
layout: post
title: 'C++ std::move and std::forward'
categories: coding cpp
---

WORK IN PROGRESS.
This article covers C++ lvalues, rvalues and references to get to the point that
std::move does not move and std::forward does not forward, they are more akin
to type casts instead.


## Motivation

[N4543][n4543] suggests a solution for when the content of a `std::function` is
not copyable. But if first starts with the code below. It has a `commands`
variable that maps strings to functions, and a utility function to insert a new
command.

{% highlight c++ linenos %}
std::map<std::string, std::function<void()>> commands;

template<typename ftor>
void install_command(std::string name, ftor && handler)
{
  commands.insert({
    std::move(name),
    std::forward<ftor>(handler)
  });
}
{% endhighlight %}

The code above is easy to read, but has subtleties. The goal of the article is
to provide enough background information to be able to understand in detail
each line, in particular why does it use `std::move` in one place (at line 7)
and `std::forward` in another (at line 8).

We'll start with the theory, but then dive quickly into C++ speciffics.


## Value categories (lvalue, prvalue and xvalue)

A C++ expression has in addition to a type, a value category.  Traditionally
the main value categories were `lvalue` and `rvalue` with a rough meaning that
it if could stand on the left side of an assignment it's an `lvalue`, otherwise
it's an `rvalue`.

With the advent of C++ 11, additional value categories have been identified and
[organized in a systematic way][value-category-hist] based on the observation
that there are two important properties of an expresion: **has identity** (i.e.
'can we get its address') and **can be moved**.

If we ignore the combination where the expression has no identity and cannot be
moved, the naming of the rest is ilustrated using Venn diagrams below.

![Value categories Venn diagrams](/assets/2016-04-07-move-forward/value-categories.png)

- If if has identity, but cannot be moved it's an `lvalue`; otherwise it's an
  `rvalue`. A typical `lvalue` is a variable name `a`.
- If it can be moved, but has no identity is a `prvalue` (pure right value);
  otherwise it's a `glvalue` (generalized left value). A typical `prvalue` is a
  temporary resultint from a function call/operator (with a non-reference
  return type) like `s.substr(1, 2)` or `a + b` or integral constant like `42`.
- If it has an identity and can be moved it's an `xvalue` (because that was
  considered strange, and `x` is a good identifier for weird things). A typical
  `xvalue` is `std::move(a)`.

One observation is that: **one can covert from a `lvalue` to a `rvalue` (to an
`xvalue` more precisely) by using `std::move`**.

## References as function arguments (are lvalues)

There are two types of reference declarations in C++. The pre-C++ 11 is called
now `lvalue reference` (and uses one `&`), and the new C++ 11 called `rvalue
reference` (that looks like `&&`).

If a function has `lvalue reference` argument, then it accepts an `lvalue`,
but not an `rvalue`.

{% highlight c++ linenos %}
void fn(X &) { std::cout<< "X &\n"; }

int main()
{
  X a;
  fn(a); // works, argument is an lvalue

  fn(X()); // compiler error, argument is an rvalue
}
{% endhighlight %}

Similarly if a function has a `rvalue reference` argument, then it accepts
an `rvalue`, but not an `lvalue`.

{% highlight c++ linenos %}
void fn(X &&) { std::cout<< "X &&\n"; }

int main()
{
  X a;
  fn(a); // compiler error, argument is an lvalue

  fn(X()); // works, argument is an lvalue
}
{% endhighlight %}

But inside the function body an argument, whether `lvalue reference` or
`rvalue reference`, is an `lvalue` itself: it has a name like any other
variable.

{% highlight c++ linenos %}
void fn(X && x)
{
  // x is an lvalue here
  // can use std::move to convert it to an xvalue
}
{% endhighlight %}

From here, things get even more complicated when one notices that `const`
matters.  In the example below, `fn` accepts both an `lvalue` and an `rvalue`.

{% highlight c++ linenos %}
void fn(const X &) { std::cout<< "const X &\n"; }

int main()
{
  X a;
  fn(a); // works, argument is an lvalue

  fn(X()); // also works, argument is an rvalue
}
{% endhighlight %}


## References and function overloads

[We could provide overloads][msdn] for `fn`, and we end up with three overload options
(ignoring `const X &&` because it's more obscure). If for an expression the
preferred overload is not available, there is a fallback mechanism until all
options are exhausted, and then we get a compiler error.

{% highlight c++ linenos %}
#include <iostream>

struct X {};

// overloads
void fn(X &) { std::cout<< "X &\n"; }
void fn(const X &) { std::cout<< "const X &\n"; }
void fn(X &&) { std::cout<< "X &&\n"; }

int main()
{
  X a;
  fn(a);
  // lvalue selects fn(X &)
  // fallbacks on fn(const X &)

  const X b;
  fn(b);
  // const lvalue requires fn(const X &)

  fn(X());
  // rvalue selects fn(X &&)
  // and then on fn(const X &)
}
{% endhighlight %}

## Reference colapsing rules

## std::move and std::forward possible implementation

{% highlight c++ linenos %}
template<typename T> struct remove_reference { typedef T type; };
template<typename T> struct remove_reference<T&> { typedef T type; };
template<typename T> struct remove_reference<T&&> { typedef T type; };

template<typename T>
constexpr remove_reference<T>&& move(T && arg) noexcept
{
  return static_cast<remove_reference<T>&&>(arg);
}

template<typename T>
constexpr T&& forward(typename remove_reference<T> & arg) noexcept
{
  return static_cast<T&&>(arg);
}

template<typename T>
constexpr T&& forward(typename remove_reference<T> && arg) noexcept
{
  return static_cast<T&&>(arg);
}

{% endhighlight %}


## Move semantics

## Perfect forwarding

## Conclusion

- move and forward
  - can look at them as casts
  - move does not move
  - forward is used mainly with the same type
- move semantics
- perfect forwarding
- function overloading, template specialization

[n4543]: http://www.open-std.org/jtc1/sc22/wg21/docs/papers/2015/n4543.pdf
[value-category-hist]: http://www.stroustrup.com/terminology.pdf
[value-category-ref]: http://en.cppreference.com/w/cpp/language/value_category
[pass-by-value]: http://cpp-next.com/archive/2009/08/want-speed-pass-by-value/
[thbecker]: http://thbecker.net/articles/rvalue_references/section_08.html
[msdn]: https://msdn.microsoft.com/en-us/library/dd293668.aspx
