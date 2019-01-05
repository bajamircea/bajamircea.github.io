---
layout: post
title: "Mathematics History"
categories: maths history
---

Very short mathematics history

**TODO: this is work in progress**

{% include mathjax.html %}

# Babylonians - the Early Mathematics

Babylonians used natural numbers and fractions, albeit usually in a base 60
numeral system. It is possible to count to 12 on one hand, using the thumb to
point to one of the three finger bones in the remaining 4 fingers, and to 60
using two hands.

The advantage of base 60 and of 12 is that they have many factors, making
common fractions (e.g. half, third, quarter), therefore division, easy. That's
important because division is an order of complexity compared with
multiplication, which itself is an order more complex than addition and
subtraction.

Left overs to this date are the fact we still use 60 seconds to the minute, 60
minutes to the hour, eggs are sold to the dozen, full rotation is 360 degrees,
etc.


# Pythagoras - the Greek Breakthrough

<div align="center">
{% include assets/2018-11-07-maths-history/01-three_four_five.svg %}
</div>

Triplets such as $$(3, 4, 5)$$, $$(5, 12, 13)$$, $$(6, 8, 10)$$, $$(7, 24,
25)$$ [have been known][plimpton] since about 2000 BC by the Egyptians and
Babylonians, first on the basis of 'here are some values that have a certain
property', later as a rule, introduced to the Greeks by Pythagoras (around 500
BC) as:

> In a right-angled triangle the square of the side opposite the right angle
> equals the sum of the squares of the other two sides

It is believed that one of the initial proves of the rule involved sliding
around same sized right angled triangles inside a square:

<div align="center">
{% include assets/2018-11-07-maths-history/03-pythagoras.svg %}
</div>

For a while it looked like there is a beautiful link between numbers and
geometry.

By numbers they meant strictly positive integers and rational numbers (i.e.
ratios). However it soon become evident that they are not enough to reflect
sizes in geometry. The diagonal of a square, does not have a common unit with
the side of the square. In modern language we would say that they discovered
that $$\sqrt{2}$$ is irrational, i.e. that it has an infinite number of
decimals.

<div align="center">
{% include assets/2018-11-07-maths-history/02-square-2.svg %}
</div>

The links between geometry, numbers and infinity, is a theme that runs deep
throughout the mathematics history.


# Euclid - the Greek Apex

Proposition 47. Mathematics flourished in the ancient Greek culture, and in
Euclid's Elements (13 books) it reached it's peak. The Pythagorean theorem is
captured in Euclid's Elements in Book I Proposition 47.

<div align="center">
{% include assets/2018-11-07-maths-history/04-euclid.svg %}
</div>

Proposition 47 uses Proposition 46 and not the other way around, because of the
underlying belief that proofs must not be circular, and so on until axioms and
definitions, reflecting the underlying belief that proofs will not go on
forever, instead will reach statements taken for granted.

Some axioms in Book I, are geometry specific, but some, the Greeks believed,
are of wider generality, such as:

> If two things are equal to another, they are equal between themselves.

For example, the attention given to definitions is amazing.

They made the observation that to the learner, the natural way of
perceiving is solid objects, surfaces are boundaries of solid objects, lines
are intersections of surfaces, points are intersections of lines. However
points, lines, surfaces are more primitive than solid objects, and the logical
presentations should start with them.

Hence the first definition is that:

> A **point** is that which has no part.

They questioned if it's appropriate to give definitions in the negative. In
general that would be a poor choice, but it's appropriate here because the
point is the only one, in geometry, meeting the criteria of having no part.

Another example is the definition of a square:

Definitions beside being a label, could wrongly imply that the thing defined
exists. The square for example, defined at the beginning to Book I, is not used
until it is proved that it can be constructed, in Proposition 46.

And if a proposition asks for a construction, the solution ends in QEF, "quod
erat faciendum", while if the proposition requires a proof, then then the
solution ends in QED, "quod erat demonstrandum".

# The Greek legacy

Zeno is famous for his paradoxes such as Achilles and the tortoise:

> Achilles will never reach the tortoise as by the time Achiles reaches the
> place where the tortoise has been, the tortoise has already moved away.


Diophantus (around 300 AD) left Arithmetica, a collection of problems where the
solutions are integers (or rationals). Each problem had a unique way of being
solved. However this book will inspire the development of algebra.


# al-Khwarizmi - the Arabs

# Euler - the Infinite Series

# Peano - Formalization

# Cantor - Counting

# David Hilbert - We will know

# Bertrand Russell - Principia Mathematica

# Kurt Gödel - the Limits

Why things aren't as simple as they seem.

# Turing, Alonzo Church - the Computers Link

# References

- [Alexander Stepanov | Greatest Common Measure: The Last 2500 Years | @
  SmartFriends U, September 27, 2003][as-gcd]
- Euclid The Thirteen Books of the Elements - translated and commentary by Sir Thomas L. Heath
- Charles Petzold: The Annotated Turing
- [Plimpton 322 tablets][plimpton]

[as-gcd]: https://www.youtube.com/watch?v=fanm5y00joc
[plimpton]: https://en.wikipedia.org/wiki/Plimpton_322
