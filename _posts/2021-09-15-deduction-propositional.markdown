---
layout: post
title: "Deduction Theorem - For propositional calculus"
categories: maths logic
---

Deduction theorem for the propositional calculus

{% include mathjax.html %}


# Sample propositional calculus

We're using the for the propositional calculus a [sample formal
system][deduction-axioms] with the following postulates:

<table>
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
</table>


# Statement

For the propositional calculus:

> If $$ \Gamma, A \vdash B $$ then $$ \Gamma \vdash A \to B$$.


# Proof idea

The hypothesis says that there is a sequence of formulas $$D_0, D_1, D_2, ... ,
D_j$$ where the last formula $$D_j$$ is $$B$$ and each formula $$D_i$$ in the
sequence is properly justified.

We distinguish the following cases of justifying a formula $$D_i$$ in the
sequence. $$D_i$$ is:
- (a) one of the formulas in $$\Gamma$$
- (b) the formula A
- (c) an axiom (e.g. by one of the axioms schemas A1 to A3)
- (d) an immediate consequence (i.e. the conclusion) by the rule of inference MP,
  where the premises for applying MP are formulas preceding $$D_i$$ in the
  deduction sequence.

We'll prove by [course-of-values induction][deduction-induction] on the length
of the given deduction. So we need a induction proposition, prove the base case
and the induction step.


# Induction proposition

With respect to a index $$n$$ and the sequence of formulas above, the induction
proposition $$P(n)$$ is: "If $$\Gamma, A \vdash D_n$$ (of length n + 1), then
$$\Gamma \vdash A \to D_n$$".


# Base case

We need to show: "If $$\Gamma, A \vdash D_0$$ (of length 1), then $$\Gamma \vdash A
\to D_0$$", in particular we'll outline how to construct a deduction of $$A \to
D_0$$ from just $$\Gamma$$.

For the base case we can only have cases (a), (b) or (c) (not (d) because it
requires premises to be preceding formulas).


## For case (a)

We are given a deduction from $$\Gamma, A$$ with a single formula in the
sequence $$D_0$$, with the justification that $$D_0$$ is one of the formulas in
$$\Gamma$$.

Then we can build a deduction from $$\Gamma$$ as the following sequence of
formulas:
1. $$D_0$$ - a formula in $$\Gamma$$
2. $$D_0 \to (A \to D_0)$$ - axiom schema A1
3. $$A \to D_0$$ - rule MP (on 1. and 2.)


## For case (b)

We are given a deduction from $$\Gamma, A$$ with a single formula in the
sequence $$D_0$$, with the justification that $$D_0$$ the formula $$A$$.

We have [previously shown][deduction-a-to-a] that $$\vdash A \to A$$, but
because $$D_0$$ is $$A$$, then $$\vdash A \to D_0$$. We can add (unused)
assumptions and we've shown that $$\Gamma \vdash A \to D_0$$.


## For case (c)

We can build the deduction $$\Gamma \vdash A \to D_0$$ by following the steps
in case (a) with the justification for step 1. being that $$D_0$$ is an axiom
(instead of a formula in $$\Gamma$$. Note that similarly to case (b) we're not
really using the assumptions from $$\Gamma$$.


# Induction step

We need to show: "If $$\Gamma, A \vdash D_{n + 1}$$ (of length n + 2), then
$$\Gamma \vdash A \to D_{n + 1}$$", while relying on the induction proposition
$$P(k)$$: "If $$\Gamma, A \vdash D_k$$ (of length k + 1), then $$\Gamma \vdash
A \to D_k$$" for all $$0 \le k \le n$$.


## For cases (a), (b) and (c)

This is shown as the cases (a), (b) and (c) of the induction base case, using
$$D_{n + 1}$$ instead of $$D_0$$ (we don't need to rely on $$P(k)$$ for $$0 \le
k \le n$$.


## For case (d)

We are given a deduction from $$\Gamma, A$$ where the last formula in the
deduction sequence, $$D_{n + 1}$$, was obtained by applying MP on premises
preceding $$D_{n + 1}$$. Let $$D_i$$ and $$D_j$$ be those premises for the
application of MP (with $$i$$ and $$j$$ different and both less than $$n +
1$$). We also know that to apply MP $$D_j$$ must be of the form $$D_i \to D_{n + 1}$$.

Therefore we can build a deduction from $$\Gamma$$ as the following sequence of
formulas:
- ...
- formula p: $$A \to D_i$$ - as per the induction assumption, for $$k$$ being
  $$i$$, there is a deduction $$\Gamma \vdash A \to D_i$$ (assuming it takes p
  preceding formulas in the deduction)
- ...
- formula p + q: $$A \to (D_i \to D_{n + 1})$$ - as per the induction
  assumption, for $$k$$ being $$j$$, there is a deduction $$\Gamma \vdash A \to
  D_j$$ (assuming it takes q preceding formulas in the deduction)
- formula p + q + 1: $$(A \to (D_i \to D_{n + 1})) \to ((A \to D_i) \to (A \to
  D_{n + 1}))$$ - axiom schema A2
- formula p + q + 2: $$(A \to D_i) \to (A \to D_{n + 1})$$ - rule MP (on p + q
  and p + q + 1)
- formula p + q + 3: $$A \to D_{n + 1}$$ - rule MP (on p and p + q + 2)

This completes the proof.


[deduction-axioms]:    {% post_url 2021-08-24-deduction-axioms %}
[deduction-a-to-a]:    {% post_url 2021-08-28-deduction-a-to-a %}
[deduction-induction]: {% post_url 2021-09-01-deduction-induction %}
