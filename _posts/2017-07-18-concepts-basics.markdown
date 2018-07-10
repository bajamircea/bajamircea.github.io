---
layout: post
title: 'C++ concepts basics'
categories: coding cpp
---

C++ concepts (N4647): cover the basics and show how they relate to templates
(the "peel off onion layers" technique).

This article is also available as [presentation
slides](/presentations/2017-07-18-concepts-basics.html)

# Introduction

The fundamental claim is that we use concepts to model the world, in the same
way we use types and instances of a type. See the abstract/concrete genus on
the 2nd page of "Elements of programming" for this claim. The question is
how to best represent them in C++.

The C++ concepts (as in the [N4647][n4647] proposal for the C++ language) are
part of the continuing the work on providing better support for generic
programming.

They have a long history that includes older proposals that almost made into
the C++ 11 standard, a major rethink as part of the Palo Alto report, which led
to the current proposal for which this article will cover the basics.

Concepts also have a close relationship to templates. This article will also
cover the "peel off onion layers" technique of incrementally decomposing
concept usage to its templates equivalents.


# Context - generic min

To provide some context, I'll start with one of the simplest generic methods,
called `min` (i.e. like `std::min` from the standard library) that takes two
arguments and returns the smaller one of the two.

Using C++ templates, the declaration would look like this:

{% highlight c++ linenos %}
template<typename T>
const T & min(const T & a, const T & b) {
  // implementation here
}
{% endhighlight %}

In the code above, `min` is a template function with a type `T` as a parameter.
It takes two arguments by `const` reference of `T` which means that they will
not be copied, and could be either some variables or temporaries. The return
value type is the same of the the two arguments.

Note that, you might also consider an overload that takes non-const references
(unlike the current standard `std::min`).

As for the implementation a first option would look like:

{% highlight c++ linenos %}
if (a < b) return a; else return b; // not quite right
{% endhighlight %}

This implementation will do, except that it does not provide the ideal
behaviour when the values of the arguments are equal.

One train of thought is that if the arguments are equal, it does not matter
which one is returned.

However equal does not mean identical, and one can probe the address of the
returned value to see which one is returned.  Also `min` does not exist in
isolation, but in relationship with other algorithms.

You might have a `max`, and then you might expect that `min` and `max` never
return the same argument (unlike the current `std::min` and `std::max`).  Also
`min` is some sort of minimalistic `sort` and there we also have a
`stable_sort` with the meaning that it preserves the order of equal elements,
(with an additional cost in the case of `stable_sort`).

That means that it makes sense for `min` to return the first argument when
equal, because it turns out that we can have the stability property at
additional cost:

{% highlight c++ linenos %}
if (a <= b) return a; else return b; // still not quite right
{% endhighlight %}

But again `min` does not live in isolation, and you might expect a generalized
version that takes a comparison function which traditionally works similar to
`<`. That leads to:

{% highlight c++ linenos %}
if (b < a) return b; else return a;  // canonical implementation
{% endhighlight %}

The generalized version of `min`, that takes a comparison function, would look
very similar, passing to the comparison function `b` first and `a` second, in
the same order as for `<` above.


# Concepts

The question now is: what are the requirements on the arguments (and the type
`T` of the arguments in particular)?

Given the definition above the type `T` is usually deduced, so one can call
`min(3, 4)` and the compiler determines that the type `T` is `int`.

The type `T` could be some built-in type, like `int`, or a user defined type
with appropriate operators defined, like `std::string` or a `person` structure
with first name and last name as fields.

One option would be to say that type `T` has to have an operator `<` defined
and that's pretty much it. This approach does not work at scale.

The other approach would be to first realize that when we discussed the
implementation of `min` above, we expect that if `<` is defined, then also `>`,
`<=` and `>=` are defined. Also `<` is related to `==` that should also be
defined. This would be syntactic expectations. Also we would expect them to
work in a particular way, for example that given two values `a` and `b`, then
either `a < b` or `b < a` or `a == b`. This would be semantic expectations.

The current proposal for concepts in C++ allows capturing the syntactic
requirements, however good practice is that they are backed by semantic
expectations (that the current proposal will not capture or enforce).

