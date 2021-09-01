---
layout: post
title: "Deduction Theorem - Sample formal systems"
categories: maths logic
---

Sample family of formal systems for number theory

{% include mathjax.html %}


The point of formal systems is to enable clear verifications of mathematical
proofs.


# Formal systems setup

We start with a finite set of **symbols**.

**Formulas** are specific finite sequences of symbols. The rules defining which
sequences of symbols are formulas are such that we can check that a string of
symbols is a formula in a finite, efficient number of steps.

NOTE: Be aware that in some texts they call any sequences of symbols formulas,
and what I call formula is called there a "well formed formula".

A **deduction**, from a set of formulas called **assumptions**, is a sequence
of formulas, where each formula in the sequence is justified either as being
one of the assumptions or using a rule, called **postulate**, which can require
previous formulas in the sequence. The last formula in the sequence is the
**deducted formula**.

By "list of assumptions $$\vdash$$ formula", we state that there is a deduction
from the list of assumptions on the left to the formula on the right, without
fully showing the specific deduction sequence. Note that the $$\vdash$$ and comma are
symbols outside the formal system set of symbols.

A **proof** is a deduction with an empty set of assumptions. The last formula
in the sequence of formulas for a proof is called a **theorem**.

We've got a similar setup with an empty list of assumptions for proofs:
"$$\vdash$$ formula".

I'll describe a sample formal system for number theory. Number here is a
natural number: 0, 1, 2, etc. It is just one of the many similar formal systems
for number theory. Ironically for a formal system the description here will be
quite informal, many details will be skipped.


# Sample symbols

The set of symbols used in our formal system is:
- for logical operations:
  - "$$\to$$" implies
  - "$$\lnot$$" negation
  - "$$\forall$$" for all
- for numbers operations and relations:
  - "$$\cdot$$" multiply
  - "$$+$$" add
  - "$$=$$" equal
  - "'" successor (a tick mark) i.e. _add one_
- for constants: "$$0$$"
- for variables: "$$x$$"
- parentheses: "$$($$" and "$$)$$"

Near the symbols I've put some human meaning, but the eventual purpose is for
proofs in the systems to be able to be carried mechanically, devoid of the
meaning.


# Sample formulas

Then you can build sequences of such symbols.

In particular notice that we don't have symbols for $$1$$, $$2$$, $$3$$ etc.
They are represented using the successor (tick mark) repeatedly. $$3$$ is just
an abbreviation for "$$0'''$$" (a zero followed by three tick marks).

Similarly an infinite number of variable names can be created using one symbol
$$x$$ and a number of tick marks. I'll ignore that, be imprecise and use
directly small letters $$x$$, $$y$$, etc. as variable names.

Lots of parentheses are required in a formal system. I'll ignore, be imprecise
and use parentheses only when required to disambiguate.

What we loose on precision, we gain in accuracy for human readers, otherwise
basic formulas have lots of tick marks and parentheses.

To identify which sequences of symbols are formulas we have rules roughly like:
- $$0$$ and $$x$$ are terms
- if $$t$$ and $$s$$ are terms then so are $$t'$$, $$t + s$$ and $$t \cdot s$$
- if $$t$$ and $$s$$ are terms then $$t = s$$ is a formula
- if $$A$$ and $$B$$ are formulas then so are $$\lnot A$$, $$A \to B$$, $$\forall
  x A$$

The important bit about these rules is that given a sequence of symbols, one
can establish if it's a formula (well formed) mechanically through a finite,
efficient process.

Sequences of symbols that are not formulas: "$$+ 0 x = \forall$$" and "$$) 0 0 + \lnot$$".
They look like gibberish.

Example formulas are:
  - "$$x + 0 = x$$": x plus zero equals x
  - "$$x + x = x$$": x plus x equals x (true when x is 0, but false when x is 1)
  - "$$\forall x \lnot(x' = 0)$$": for all x we have x + 1 different from 0

