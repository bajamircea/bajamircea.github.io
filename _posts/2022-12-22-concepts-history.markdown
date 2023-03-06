---
layout: post
title: 'History of concepts in C++'
categories: coding cpp
---

A brief history of concepts in C++

This article is part of a series on [the history of regular data type in
C++][regular-intro].


# Pre C++ 11

Concepts in C++ are closely related to support for generic solutions.

The idea that some C++ types have shared characteristics occurs arguably
accidentally first in C where you have:
- numeric types such as `int` and `float`: they all have sum, product etc.
- of which some are:
  - real number approximations such as `float` and `double`
  - or integers such as `int` and `unsigned int`: they also can bit shifted
    - which can be signed as `short`, `int` and `long`
    - or unsigned

But the deliberate investigation of such common characteristics comes from Alex
Stepanov and his collaborators in the search of defining generic algorithms.
Such investigation used initially some academic languages, followed by Ada,
followed by an attempt in C++ when he joined Bell Laboratories in late 80s.

C++ at that point did not have templates, Bjarne Stroustroup prioritised the
work on vtable based inheritance, for a while he thought macros are enough for
generic containers. However that state of affairs was not optimal. Vtable based
inheritance suffers from the issue.  Consider `apple` and `orange` derived from
`fruit` and equality is part of the `fruit` interface, it provides `fruit`s
when the intended behaviour is to compare `apple` with `apple` and `orange`
with `orange`. Also macros work for small teams, but do not scale.

So Bjarne Stroustroup added templates to C++. And although they are kind of
similar to macros (they share some of the cryptic error messages), templates are
also different and they scale for larger development teams and code bases (they
have more compiler mechanics compared with macros).

With templates now in C++, Alex Stepanov develops STL (the Standard Template
Library) with containers like `vector`, `list`, `map` and algorithms like
`sort`, `binary_search`, `rotate`. Around that time the C++ community is
looking for a container library. Containers in STL did not look like what
people expected at the time, they expected inheritance from vtable interfaces,
but the likes of Bjarne looked at STL containers and thought that it's a far
better container library than what they've seen before. With the encouragement
of the likes of Andrew Koenig, Alex Stepanov prepared and proposed large parts
of STL for inclusion in the C++ standard. And most of the people thought they
now have a container library with some algorithms, while Alex Stepanov thought
he had an algorithm library with some containers.

But other than the algorithms and containers it had documentation. And the
documentation specified requirements on the types used with the generic
library.

For example many algorithms accepted iterators and you understood that the
iterator type has to implement `operator++` to advance to the next value in the
sequence and `opetator*` to dereference the value (syntax requirements), that
sometimes there was a hierarchy (e.g. random access iterators were also
bidirectional iterators), and that forward in input iterators were different
not in syntax, but in guarantees of being able to access a previous value in
the sequence after advancing to the next value (semantic requirements).

Should you give a unsuitable type (syntactically), the compiler would usually
throw at you a long, often cryptic, list of error messages.

# C++ 11

C++ 11 was formerly called C++0x because it was expected to be published before
2010.

Significant effort was put into adding concept representation in the language.
From what I could figure out there were two different proposals from two
groups, the groups eventually worked together, and concepts were added to the
standard. There were complexities in the proposal, such as the idea of mapping,
e.g. a iterator type might not implement `operator++`, but instead have a
function `next()`, mapping allows capturing concepts regardless of such
syntactic differences.

But the realisation came that the solution incorporated in the standard is not
suitable long term, so it was taken out of the standard and that was one of the
reasons for the delay in the C++ 11 publication.

# Post C++ 11 to C++20

The committee's trust on concept implementation dropped as a result of the
C++ 11 experience, so they demanded to see how proposed solutions would apply
to the standard library. The first attempts struggled with what it looked like
there would be as many concepts as algorithm functions in the standard library.

In the end Alex Stepanov was briefly involved and Bjarne Stroustrup lobbied
what became the C++20 concepts, among other things convincing that it's all
right to have pretty syntax (compared with the historical case of templates
where complex syntax was apparently required to ensure distinction from
"normal").

Very high level what we got is the following.

A keyword `requires` can group syntactic requirements. It can be used where
templates (e.g. function or class templates) are declared. The requirements
take pretty much the same kind of parameters as templates: usually types, can
take more than one type, but also non-type parameters such as an `int` value.
It can be used to do syntax checks on such (usually) types.

A keyword `concepts` allows combining such requirements using AND and OR
logical operators and giving them a name. The name allows for several forms of
nicer usages for simpler cases.

Both effectively provide a `bool` which is true it the checks pass. E.g. it
can provide info if a matrix type, a scalar type, `0` and `1` can be used
together to multiply the matrix by the scalar and obtain a matrix, to build the
scalar type from `0` or `1` etc. Therefore the compiler can check if the
constraints are satisfied and either ignore a candidate that does not meet the
constraints or give an error. The selection mechanism is more convenient than
alternatives e.g. `std::enable_if`. This helped with the `std::ranges` library.
The errors are not necessarily shorter.

Some concepts were added to the language, though note that `std::regular` is
weaker than the definition I gave in the previous article: it does not require
order.


# References

[Al Stevens Interviews Alex Stepanov][interview] (Dr. Dobb's Journal March 1995 issue)

[regular-intro]:    {% post_url 2022-11-16-regular-history %}
[interview]: https://www.boost.org/sgi/stl/drdobbs-interview.html
