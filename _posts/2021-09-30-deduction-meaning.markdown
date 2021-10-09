---
layout: post
title: "Deduction Theorem - Meaning"
categories: maths logic
---

A brief discussion of the meaning of the deduction theorem


{% include mathjax.html %}


# Counterpart to modus ponens

In Hilbert style propositional calculus there is just one inference rule, the
modus ponens: $$A, A \to B \vdash B$$ (also called the
implication-elimination).

The deduction theorem is the counterpart to the modus ponens: If $$\Gamma, A
\vdash B$$ then $$\Gamma \vdash A \to B$$ (also called the
implication-introduction).

The two work together to simulate the following kind of reasoning. Take
Pythagoras' theorem for example. Let $$A$$ be "The triangle ABC is a right
angled one", let $$B$$ be "The square of the side opposite the right angle is
the sum of the squares of the sides adjacent to the right angle". Pythagoras'
theorem makes the claim $$\vdash A \to B$$. The way we prove it is by taking
$$A$$ as an assumption, so then we get $$A \vdash B$$, and then we apply the
deduction theorem to get $$\vdash A \to B$$. The way we use it is via modus
ponens: we find a right angled triangle and then we say: $$A, A \to B \vdash
B$$, but $$\vdash A \to B$$ (Pythagoras' theorem), therefore $$A \vdash B$$.


# Restrictions

For the (first-order) predicate calculus the source of the additional
restrictions for the deduction theorem has it's roots in the interpretation of
formulas with free variables.

Here are two examples of formulas where $$x$$ is a free variable:
- (1) $$x + 0 = x$$. We interpret this to be true for all natural numbers. We
  call this a _generality interpretation_.
- (2) $$\lnot (x = 0)$$. We interpret this to be true for some natural numbers.
  We call this a _conditional interpretation_.

There are three issues:
- the interpretation of formulas with free variables and issues like the
  relation between the formal system and it's interpretation (e.g. soundness,
  completeness)
- the generality-introduction rule: $$A \vdash \forall x A$$
- the deduction theorem (implication-introduction): If $$\Gamma, A \vdash B$$
  then $$\Gamma \vdash A \to B$$

When setting a formal system an author has to decide how to distribute
restrictions between the above three issues, because it's not possible to meet
all of them without restrictions in predicate calculus (when formulas with free
variables occur). We can't mix and match arbitrarily results from different
formal systems without paying attention to the choice of restrictions. See
[answer by Carl Mummert](https://math.stackexchange.com/a/580692/643181) on
approaches for deduction systems for predicate calculus.
