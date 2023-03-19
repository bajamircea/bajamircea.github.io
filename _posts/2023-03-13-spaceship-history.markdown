---
layout: post
title: 'History of the spaceship operator in C++'
categories: coding cpp
---

How the three-way comparison, aka. the spaceship operator came to be in C++

This article is part of a series on [the history of regular data type in
C++][regular-intro].


In 2016 the situation was that support for comparison operators required a lot
of repetitive manual programming effort. This was about to change with the
publication of the paper [Comparison in C++][cpp-comparison] by Lawrence Crowl
that was a detailed description of the many relations encountered for different
types, including the problems with `float` types. Soon after, in early 2017
Herb Sutter published the paper where he introduced publicly the spaceship
operator for the first time [Consistent comparison][spaceship-first].

Herb Sutter's proposal is around a three-way operator `<=>`. This would be new
for C++, but other programming languages used it for similar purposes.
Three-way means practically that the operator returns `0` when the two
arguments are equal, and negative or positive depending on which of the
arguments is smaller or larger.

It's often called the spaceship operator because it kind of looks like a ASCII
representation of a spaceship from Star Wars, though Star Wars ASCII experts
have better representations in their opinion such as `>=<`, `|=|` or even `|-o-|`.

Many elements of the elements of the proposal pose no philosophical problems.

Three-way comparison has a long history, we've seen the `memcmp` being one of
the fundamental C functions around `struct` regularity, that did not have
direct language support in C++ like copy had.

It supports `= default` to request the compiler to generate memberwise
implementation, i.e. implement it based on the base class(es) and member(s)
implementation, which is what users want most of the time for composite types
e.g. when they aggregate several data members in a data `struct`.

It does not insist on implementing it by default, which is not surprising,
someone would object based on legacy code.

It simplifies support for symmetric heterogeneous comparisons. E.g. an example
of a heterogeneous comparison is comparing a `std::string` with a literal
string. The issue is that often the user would compare them in any order e.g.
`some_string_variable == "some value"` or `"some value" ==
some_string_variable`. Traditionally that required the implementer to provide
overloads with the compared types in both acceptable orders. The paper suggests
that one single comparison function should be enough, the compiler if free to
use it with the order of arguments switched.

But one issue in the proposal is philosophically debatable. Herb's proposal
embraces Lawrence's Crowl description of many relations and comes with a
hierarchy of comparison strengths all supported by basically the same
operators, creating a hierarchy roughly described in the digram below.

{% highlight text %}
                <- partial_ordering
 weak_equality           ^
                <-  weak_ordering
       ^                 ^
strong_equality <- strong_ordering
{% endhighlight %}

The mechanism to describe the strength of the comparison is ingenious, it
involves the return value, instead of being literally `-1`, `0` or `+1`, being
instead one of the types in the diagram with carefully crafted conversions from
one type to another. When I said that predicates return a boolean or at least
"something that looks like a boolean", these types are an example of "something
that looks like a `-1`, `0` or `1` three-valued type".

The philosophical problem with this approach is that really, only the bottom
line makes sense. `strong_ordering` means "proper less than" and
`string_equality` means "proper equality".

Now, there is a long tradition for the confusion that goes all the way to
Euclid where in his Elements equality for triangles means congruence, which is
proper equality (not identical, but otherwise equal in shape), but for
parallelograms he uses the word equality to mean equality of areas.

The problem with allowing the same operators to mean different things creates
problems with composite types: the strength degrades to the lower denominator,
and really who can explain in a rush the difference between strong and weak
ordering? The better approach is to use methods like `is_equivalent` or
`preceeds` and use those to customize algorithms for the type.

Another particular technical issue is that in terms of the computation
efficiency, `==` can often be implemented faster than checking if `<=>` returns
`0`. Concretely that's because when comparing two containers e.g. `std::vector`
or `std::string`, if the their size is different they are not equal and that's
all we need to do. Academically put: not equal does not need to determine in
which particular way two values are not equal i.e. which of them is bigger.
That drove [changes to the proposal][remove-eq] that removed `strong_equality`
and `weak_equality`.

So there were 5, now there are three. Of the three the `partial_ordering` is
also suspicious. Example of partial orders are nodes in a directed acyclic
graph, and an example of sort based on the partial order is a topological sort.
The proposal gives an example of this sort using a `PersonInAFamilyTree`. But
efficient topological sorts will use traversals over the children of such a
person, rather than functions like `is_transitive_child_of` as in the paper
example.

Oh well, so here we are. Basically that means:
- if you use `float` types, commiserations, you have to be very careful
- else, for data types use proper less than (`std::strong_ordering`)

# References

Lawrence Crowl: Comparison in C++, 2016 [P0100R2][cpp-comparison]

Herb Sutter: Consistent comparison, 2017 [P0515R0][spaceship-first]

Barry Revzin: Remove std::weak_equality and std::strong_equality, 2019
[P1959R0][remove-eq]

[regular-intro]:    {% post_url 2022-11-16-regular-history %}
[cpp-comparison]:   https://www.open-std.org/jtc1/sc22/wg21/docs/papers/2016/p0100r2.html
[spaceship-first]:  https://www.open-std.org/JTC1/SC22/WG21/docs/papers/2017/p0515r0.pdf
[remove-eq]:        https://www.open-std.org/jtc1/sc22/wg21/docs/papers/2019/p1959r0.html