{% highlight c++ linenos %}
template<typename T>
concept bool StrictlyTotallyOrdered() {
  return EqualityComparable<T>() &&
    requires (const T a, const T b) {
      { a < b } -> Boolean;
      { a > b } -> Boolean;
      { a <= b } -> Boolean;
      { a >= b } -> Boolean;
    };
}
{% endhighlight %}

In the current proposal concepts are templates, introduced by the `concept`
keyword. They are booleans evaluated at compile time either as a function
(above) or a variable. Because they are templates you can for example have more
than one type and express requirements between several types (e.g. between a
matrix, vector and scalar type), or even non-types (e.g. an integer constant).

In this case `StrictlyTotallyOrdered` relies on `EqualiyComparable` for the
equality requirements, and defines on top of that it's own syntactic
requiremens using the new `requires` keyword. This concept has semantic
expectations that are not captured.

Here `requires` is a `requires-expression`.


# Usage

With that concept the `min` function can look like below.

{% highlight c++ linenos %}
const StrictlyTotallyOrdered & min(
    const StrictTotallyOrdered & a,
    const StrictTotallyOrdered & b) {
  if (b < a) return b; else return a;
}
{% endhighlight %}


However the above is really an abreviated template and using the "peel the
onion layers" looks like the template below.

{% highlight c++ linenos %}
template<StrictlyTotallyOrdered T>
const T & min(const T & a, const T & b) {
  if (b < a) return b; else return a;
}
{% endhighlight %}


The above looks almost like a traditional template function, except that it
uses the concept name instead of `typename`.

Again this is equivalent to the one below.

{% highlight c++ linenos %}
template<typename T>
  requires StrictlyTotallyOrdered<T>()
const T & min(const T & a, const T & b) {
  if (b < a) return b; else return a;
}
{% endhighlight %}

`requires` above is a `requires-clause`, and other than that it looks like a
traditional template function.

The rule that we used to derive this equivalent is that the first template
parameter of a concept definition is special (named `prototype parameter`) and
when we replace the concept with `typename` and move it into the
`requires-clause` then we fill it with the type `T` that stood in front of it.

When `min` is instantiated with some type (typically deduced from the
arguments), then the compiler evaluates at compile time the concept with that
type as a boolean: true if we have a match, false if we don't.


# Constraints

Let's look at a `requires-expression` and see what type of constraints we can
apply.

{% highlight c++ linenos %}
requires(const B b1, const B b2) {
  bool(b1); // expression constraint
  typename B::type; // type constraint
  { !b1 } -> bool; // implicit conversion
  { b1 && b2 } -> Same<bool>; // argument deduction
}
{% endhighlight %}

The first constraint is an expression constraint: the expression `bool(b1)`
must compile.

The second is a type constraint `B` must define a type `type`.

The third example is in addition that `!b1` must compile, it must be
convertible to a `bool`.

The last example is a bit more complex.`b1 && b2` must compile, and the
expression must be kind of `Same<bool>`.

The problem is that `Same` is a concept, and the intution says that it must
take two types, e.g. `T` and `U`, and the concept enforces that the types are
the same. But here we just see one type: `bool`. Where is the other type?

What happens is that if what follows `->` contains is a concept as above, then
the compiler invents some fictional function with that as the argument type and
checks if it can pass the expression as the argument for that invented
function.

{% highlight c++ linenos %}
void fn(Same<bool> x); // invent
fn(b1 && b2); // check if it compiles
{% endhighlight %}

From then on it's simple: the invented function `fn` is equivalent to:

{% highlight c++ linenos %}
template<Same<bool> T>
void fn(T x);
{% endhighlight %}

Which is equivalent to:

{% highlight c++ linenos %}
template<typename T>
  requires Same<T, bool>
void fn(T x);
{% endhighlight %}

And that's as above because again the first template parameter of a concept
definition is special.

So now sanity is restored we see that `Same` is actually used with two types as
expected.


# Error messages

Error messages are notoriously difficult when dealing with templates.

`min` as above would probably be implemented simply as:

