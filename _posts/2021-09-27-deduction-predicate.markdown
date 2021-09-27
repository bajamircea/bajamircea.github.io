---
layout: post
title: "Deduction Theorem - For predicate calculus"
categories: maths logic
---

Deduction theorem for the predicate calculus

{% include mathjax.html %}


# Sample propositional calculus

We're using the for the predicate calculus a [sample formal
system][deduction-axioms] with the following postulates in addition to the ones
for the [propositional calculus][deduction-propositional]:

<table>
<tr>
  <td>Axiom schema A4 (see notes).</td>
  <td>$$\forall x B(x) \to B(t)$$</td>
</tr>
<tr>
  <td>Axiom schema A5 (see notes).</td>
  <td>$$(\forall x (B \to C)) \to (B \to \forall x C)$$</td>
</tr>
<tr>
  <td>Rule of inference Gen (generalisation)</td>
  <td>$$B \over \forall x B$$</td>
</tr>
</table>

Notes:
- A4 requires: $$t$$ must be a term that is free for $$x$$ in $$B(x)$$
- A5 requires: $$B$$ does not contain free occurrences of $$x$$

We'll see that these restrictions (the one for axiom schema A5 in particular
that $$B$$ does not contain free occurrences of $$x$$) will result in
restrictions in the deduction theorem for the predicate calculus (compared with
the one for propositional calculus).

# Statement

For the predicate calculus:

> If $$ \Gamma, A \vdash B $$, with the free variables not varied (i.e. held
> constant) for the assumption formula $$A$$, then $$ \Gamma \vdash A \to B$$.


# Proof idea

Similar to the [proof for the deduction theorem for the propositional
calculus][deduction-propositional]. That was done by induction on the length of
the deduction.

We are given a sequence of formulas $$D_0, D_1, D_2, ... , D_j$$ where the last
formula $$D_j$$ is $$B$$ and each formula $$D_i$$ in the sequence is properly
justified.

We distinguish the following cases justifying a formula $$D_i$$. $$D_i$$ is:

- (a) one of the formulas in $$\Gamma$$
- (b) the formula A
- (c) an axiom (e.g. by one of the axioms schemas A1 to A5)
- (d) an immediate consequence (i.e. the conclusion) by the rule of inference
  MP, where the premises for applying MP are preceding formulas in the
  deduction sequence.
- (e) an immediate consequence (i.e. the conclusion) by the rule of inference
  Gen, where the premise for applying Gen is a preceding formula in the
  deduction sequence.

The axioms A4 and A5, do not fundamentally change the proof.

But the rule of inference Gen creates a new case (e). The restriction that free
variables are not varied for the assumption formula $$A$$ mean that case (e),
where $$D_i$$ is justified by applying Gen, can be broken into:
- (e1) the application is not for a free variable in $$A$$
- (e2) the application is not for a formula depending on $$A$$


# Induction proposition

With respect to a index $$n$$ and the sequence of formulas above, the induction
proposition $$P(n)$$ is: "If $$\Gamma, A \vdash D_n$$ (of length n + 1), with
the free variables not varied (i.e. held constant) for the assumption formula
$$A$$, then $$\Gamma \vdash A \to D_n$$".


# Base case

For the base case ($$D_0$$) we can only have cases (a), (b) or (c) (not (d) or
(e) because they require premises to be preceding formulas).

Proof is same as for propositional calculus.


# Induction step

We need to show: "If $$\Gamma, A \vdash D_{n + 1}$$ (of length n + 2), then
$$\Gamma \vdash A \to D_{n + 1}$$", while relying on the induction proposition
$$P(k)$$: "If $$\Gamma, A \vdash D_k$$ (of length k + 1), then $$\Gamma \vdash
A \to D_k$$" for all $$0 \le k \le n$$, with the restriction that the free
variables not varied (i.e. held constant) for the assumption formula $$A$$ in
the subsidiary deductions.


## For cases (a), (b), (c) and (d)

Proof is same as for propositional calculus.

## For case (e)

We are given a deduction from $$\Gamma, A$$ where the last formula in the
deduction sequence, $$D_{n + 1}$$, was obtained by applying Gen on a premise
preceding $$D_{n + 1}$$. Let $$D_i$$ be those premises for the application of
Gen (with $$i$$ less than $$n + 1$$). We also know that to apply the Gen rule:
$$D_{n + 1}$$ must be of the form $$\forall x D_i$$.

This then is taken case by case in (e1) and (e2).


## For case (e1)

For this case we also know that the application of the Gen rule to deduce
$$D_{n + 1}$$ was done for a variable $$x$$ which is not free in $$A$$.

Therefore we can build a deduction from $$\Gamma$$ as the following sequence of
formulas:
- ...
- formula p: $$A \to D_i$$ - as per the induction assumption, for $$k$$ being
  $$i$$, there is a deduction $$\Gamma \vdash A \to D_i$$ (assuming it takes p
  preceding formulas in the deduction)
- formula p + 1: $$\forall x (A \to D_i)$$ - rule Gen (on formula p)
- formula p + 2: $$(\forall x (A \to D_i)) \to (A \to \forall x D_i)$$ - axiom
  schema A5, noting that we meet the requirement that $$A$$ does not have the
  variable $$x$$ free
- formula p + 3: $$A \to D_{n + 1}$$ - rule MP (on p + 1 and p + 2) noting
  that for case (e) we have $$D_{n + 1}$$ is $$\forall x D_i$$


### For case (e2)

For this case we also know that $$D_{n + 1}$$ does not depend on $$A$$,
therefore $$D_i$$ does not depend on $$A$$.

Therefore we can build a deduction from $$\Gamma$$:

- ...
- formula p: $$D_i$$ - as $$D_i$$ does not depend of $$A$$ in $$\Gamma, A
  \vdash D_i$$, then there is a deduction of $$D_i$$ from just $$\Gamma$$.
- formula p + 1: $$D_{n + 1}$$ - by rule Gen (on formula p) noting that for
  case (e) we have $$D_{n + 1}$$ is $$\forall x D_i$$
- formula p + 2: $$D_{n + 1} \to (A \to D_{n + 1})$$ - axiom schema A1
- formula p + 3: $$A \to D_{n + 1}$$ - rule MP (on p + 1 and p + 2)



This completes the proof.

Note that we did not use axiom schema A4.


[deduction-axioms]:         {% post_url 2021-08-24-deduction-axioms %}
[deduction-propositional]:  {% post_url 2021-09-15-deduction-propositional %}
