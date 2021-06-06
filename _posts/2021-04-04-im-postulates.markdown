---
layout: post
title: "Choice of postulates in IM"
categories: review book
---

The choice of postulates in Stephen Cole Kleene's Introduction to Metamathematics

{% include mathjax.html %}

The book introduces a list of postulates for a family of formal systems without
a direct explanation on numbering scheme and the reasons behind that particular
choice. These are my notes on the subject.


# Postulates

There are three groups of axioms (p82), that can be used to build a variety of
formal systems, mainly in an additive fashion (e.g. group A1 and A2 for
predicate calculus).

<table>
<tr>
  <th colspan="4">Group A1. Postulates for the propositional calculus</th>
</tr>
<tr>
  <td>$$1a.$$</td>
  <td>$$A \to (B \to A)$$</td>
  <td rowspan="2">$$2.$$</td>
  <td rowspan="2">$${A, A \to B \over B}$$</td>
</tr>
<tr>
  <td>$$1b.$$</td>
  <td>$$(A \to B) \to ((A \to (B \to C)) \to (A \to C))$$</td>
</tr>
<tr>
  <td rowspan="2">$$3.$$</td>
  <td rowspan="2">$$A \to (B \to A \& B)$$</td>
  <td>$$4a.$$</td>
  <td>$$A \& B \to A$$</td>
</tr>
<tr>
  <td>$$4b.$$</td>
  <td>$$A \& B \to B$$</td>
</tr>
<tr>
  <td>$$5a.$$</td>
  <td>$$A \to A \lor B$$</td>
  <td rowspan="2">$$6.$$</td>
  <td rowspan="2">$$(A \to C) \to ((B \to C)\\ \to (A \lor B \to C))$$</td>
</tr>
<tr>
  <td>$$5b.$$</td>
  <td>$$B \to A \lor B$$</td>
</tr>
<tr>
  <td>$$7.$$</td>
  <td>$$(A \to B) \to ((A \to \lnot B) \to \lnot A)$$</td>
  <td>$$8^\circ.$$</td>
  <td>$$\lnot \lnot A \to A$$</td>
</tr>
<tr>
  <th colspan="4">Group A2. Additional postulates for the predicate calculus</th>
</tr>
<tr>
  <td>$$9.$$</td>
  <td>$${C \to A(x) \over C \to \forall x A(x)}$$</td>
  <td>$$10.$$</td>
  <td>$$\forall x A(x) \to A(t)$$</td>
</tr>
<tr>
  <td>$$11.$$</td>
  <td>$$A(t) \to \exists x A(x)$$</td>
  <td>$$12.$$</td>
  <td>$${A(x) \to C \over \exists x A(x) \to C}$$</td>
</tr>
<tr>
  <th colspan="4">Group B. Additional postulates for number theory</th>