The meaning I associated to formulas is just for us humans, the point is that
we'll want to be possible to perform the checks mechanically, devoid of meaning.


# Sample postulates

<table>
<tr>
  <th colspan="2">Postulates for the propositional calculus</th>
</tr>
<tr>
  <td>Axiom schema A1.</td>
  <td>$$A \to (B \to A)$$</td>
</tr>
<tr>
  <td>Axiom schema A2.</td>
  <td>$$(B \to (C \to D)) \to ((B \to C) \to (B \to D))$$</td>
</tr>
<tr>
  <td>Axiom schema A3.</td>
  <td>$$(\lnot C \to \lnot B) \to ((\lnot C \to B) \to C)$$</td>
</tr>
<tr>
  <td>Rule of inference MP (modus ponens)</td>
  <td>$${A, A \to B \over B}$$</td>
</tr>
<tr>
  <th colspan="2">Additional postulates for the predicate calculus</th>
</tr>
<tr>
  <td>Axiom schema A4 (See note).</td>
  <td>$$\forall x B(x) \to B(t)$$</td>
</tr>
<tr>
  <td>Axiom schema A5 (See note).</td>
  <td>$$(\forall x (B \to C)) \to (B \to \forall x C)$$</td>
</tr>
<tr>
  <td>Rule of inference Gen (generalisation)</td>
  <td>$$B \over \forall x B$$</td>
</tr>
<tr>
  <th colspan="2">Additional postulates for the number theory</th>
</tr>
<tr>
  <td>Axiom A6.</td>
  <td>$$x + 0 = x$$</td>
</tr>
<tr>
  <td colspan="2">Further axioms for number theory ...</td>
</tr>
</table>

Notes:
- A4 requires: $$t$$ must be a term that is free for $$x$$ in $$B$$
- A5 requires: $$B$$ contains no free occurrences of $$x$$ in $$C$$


# Kinds of postulates

Some postulates are axioms, a postulate which is a formula, e.g. A6. To use it
as a justification for a formula in a deduction, you just need to identify the
axiom. An axiom is in effect a kind of additional assumption.

Others are axiom schemas, e.g. A1. They define an infinite set of axioms. E.g.
in $$A \to (B \to A)$$ you can replace $$A$$ and $$B$$ with any formula, each
time you do so you instantiate a specific axiom that matches the axiom schema.
To use it in a deduction, you need to identify the axiom schema and the
formulas used as replacements.

The third kind we used are rules of inference, e.g. MP and Gen. They have the
form of one or more premises (above the horizontal line) and a conclusion
(under the horizontal line). To use the conclusion if a rule of inference in a
deduction, you need to identify the rule of inference and the previous positions
at which the premises occur, in the sequence of formulas of the deduction.

One can think of axioms and axiom schemas of special cases of rules of
inference with no premises.


# Sample propositional calculus

The first group of postulates (axiom schemas A1 to A3 and the rule of inference
MP) can be used separately to create a **formal system for propositional
calculus**. This is the kind of formal system where formulas are linked by
logical operators like $$\lnot$$ (logical not), $$\&$$ (and), $$\lor$$
(inclusive or), $$\to$$ (material implication). There are similar/equivalent
systems that use more symbols and there is also the possibility to have just
one logical operator.


# Sample predicate calculus

We get a sample **formal system for predicate calculus** if we use the first
two groups of postulates (axiom schemas A1 to A5 and the two rules of inference MP
and Gem). Often such systems have two quantifiers: $$\exists$$ and $$\forall$$,
ours has just one, like we've done for logical operators.

This is a first-order logic, which means that the quantifiers apply to
variables of values $$x$$ as opposed also predicates/properties.


# Sample number theory

You need all the postulates above for a **number theory formal system**. In
fact I've only shown one of the additional postulates required, but for our
purpose it's sufficient to say that it contains no additional rules of
inference on top of the ones for predicate calculus.

