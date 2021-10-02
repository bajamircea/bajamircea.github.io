---
layout: post
title: "Choice of postulates in IM"
categories: review book
---

The choice of postulates in Stephen Cole Kleene's Introduction to Metamathematics

{% include mathjax.html %}

The book introduces a list of postulates for a family of formal systems without
a immediate explanation on numbering scheme and the reasons behind that
particular choice. These are my notes on the subject.


# Postulates

There are three groups of axioms (p82), that can be used to build a variety of
formal systems, mainly in an additive fashion (e.g. group A1 and A2 for
predicate calculus).

<table>
<tr>
  <th colspan="4">Postulates</th>
</tr>
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

Restrictions:
- for $$9$$ and $$12$$: $$C$$ does not contain $$x$$ [free][deduction-free]
- for $$10$$ and $$11$$: $$t$$ [is a term free][deduction-free] for $$x$$ in $$A(x)$$

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

One could use less of the logical operators, even a single primitive operator
symbol (p139). There are two such single primitive operator choices:
alternative denial (NAND) or joint denial (NOR). The first observation is
that using a single primitive operator, would make a verbose set of axioms even
more low level. For another reason see intuitionism below.

Of the logic operators, the truth table for the (material) implication is not
intuitive:

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

In particular when $$A$$ is false, for statements like "if 1 + 1 = 0 then
Paris is the capital of France", it's not clear intuitively that they should be
true.

But when looking at statements like "for all $$x$$ if $$x$$ is a positive odd
number, then $$x^2$$ is a positive odd number", then:
- providing an $$x$$ that is not a positive odd number (a false statement) cannot be used to refute.
- the only refutation by example is to provide a positive odd number for which the square is not a positive odd.

There is only one rule of inference, 2. This is called modus ponens, the
history of which goes back to antiquity.

$$
\tag{2} {A, A \to B \over B}
$$

It means that in a deduction if you have $$A$$, and you also have $$A \to B$$
then you also have $$B$$. Later he introduces the notation $$A, A \to B \vdash
B$$ for that.

In the system described here there is a close linked between the material
implication logical operator ($$\to$$) and yields ($$\vdash$$): sometimes the
word _implication_ is used for either of them.

I find it easier to grasp it's logic when the implication is phrased instead in
terms of negation and logical OR.

$$
\tag{2'} {A, \lnot A \lor B \over B}
$$

You could have a formal system without rules of inference (rule 2 in this case).
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

Postulates $$5a$$ is the dual-converse of $$4a$$.  This is explained in the 2nd
part of the Corollary Theorem 8 (p124): "If $$\vdash E \to F$$ then $$\vdash F'
\to E'$$ (where $$E'$$ and $$F'$$ are obtained from $$E$$ and $$F$$ by
interchanging $$\&$$ and $$\lor$$ throughout)". Same for $$5b$$ and $$4b$$.


# Deduction theorem

Very high level the deduction theorem says that "implies implies implies".

There are two symbols for which we used the word "imply":
- $$\to$$ which is part of the formal system, is a symbol like $$\&$$ and
  $$\lor$$ for which eventually one can write a truth table, with the catch
  that `false` values for the left side result in `true` for the implication
  formula.
