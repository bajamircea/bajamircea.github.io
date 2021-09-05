---
layout: post
title: "Deduction Theorem - Mathematical logic"
categories: maths logic
---

Basic introduction to how formal systems in mathematical logic came to be a
thing

{% include mathjax.html %}


We make a claim for an idea in the form of a sentence. We'd like to ensure it's
a correct sentence. We might have reached a correct sentence directly, by
accident, but usually we make a argument as a chain of smaller arguments to
prove that a sentence is correct. Each link in the chain starts with some
hypothesis and ends with a conclusion.

Logic concerns with the rules for makings such arguments, based on the
observation that the rules can be separated from the particular content of the
sentences. One such rule is that if the chain of arguments cannot be circular,
because then we already assume as a hypothesis the thing to be proven.

This pattern of logical arguments is what underlines mathematical proofs with
one tweak: the assumptions don't go deeper and deeper forever, instead they
start with certain assumptions called axioms.

This goes at least as far as Euclid's Elements in the 4th century BC. "A
straight line segment can be extended arbitrarily at both ends" is a sample
axiom and based on such axioms one can prove that "the sum of angles in a
triangle equals to a straight angle (180 degrees)". The axioms were not
proved, though they were assumed to be true. The reasoning of the axioms was
informal i.e. using arbitrary words.

It took a long time to have a major change to this approach (more than 2000
years).

First there was the discovery of non-euclidean geometries starting in about the
17th century. One can have a geometry without the axiom above; in one such
geometry, elliptic geometry, the sum of angles in a triangle is more than 180
degrees. So Euclid's axioms lost the meaning of absolute truth, they are mere
assumptions that single out a certain kind of geometrical space.

Another event was the discovery of paradoxes that questioned the strength of
informal proofs.

To address this, around 1900s, one idea was to develop a more systematic
approach for proofs. There were many approaches, but one common idea is on the
following lines.

Let's focus on the natural numbers: 0, 1, 2, 3, and so on, with the common
operations of addition and multiplication. They are quite fundamental in
mathematics: e.g. even in geometry a triangle is a polygon with 3 corners.

Let's:
- start with symbols like "$$0$$", "$$+$$", "$$=$$' etc.
- define meaningful sentences e.g. "$$0 = 0 + 0$$" (but not "$$+ 0 =$$")
- choose some sentences as axiom
- state explicitly the rules of deriving new sentences
- poofs are nothing but chains of such derivations

Then wouldn't it be nice if the rules were such that the proofs could be
checked mechanically? Then hopefully we can avoid the paradoxes and all will be
good, mathematics will be on solid foundations. And that's important because
mathematics is itself the foundation of so much science and knowledge.

This describes the motivation and the approach for a formal system for number
theory, an example of such system will be described in the next article.
