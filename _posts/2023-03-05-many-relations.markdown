---
layout: post
title: 'The many relations'
categories: coding cpp
---

Let's get better at understanding relations (and I don't mean the
inter-personal ones) and they translate from mathematics to programming (C++ in
particular).

This article is part of a series on [the history of regular data type in
C++][regular-intro].


# Why?

An example of a predicate is the situation when we do `a < b`. We give two
values and we get a boolean that tells us if `a` is less than `b` or not. We
say that we deal with the "less than" predicate.  Predicates are useful as
customization points in generic algorithms, such as when we want to sort
descending instead of ascending we can customize the sort algorithm with the
"greater than" predicate instead of the default "less than" predicate.


# Mathematics roots

This terminology is borrowed from mathematics. There we start with sets e.g.
`A`, `B`, `C` etc. Then we have sets of **tuples** e.g. the set `{(a, b, c) | a in
A, b in B and c in C}` written as `A x B x C` (the Cartesian product of the
sets, in particular the case of **pairs**, e.g. `A x B`.

There is a duality between a subset of a Cartesian product and a function that
maps a tuple to two values that can be used to establish if the tuple is a
member of the subset. E.g. `true` means that the tuple is member if the subset,
`false` otherwise, or sometimes `1` and `0` are used instead. Such a subset or
the associated function is called a **relation**, often the associated function
returning a boolean (or similar) is called a **predicate**. This approach to
relations is a generalized and somewhat non-intuitive approach compared with
how we started, where `a < b` seemed something between `a` and `b`, rather than
a subset or a kind of function.

When the associated function is defined for the whole Cartesian product the
relation is **total**, otherwise it is **partial**. The meaning of the word
**domain** of the relation is overloaded: sometimes it's the whole Cartesian
product, sometimes just the subset for which the relation function is defined
(the domain of definition). For a partial relation sometimes you have a total
relation that indicates if the partial one is defined. E.g. "is divisible by"
does not make sense if the divisor is `0`, but you can have a total relation
"is in domain of divisible by" which checks if the divisor is `0` and returns
`false` in that case (note that this check requires additional computation).

When the sets in the Cartesian product are the same e.g. `A x A x A` the
relation is **homogeneous**. In this case the domain word is further
overloaded: it sometimes refers just to the set `A` rather than the Cartesian
product. A relation that is not homogeneous is called **heterogeneous**.


# The zoo of relations

This general framework leads to a whole zoo of relations. But some are more
special than others. Unary and binary predicates occur more often than other
predicates. Homogeneous predicates are more common in usage than heterogeneous.

In particular equality is special. It is related to copy: when you take a copy
you expect it to be equal to the original. It is a special case of an
equivalence relation. Equivalence relations are reflexive, symmetric and
transitive.  Equality is the strictest equivalence relation short of identity.
Identity means "is the same object", usually checked by testing the addresses
of the objects involved for equality.

"Less than" is also special. It is related to equality via the trichotomy rule:
given two values, one is less than the other or the values are equal. "Less
than" is a special case of order relations: it is strict.

Order usually refers to any of the "less than", "greater than", "less than or
equal", "greater than or equal". Comparison refers to order or equality
relations.

Sometimes terminology strong and weak is used e.g. strong equality is normal
equality, while weak equality is equivalence, similar strong order is provided
by the normal "less than" relation, while weak order has the trichotomy
relation with an equivalence relation.


# Language representation

In a language like C++ predicates are represented as functions taking two
parameters with the return value either `bool` or at least something that can
be evaluated the same way as a `bool` can.

The predicate function would be a regular function: called repeatedly with
equal inputs it returns the same result.

This function can be either:
- a plain function
- a member function taking one explicit parameter (the other parameter comes
  via the `this` pointer)
- a special function like `operator<` (either as a member function or as a pain
  standalone function)
- a function object (that has a `operator()`)
- an `std::function`
- a lambda
- etc.

For identity we usually check equality of addresses. E.g. in the move
assignment a check `if (this != &other)` handles the case where an attempt is
made to move an object into itself: is it the same object?  (Note that it's
debatable if/why such a check is/should be required).

For equality the sane approach is to use `==` and `!=` and make sure they work
properly, including one being the opposite of the other, and together with
copy. For "less than" the sane approach is to use `<` and make sure it works
properly with the other operators like `<=`, `>`, `>=` and with equality.

Examples of heterogeneous binary predicates are those comparing `std::string`
with literal strings or `std::string_view`, or testing equality of an iterator
with the associated sentinel type in the `std::ranges` library.

Even if heterogeneous, binary predicates usually are happy to take the two
different types in any order: we're as likely to compare a `std::string` with a
literal string as to compare a literal string with a `std::string`. In some
cases that's not the case, such as a predicate that indicates if path is a
child of another (e.g. to implement some scanning exclusion).


# The weird case of float

Why would you not make the sane choices? Here the example of `float`. It is
largely governed by an external spec IEEE-754, where sane choices were not
made (though with good intentions probably). Here are two examples.

## The case of NaN

There are multiple values that usually result from computation errors, such as
divide by `0`, they are generally referred as `NaN` (i.e. Not A Number). The
rules of comparing against a `NaN` are not sane mathematically: e.g. they don't
respect properties such as trichotomy. One approach is to say that float
comparisons are partial, not total, that `NaN` values are not in the domain of
comparisons, though realistically the chance of enforcing that in a large
program are slim.

## The case of -0.0 and +0.0

These two values compare equal using the `==` operator, but they are different,
so in fact operator `==` captures a equivalence relation, not equality.


[regular-intro]:    {% post_url 2022-11-16-regular-history %}
