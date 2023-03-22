---
layout: post
title: 'Regular: syntax and semantics'
categories: coding cpp
---

What are the characteristics of a normal, regular data type?

This article is part of a series on [the history of regular data type in
C++][regular-intro].


# Syntax vs. semantics

At this point we're going to look at the characteristics that we require from a
regular data type even if we're going to refer to ideas that we're going to
cover soon such as concepts and the spaceship operator.

The requirements will be split into syntactic and semantic. The syntactic
requirements are those that can be checked by the compiler (e.g. the type has a
move assignment which is marked `noexcept`). The semantic requirements are
the remaining ones, they provide **meaning**.

An example of a syntactic requirement is that for a type `T` the following
compiles: `T a; T b = a;`.

The difference between syntactic and semantic requirements is somewhat
arbitrary. Over time the compilers can perform more checks or assumes meaning
for operations e.g. some optimisations (such as return value optimisation)
assume that copy and move mean copy and move and can be elided. Interestingly
for comparisons `==` and `<` this is made harder because, as we'll see,
historically and also when the spaceship `<=>` operator was introduced, people
sometimes use `==` and `<` for weaker relations than equality or "less than".

## Semantics of a regular type

- It's a data class.
- You can create an instance of that class
- You can destroy an instance of that class
- It does not leak resources, it does not leak memory in particular, that's the
  only kind of resource you would expect such a type to acquire, the destructor
  in particular takes care of releasing the resources
- You can take a copy (either by assignment or construction)
- You can move it (also either by assignment or construction)
- Move is an optimised version of copy for when the original is no longer
  needed
- "moved from" can at least be destroyed and assigned
- You can test two instances for equality `==`
- It does not matter how we compare for equality: `!=` is not equal, the
  opposite of equal
- Equality behaves properly: reflexive, symmetric, transitive, substitutable
- A copy is equal to the original
- You can compare two instances for order
- It does not matter how we compare for order: can use either of `<`, `>`,
  `<=`, `>=`, `<=>`. E.g. `a < b` is the same as `b > a`
- Less than `<` behaves properly, it is strict total order: irreflexive,
  asymmetric, transitive. Similarly the other order functions.
- Equality works properly with order. Trichotomy: either `a < b` or `a == b` or
  `b < a`
- Equality and comparison do not change the arguments, copy does not change the
  source.
- Of all the functions above, only copy might throw (because it might need to
  allocate memory)
- The functions above have reasonable complexity of operations: constant or at
  most linear with the amount of data held
- Independence: changing one value does not change other unrelated values


## Syntax requirements of a regular type

Syntactic requirements are those that a compiler should be able to check.
E.g. given `const T a, b` then `a == b` should compile (and return something
that looks like a `bool`, ideally a `bool`).

A regular type should have:
- Default constructor (`noexcept`)
- Destructor (implicitly `noexcept`)
- Copy constructor and assignment
- Move constructor and assignment (`noexcept`)
- Equality: `==` and `!=` (`noexcept` and `const`)
- Order: `<`, `>`, `<=`, `>=`, `<=>` (`noexcept` and `const`)


# Regular functions

Regular functions are functions that:
- Take regular types as parameters
- Return a regular type
- Called again with equal inputs return equal values

These are as close as it gets to mathematical functions. Usually they perform
pure calculations, but also a function like `base64encode` will qualify even if
it calls functions provided by the OS cryptography library.

If we look at a simple function like `add`
{% highlight c++ linenos %}
int add(int x, int y) {
  return x + y;
}
{% endhighlight %}
it is a regular function, but the domain of the function is not `int X int`,
but only the subset of those values that do not overflow.

Regular types go hand in hand with regular functions. In particular we expect
that functions that implement comparison for equality and order for regular
types are themselves regular functions.


# Comments

Regularity as I've described here is a concept, a strong version of the
possible views on regularity. In the next article we'll look at a history of
concepts in C++.


[regular-intro]:    {% post_url 2022-11-16-regular-history %}

