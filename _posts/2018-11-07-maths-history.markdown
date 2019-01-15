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

Euclid marked an apex of logic that was not matched until around the 19th
century. Until most of the contents of the Elements became part of the standard
maths eduction in the 20th century, reading Euclid's Elements was The Thing
that every truly educated man was supposed to know.


# The Greek legacy

From the ancient Greeks we got a lot of inconsistent, invalid, confused text.
But we got Euclid. And other than Euclid there are still plenty of gems.

**Zeno** is famous for his paradoxes such as Achilles and the tortoise:

> Achilles will never reach the tortoise as by the time Achiles reaches the
> place where the tortoise has been, the tortoise has already moved away.

On the surface, it seems nonsense for which the calculus seems to offer an
explanation with regards to adding infinite sums of ever smaller quantities.
But I think Zeno's paradoxes are deeper than that. For example the paradox
above suggests that maybe modelling the word using Euclidean geometry does not
work at tiny scales. We really can't just divide a line in smaller and smaller
parts forever.


**Diophantus** (around 300 AD) left Arithmetica, a collection of problems.

One such problem states that a person had a was a boy for a sixth of his life,
a twelve more till his beard started to grow, and so on, asking for the age of
a person.

This kind of problems look like equations for which the solution must be an
integer, the age of the person in years for the problem above, or rational
numbers.

Each problem had a unique way of being solved. Solving 100 of such problems
give little insight on how to solve the 101th. However this book will inspire
the development of algebra.


# al-Khwarizmi - the Arabs

Unlike the Romans, which, when encountering the Euclid's Elements did not
preserve or care much about the proofs, the Arabs, when encountering the Greek
culture, preserved and studied as much as they could get their hands on.

Through the Arabs, around the 12th century AD, the Europeans rediscovered the
Greeks, got the Arabic numerals and the idea of zero, originating from India,
and also additions such as algebra.


# Peano - Formalization

As mathematics started to flourish again in Europe following the rediscovery of
Greeks, it generally still suffered by poor notation and lack of logical
rigour.

This changed in the 19th century, when mathematicians started to work on formal
systems.

Peano's axioms are an example of such formalization efforts, introducing
notation that formalizes integer arithmetic axioms in a familiar form on the
lines of:

$$
\begin{align}
  &\forall x\in\mathbb{N}~(0 \neq S(x))\\
  &\forall x, y\in\mathbb{N}~((S(x) = S(y) \Rightarrow x = y)\\
  &\forall x\in\mathbb{N}~(x + 0 = x)\\
  &\forall x, y\in\mathbb{N}~(x + S(y) = S(x + y))\\
  &\forall x\in\mathbb{N}~(x \times 0 = 0)\\
  &\forall x, y\in\mathbb{N}~(x \times S(y) = x \times y + x)\\
  &\forall \bar{y}(\varphi(0, \bar{y}) \land \forall x(\varphi(x,\bar{y})
  \Rightarrow \varphi(S(x),\bar{y})) \Rightarrow \forall x~\varphi(x,\bar{y})
\end{align}
$$

The axioms above define the natural numbers in terms of rules with regards to a
successor function $$S$$. For example the first one states that zero is not a
successor for any other natural number. The last one is the induction rule,
$$\bar{y}$$ stands for $$y_1,\dots,y_k$$ :if
some formula is true for 0, and if true for x is true for the successor of x,
then it's true for all natural numbers.

In general, a formal system would use symbols like $$\forall$$, $$($$, $$x$$
etc. and build sentences. There is a grammar as to what a valid sentence is.
e.g. $$($$ is not valid because for example it does not have a closing
parenthesis. Some sentences are given as axioms. And then there are rules on
how to build further sentences.

Around the end of the 19th century, a number of such formal systems were
developed.


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