</tr>
<tr>
  <td>$$13.$$</td>
  <td colspan="3">$$A(0) \& \forall x (A(x) \to A(x')) \to A(x)$$</td>
</tr>
<tr>
  <td>$$14.$$</td>
  <td>$$a' = b' \to a = b$$</td>
  <td>$$15.$$</td>
  <td>$$\lnot a' = 0$$</td>
</tr>
<tr>
  <td>$$16.$$</td>
  <td>$$a = b \to (a = c \to b = c)$$</td>
  <td>$$17.$$</td>
  <td>$$a = b \to a' = b'$$</td>
</tr>
<tr>
  <td>$$18.$$</td>
  <td>$$a + 0 = a$$</td>
  <td>$$19.$$</td>
  <td>$$a + b' = (a + b)'$$</td>
</tr>
<tr>
  <td>$$20.$$</td>
  <td>$$a \cdot 0 = 0$$</td>
  <td>$$21.$$</td>
  <td>$$a \cdot b' = a \cdot b + a$$</td>
</tr>
</table>

The postulates give a list of axioms (a formula, e.g. $$a + 0 = a$$) or
axiom schemas (formula rules, e.g. $$A \& B \to A$$) that can be used to build
deductions. Deductions are sequences of formulas where each formula is either
an axiom or a formula constructed using an axiom schema using previous formulas
from the sequence.

Axiom schemas is a metamathematical device of specifying an infinite class of
axioms.


# Propositional calculus

The first group, A1, are Hilbert-style postulates for propositional calculus.

It uses a variety of logical operations. In fact:
- 1a and 1b relate to implication $$\to$$ rules
- 3, 4a and 4b relate to conjunction $$\&$$
- 5a, 5b and 6 relate to disjunction $$\lor$$
- 7 and $$8^\circ$$ relate to negation $$\lnot$$

One could use less of the logical operators, e.g. a single NAND symbol, but that
would make a verbose set of axioms even more low level without gaining much for
the scope of the book.

Of the logic operators, the truth table for the implication is not intuitive:

<table style="width:50%">
<tr>
  <th>$$A$$</th>
  <th>$$B$$</th>
  <th>$$A \to B$$</th>
</tr>
<tr>
  <td>False</td>
  <td>False</td>
  <td>True</td>
</tr>
<tr>
  <td>False</td>
  <td>True</td>
  <td>True</td>
</tr>
<tr>
  <td>True</td>
  <td>False</td>
  <td>False</td>
</tr>
<tr>
  <td>True</td>
  <td>True</td>
  <td>True</td>
</tr>
</table>

In particular for when $$A$$ is False, for statements like "if 1 + 1 = 0 then
Paris is the capital of France", it's not clear intuitively that they should be
True.

But when looking at statements like "for all $$x$$ if $$x$$ is a positive odd
number, then $$x^2$$ is a positive odd number", then:
- providing a x that is not a positive odd number (a false statement) cannot be used to refute.
- the only refutation by example is to provide a positive odd number for which the square is not a positive odd.

There is only one rule of inference, 2. This is called modus ponens, the
history of which goes back to antiquity.

$$
\tag{2} {A, A \to B \over B}
$$

It means that in a deduction if you have $$A$$, and you also have $$A \to B$$
then you also have $$B$$. Later he introduces the notation $$A, A \to B \vdash
B$$ for that.

I find it easier to grasp it's logic when the implication is phrased instead in
terms of negation and logical OR.

$$
\tag{2'} {A, \lnot A \lor B \over B}
$$

You could have a formal system without inference rules (rule 2 in this case).
However deduced formulas will only get longer.

Instead of rule $$1b$$:
$$
\tag{1b} (A \to B) \to ((A \to (B \to C)) \to (A \to C))
$$

other Hilbert-style systems use other variations e.g.:

$$
\tag{1b'} (A \to (B \to C)) \to ((A \to B) \to (A \to C))
$$

but they have the same meaning: if you have $$A \to B$$ and $$A \to (B \to C)$$
then by rule 2 (modus ponens) you can deduce $$A \to C$$

Rule 8 has a mark $$^\circ$$ to indicate further choices for formal systems. It
is related to intuitionism. Kleene provides a sympathetic view to intuitionism
and in IM he explores the consequences, e.g. formal systems without
$$8^\circ$$. Intuitionism is a bad term because it sounds mystical and
illogical, it not about intuition in general, actually it turns out that
specific claims can be identified such as the rejection of the discharged of
the double negation.


# Deduction theorem

Very high level the deduction theorem says that "implies implies implies".

There are two symbols for which we used the word "imply":
- $$\to$$ which is part of the formal system, is a symbol like $$\&$$ and
  $$\lor$$ for which eventually one can write a truth table, with the catch
  that `false` values for the left side result in `true` for the implication
  formula
- $$\vdash$$ is used in the meta discussion, means that there is a deduction
  from the formulas on the left to the formulas on the right, with the very
  different catch that when talking about a deduction one has to specify the
  formal system (and therefore the allowable deduction rules)

The role of 1a, 1b and 2 is to prove the deduction theorem for the
propositional calculus formal system.

Concretely one can prove:

> For the propositional calculus, if $$\Gamma, A \vdash B$$ then $$\Gamma \vdash A
> \to B$$.

In more words: if there is a deduction from a set of propositions and A
reaching B, then there is a deduction from that set of proposition reaching $$A
\to B$$.

The proof of this theorem is done by induction on the length of the subsidiary
deduction and it takes case by case the question "how did we prove the last
formula in the deduction, by which rule?".

$$\Gamma, A \vdash B$$ is a subsidiary deduction, it is different and does not
necessarily appear within the final deduction. Adding new axioms impacts
subsidiary deductions rules.

A direct deduction rule remains correct when a system is extended by adding new
axioms (p94). That's because a direct deduction rule only states that certain
deduction can be constructed and new axioms only change the situation by
providing additional means of constructing the same deduction.

But for for a rule that employs a subsidiary deduction, such as the deduction
theorem, adding new axioms can create cases of subsidiary deductions and raise
the question if they can be matched in the resulting deduction (p95).

That's why the deduction theorem is proved for propositional logic, but when
the system is extended it with more postulates the proof needs to be revisited.

In practice there are many cases of postulates that cause no problem, but
induction rules do cause problems by adding more cases to proof of the
deduction theorem.

That explains why in group A1 above for the propositional calculus there is a
single inference rule (rule 2).

A deduction theorem for the predicate calculus (which also includes group A2),
where there are to more inference rules, is possible, but it comes with some
additional restrictions.


# Link to natural deduction

The weird numbering scheme $$1a$$, $$1b$$ etc. was chosen to match the layout
for the "natural deduction" rules (p98), shown below with numbering.

- $$1$$ in the natural deduction is the deduction theorem, requiring postulates
  $$1a$$, $$1b$$ and $$2$$ for it's proof
- $$2$$ in the natural deduction is postulate $$2$$
- $$3$$ in the natural deduction also requires postulate $$3$$
- $$4$$ in the natural deduction also requires postulates $$4a$$ and $$4b$$
- $$5$$ in the natural deduction also requires postulates $$5a$$ and $$5b$$
- etc.

<table>
<tr>
  <th colspan="5">Rules for the propositional calculus</th>
</tr>
<tr>
  <th></th>
  <th colspan="2">Introduction</th>
  <th colspan="2">Elimination</th>
</tr>
<tr>
  <th>Implication</th>
  <td>\(1.\)</td>
  <td>If \(\Gamma, A \vdash B\)<br/>then \(\Gamma \vdash A \to B\)</td>
  <td>\(2.\)</td>
  <td>\(A, A \to B \vdash B\)<br/><strong>Modus ponens</strong></td>
</tr>
<tr>
  <th>Conjunction</th>
  <td>\(3.\)</td>
  <td>\(A, B \vdash A \& B\)</td>
  <td>\(4.\)</td>
  <td>\(A \& B \vdash A\)<br/>\(A \& B \vdash B \)</td>
</tr>
<tr>
  <th>Disjunction</th>
  <td>\(5.\)</td>
  <td>\(A \vdash A \lor B\)<br/>\(B \vdash A \lor B\)</td>
  <td>\(6.\)</td>
  <td>If \(\Gamma, A \vdash C\) and \(\Gamma, B \vdash C\)<br/>then \(\Gamma
  \vdash A \lor B \vdash C\)<br/><strong>Proof by cases</strong></td>
</tr>
<tr>
  <th>Negation</th>
  <td>\(7.\)</td>
  <td>If \(\Gamma, A \vdash B\) and \(\Gamma, A \vdash \lnot B\)<br/>then
  \(\Gamma \vdash \lnot A\)<br/><strong>Reductio ad absurdum</strong></td>
  <td>\(8^\circ.\)</td>
  <td>\(\lnot \lnot A \vdash A\)<br/><strong>Discharge of double negation</strong></td>
</tr>
<tr>
  <th colspan="5">Additional rules for the propositional calculus</th>
</tr>
<tr>
  <th></th>
  <th colspan="2">Introduction</th>
  <th colspan="2">Elimination</th>
</tr>
<tr>
  <th>Generality</th>
  <td>\(9.\)</td>
  <td>\(A(x) \vdash^x \forall x A(x)\)</td>
  <td>\(10.\)</td>
  <td>\(\forall x A(x) \vdash A(t)\)</td>
</tr>
<tr>
  <th>Existence</th>
  <td>\(11.\)</td>
  <td>\(A(t) \vdash \exists x A(x)\)</td>
  <td>\(12.\)</td>
  <td>If \(\Gamma(x), A(x) \vdash C\)<br/>then \(\Gamma(x), \exists x A(x)
  \vdash^x C\)</td>
</tr>
</table>

There is nothing natural about the natural deduction rules in the same way as
intuitionism is not about intuition.

When we looked at the deduction theorem it turns out that induction rules in
particular cause issues with it's proof, but other the other postulates it's
easy to check that they do not. **If the natural deduction rules are taken as a
basis, as some logic course do, this issue of the impact of adding more rules
is not as clear.**


# Predicate calculus

This requires postulates in group A1 and A2. It introduces two quantifiers:
$$\exists$$ and $$\forall$$.

Theoretically one could use only one of them, but similarly to the boolean
operators it would gone for a lower level outside the scope of the book.

This is a first-order logic, which means that the quantifiers apply to
variables of values $$x$$ as opposed also predicates/properties.

It introduces two inference rules, $$9$$ and $$12$$, with consequences for the
deduction theorem touched above.


# Number theory

The postulates in group A3 follow a Peano style. The tick sign is the successor
(i.e. "plus one").

- Postulate $$13$$ is the induction rule.
- Postulates $$14$$ to $$17$$ relate to equality
- Postulates $$18$$ and $$19$$ relate to addition
- Postulates $$20$$ and $$21$$ relate to multiplication



# References

Stephen Cole Kleene: Introduction to Metamathematics (Ishi Press: 2009 reprint)

Thanks to Alex Kruckman for [answer on StackExchange](https://math.stackexchange.com/q/3974222)