- $$\vdash$$ is used in the meta discussion, means that there is a deduction
  from the formulas on the left to the formulas on the right, with the catch
  that when talking about a deduction one has to specify the formal system (and
  therefore the allowable deduction rules). This is sometimes done by using as
  a subscript for $$\vdash$$ the name of the specific formal system that a
  deduction refers to (e.g. for a formal system named $$K$$ use $$\vdash_K$$.

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
single rule of inference (rule 2).

A deduction theorem for the predicate calculus (which also includes group A2),
where there are to more rules of inference, is possible, but it comes with some
additional restrictions.

> For the predicate calculus, if $$\Gamma, A \vdash B$$, with the free
> variables not varied (i.e. held constant) for the assumption formula $$A$$,
> then $$\Gamma \vdash A \to B$$.

See [here for the definition of varied][deduction-dependent].

There are of course weaker variants e.g. requiring $$A$$ to be closed dispenses
with the more complex "not varied" requirement.

There is choice for a postulate system that uses a substitution rule instead of
the axiom schemas used in Kleene's system. He claims that a consequence of
using the substitution rule as a postulate is that even for the propositional
calculus the deduction theorem comes with restrictions similar to the ones for
the deduction theorem for the predicate calculus (p140).


# Link to natural deduction

The name "natural deduction" is misleading: there is nothing natural about it.
It's just that decomposing the formal system to low level postulates makes
proofs quite long, the natural deduction rules are higher level and generally
allow for shorter proofs.

The weird numbering scheme $$1a$$, $$1b$$ etc. was chosen to match the layout
for the "natural deduction" rules (p98), shown below with numbering. The
explanation for this numbering scheme is alluded to in Lemma 11 (p106).

<table>
<tr>
  <th colspan="5">Natural deduction rules derived from the postulates</th>
</tr>
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

Restrictions:
- the superscript as in $$\vdash^x$$ in generality-introduction ($$9$$) and in
  existence-elimination ($$12$$) that [variation might happen for $$x$$ (i.e.
  $$x$$ is not necessarily held constant)][deduction-dependent] in constructing
  the resulting deduction
- for predicate calculus in subsidiary deductions the free variables must not
  be varied (i.e. held constant) for the assumption formula to be discharged.
  Subsidiary deductions are employed for implication-introduction ($$1$$),
  disjunction-elimination ($$6$$), negation-introduction ($$7$$), and for
  existence-elimination ($$12$$). These restrictions are related to the
  restriction for the deduction rule for predicate calculus (that happens to be
  the implication-introduction $$1$$ above).

The postulate numbering scheme makes sense from the link to the "natural
deduction"-like rules as follows:
- $$1$$ in the natural deduction is the deduction theorem, requiring postulates
  $$1a$$, $$1b$$ and $$2$$ for it's proof
- $$2$$ in the natural deduction is postulate $$2$$
- $$3$$ in the natural deduction also requires postulate $$3$$
- $$4$$ in the natural deduction also requires postulates $$4a$$ and $$4b$$
- $$5$$ in the natural deduction also requires postulates $$5a$$ and $$5b$$
- etc.

though in general $$1a$$, $$1b$$ and $$2$$ are additionally used for most of
the natural deduction rules.

In Kleene's system, the "natural deduction"-like rules are deduced from the
postulates above.

When we looked at the deduction theorem it turns out that induction rules in
particular cause issues with it's proof, but other the other postulates it's
easy to check that they do not. **If the natural deduction rules are taken as a
basis, as some logic course do, this issue of the impact of adding more rules
is not as clear.**


# Choices for postulate 8 on negation and intuitionism

To start with, "$$8^\circ$$: $$\lnot \lnot A \to A$$" is the choice made by
Kleene for this formal system (_the classical system_), presumably for
similarities with the natural deduction rule for the discharge of double
negation ("$$\lnot \lnot A \vdash A$$").

Another choice could have been "$$A \lor \lnot A$$" (named "the law of excluded
middle" which is equivalent to $$8^\circ$$ (see p120): either could have been
chosen for his classical system.

Postulate 8 has a mark $$^\circ$$ to indicate further choices for formal
systems. It is related to intuitionism.

Kleene provides a sympathetic view to intuitionism and in IM he explores the
consequences of the inuitionistic choices. Intuitionism is a misleading term
because it sounds mystical and illogical, it not about intuition in general,
actually it turns out that specific claims can be identified such as the
rejection of the negation rules above (e.g. due to objections to extending
rules that apply to finite sets to infinite ones).

Intuitionists reject the rule $$8^\circ$$, but accept the following rule
"$$8^I$$: $$\lnot A \to (A \to B)$$ ("from falsehood, anything follows"). If in
the classical system we replace rule $$8^\circ$$ with $$8^I$$ (while keeping
the other rules) we obtain a different formal system: _the (corresponding)
intuitionistic system_.

Rule $$8^I$$ can be deduced in the classical system accepting $$8^\circ$$, but
not the other way around (see p101).

When using rule $$8^I$$ in the intuitionistic system, the equivalent natural
deduction rule is "$$A, \lnot A \vdash B$$" called "the rule of weak
$$\lnot$$-elimination", which reads: any formula is deducible from a
contradiction. The rule of weak $$\lnot$$-elimination can be proven in the
classical system as well.

The importance of the weak $$\lnot$$-elimination in formal systems is as
follows.

A formal systems having a negation symbol, e.g. $$\lnot$$, is said to be
_(simply) consistent)_ if for no formula both $$A$$ and $$\lnot A$$ are
provable in the system; and to be _(simply) inconsistent_ if for some formula
both $$\vdash A$$ and $$\vdash \lnot A$$.

For formal systems that have $$\&$$-elimination and weak $$\lnot$$-elimination
(either as postulates or as derived rules) this is equivalent to _(simply)
consistent_ if there is some unprovable formula; _(simply) inconsistent_ if
every formula is provable (see p124-125).

Intuitionists accept however the axiom schema $$7: (A \to B) \to ((A \to \lnot
B) \to \lnot A)$$" ("the law of contradiction").

Another choice linked to intuitionism is the number of logical operators in
propositional calculus (e.g. many or two or a single primitive one as discussed
above). It turns out that it the intuitionist propositional calculus none of
the four operators can be expressed in terms of the remaining ones (p141).


# Predicate calculus

This requires postulates in group A1 and A2. It introduces two quantifiers:
$$\exists$$ and $$\forall$$.

Theoretically one could use only one of them, but similarly to the boolean
operators it would choose to go for a lower level outside the scope of the
book. Also both of them are required for the inuitionist logic, where one does
not suffice.

This is a first-order logic, which means that the quantifiers apply to
variables of values $$x$$ as opposed also predicates/properties.

It introduces two rules of inference, $$9$$ and $$12$$, with consequences for the
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

Stanford Encyclopedia of Philosophy: [Intuitionistic
Logic](https://plato.stanford.edu/entries/logic-intuitionistic/)

[deduction-free]:          {% post_url 2021-09-21-deduction-free %}
[deduction-dependent]:     {% post_url 2021-09-24-deduction-dependent %}
