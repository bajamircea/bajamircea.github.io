---
layout: post
title: 'Unordered hash conundrum'
categories: coding cpp
---

If you expected to use the`std::tie` trick to also implement the hash so that
your type can be a key in a std unordered container ... you'll be disappointed.
And here is why.


# Tuples don't have a standard hash

In the code below the `person` is a user defined type that groups several
member variables.

{% highlight c++ linenos %}
struct person {
  std::string first_name;
  std::string last_name;
};
{% endhighlight %}

If you want to use the class above as a key in an unordered container e.g.
`unordered_set` or `unordered_map` you need to implement a hash for the class.

First you'll be disappointed that the hash must be a specialization of
`std::hash` in the `std` namespace not in the namespace of `person`.

Once you get over that, you might think you can delegate it to the `std::tuple`
hash using something on the lines of the `std::tie` [trick][tie-cpp].

That is not the case, currently `std::tuple` does not have a hash.


# You have been warned!

The beautifully written proposal (by Matthew Austern) [N1456 to standardise
hash tables][n1456] warned about the specialization in the `std` namespace:

> Trivial as it may seem, hash function packaging may be the most contentious
> part of this proposal.

It also suggested addressing the issue of combining hashes for fields (note
that `std::tuple` was not in the standard at the time of the N1456 proposal):

> Should we define a general hash combiner, that takes two hash codes and gives
> a hash code for the combination? Should we define a default hash function for
> std::pair<T,U>?


# Why the current state of affairs?

The reality is that the current unordered containers in C++ are basically the
hash containers designed in mid 90s in STL, resurrected for C++11. As programmers
start to use them they have different (incompatible) expectations.

Some expect it to be a simple to use container, they expect the `tuple` to have
a hash defined by default, and a simple function to combine hashes.

Others use it places where collisions in hashes expose systems to denial of
service (DOS) attacks, and would like very good hashes e.g. of cryptographic
hash strength and/or with a random seed mechanism. In those scenarios simple
methods of combining like hashing the hash of members in a tuple are not good
enough. There is the question of who should provide the hash functions: the
standard library or it's users, and how easy would be to update it as
issues/vulnerabilities are found.

Yet others are using it in distributed environments where they would like
guarantees that the hash for a value is identical on different systems.


# What to do then?

The first thing to remember is that the default container should be
`std::vector`. If data is available upfront, for a simple sorted vector the
cost of each lookup is `O(log(n))`, but locality of data means that the
constant is small.

The unordered containers were designed for special cases. For example where the
data is not all available upfront. The lookup is usually `O(1)`, but because of
the memory jumps to reach the nodes the constant is not small, and the lookup
could degrade to `O(N)`. If data is not available upfront then one could use
the [boost functions][boost-hash] to combine hashes, assuming it's not for
scenarios where an attacker can exploit it for DOS attacks.

An alternative is to use a key for which a hash is already defined (e.g.
built-in type or `std::string`). My guess is that most of the users of
unordered containers do just this.

For serious usages consider creating your own container.

# References

- The proposal to add unordered containers in the C++11 standard: [N1456][n1456]
- Attempts to address hash issues for unordered containers:
  - <http://www.open-std.org/jtc1/sc22/wg21/docs/papers/2012/n3333.html>
  - <http://www.open-std.org/jtc1/sc22/wg21/docs/papers/2014/n3980.html>
  - <http://www.open-std.org/jtc1/sc22/wg21/docs/papers/2014/n3876.pdf>
  - <http://www.open-std.org/jtc1/sc22/wg21/docs/papers/2014/n3983.pdf>
  - <http://www.open-std.org/jtc1/sc22/wg21/docs/papers/2015/n4449.html>
  - <http://www.open-std.org/jtc1/sc22/wg21/docs/papers/2015/p0029r0.html>
  - <http://www.open-std.org/jtc1/sc22/wg21/docs/papers/2016/p0199r0.pdf>
  - <http://www.open-std.org/jtc1/sc22/wg21/docs/papers/2016/p0513r0.pdf>
  - <http://www.open-std.org/jtc1/sc22/wg21/docs/papers/2017/p0549r0.pdf>
- For an insight into the motivation between hash proposals see the post by
  Jonathan Wakely, Jason Merrill, and Matt Newsome [reporting on the
  Repperswill meeting in 2014][rap2014]: 

> There was a lot of discussion in LEWG about how to improve support for
> hashing. One approach, proposed in N3980 “Types don’t know #”, is to provide
> a generic framework for hashing arbitrary types using arbitrary hash
> algorithms, so that users don’t need to decide on a single hash function for
> their types but instead can define how their types expose their contents to
> any hash function that asks for them. This allows the choice of hash function
> for any part of a program to vary independently to the choices of data type
> and the definition of those types. This had a lot of support from many people
> as an elegant and extensible solution, but Google in particular are opposed
> to making it easy for users to swap in and out different hash functions in
> this way, as they believe it will lead to poor quality hash functions being
> used in ways that are hard to fix at a later date. Google’s preference is to
> rely on a single hash function throughout the program (by using the std::hash
> template).  This means the compiler implementation can ensure it chooses a
> well-known, strong hash function for std::hash which has been studied and
> vetted by experts, and if weaknesses are found in that function then the
> standard library can switch to a different implementation of std::hash,
> requiring changes in only one place and fixing all the code that uses it. Due
> to this, Google are keen to make it easier to use std::hash for user-defined
> types, rather than making it easier to use any arbitrary hash function, and
> that’s what their proposal, N3983 “Hashing tuple-like types” tries to do.
> Both proposals were well-received by the LEWG, but it’s not clear whether we
> want to take two overlapping, and somewhat contradictory, approaches to
> hashing. Until something is done we have the worst of both worlds, in that
> users have no choice but to create their own poor quality hash values for
> their types, because we don’t offer them any way to do it better.

[tie-cpp]:    {% post_url 2017-03-10-std-tie %}
[n1456]: http://www.open-std.org/jtc1/sc22/wg21/docs/papers/2003/n1456.html
[rap2014]: https://developers.redhat.com/blog/2014/08/21/iso-cxx-meeting-rapperswil-2014-core-library/
[boost-hash]: http://www.boost.org/doc/libs/1_63_0/doc/html/hash/reference.html