{% highlight c++ linenos %}
  if (b < a) return b; else return a;
{% endhighlight %}

But often we delegate the implementation to other functions e.g.:

{% highlight c++ linenos %}
struct less
{
  template<typename T>
  bool operator()(const T & a, const T & b) const {
    return a < b;
  }
};

struct identity
{
  template<typename T>
  const T & operator()(const T & x) const {
    return x;
  }
};

// generalized min taking comparison and projection
template<typename T, typename Cmp, typename Proj>
const T & min(const T & a, const T & b, Cmp cmp, Proj proj) {
  if (cmp(proj(b), proj(a))) return a; else return b;
}

// generalized min taking comparison
template<typename T, typename Cmp>
const T & min(const T & a, const T & b, Cmp cmp) {
  return min(a, b, cmp, identity());
}

// straight forward min
template<typename T>
const T & min(const T & a, const T & b) {
  return min(a, b, less());
}
{% endhighlight %}


If you try to invoke the straight forward `min` with an unsuitable type you'll
get an error that basically follows the nesting of whatever the implementation
happens to be:

{% highlight linenos %}
program.cpp: In instantiation of ‘bool less::operator()(const T&, const T&) const [with T = X]’:
program.cpp:24:10:   required from ‘const T& min(const T&, const T&, Cmp, Proj) [with T = X; Cmp = less; Proj = identity]’
program.cpp:29:13:   required from ‘const T& min(const T&, const T&, Cmp) [with T = X; Cmp = less]’
program.cpp:34:13:   required from ‘const T& min(const T&, const T&) [with T = X]’
program.cpp:47:24:   required from here
program.cpp:10:14: error: no match for ‘operator<’ (operand types are ‘const X’ and ‘const X’)
     return a < b;
              ^
{% endhighlight %}

With concepts the error message would look differently:

{% highlight linenos %}
prog.cc:38:32: note: candidate: 'const StrictlyTotallyOrdered& min(const auto:1&, const auto:1&) [with auto:1 = X]'
 const StrictlyTotallyOrdered & min(const StrictlyTotallyOrdered & a, const StrictlyTotallyOrdered & b) {
                                ^~~
prog.cc:38:32: note:   constraints not satisfied
prog.cc:2:14: note: within 'template<class T> concept bool StrictlyTotallyOrdered() [with T = X]'
 concept bool StrictlyTotallyOrdered() {
              ^~~~~~~~~~~~~~~~~~~~~~
prog.cc:2:14: note:     with 'const X a'
prog.cc:2:14: note:     with 'const X b'
prog.cc:2:14: note: the required expression '(a < b)' would be ill-formed
prog.cc:2:14: note: the required expression '(a > b)' would be ill-formed
prog.cc:2:14: note: the required expression '(a <= b)' would be ill-formed
prog.cc:2:14: note: the required expression '(a >= b)' would be ill-formed
{% endhighlight %}

It does not look shorter, but the important bit is that the error message can
point you to what you need to do (ensure the type passed is
`StrictlyTotallyOrdered`, not to what the implementation happens to be.


# References

We live on shoulders of giants. For refernce see below:

Elements of Programming (book by Alexander A. Stepanov and Paul McJones)

Concepts overview (Bjarne Stroustrup)<br/>
[http://www.open-std.org/jtc1/sc22/wg21/docs/papers/2017/p0557r0.pdf](http://www.open-std.org/jtc1/sc22/wg21/docs/papers/2017/p0557r0.pdf)

Concepts proposal wording (Andrew Sutton)<br/>
[http://www.open-std.org/jtc1/sc22/wg21/docs/papers/2017/n4674.pdf](http://www.open-std.org/jtc1/sc22/wg21/docs/papers/2017/n4674.pdf)

Ranges TS (Eric Niebler, Casey Carter)<br/>
[http://www.open-std.org/jtc1/sc22/wg21/docs/papers/2017/n4671.pdf](http://www.open-std.org/jtc1/sc22/wg21/docs/papers/2017/n4671.pdf)

[n4647]: http://www.open-std.org/jtc1/sc22/wg21/docs/papers/2017/n4674.pdf

