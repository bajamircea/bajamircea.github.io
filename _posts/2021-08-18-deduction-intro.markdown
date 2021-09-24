---
layout: post
title: "Deduction Theorem - Introduction"
categories: maths logic
---

Introduction to the deduction theorem

{% include mathjax.html %}

In mathematical logic, **deduction theorem** is a general name for
meta-theorems that state something on the kind:

> **If $$ \Gamma, A \vdash B $$ then $$ \Gamma \vdash A \to B$$**.

This is read as: If $$B$$ can be proved from a set of premises $$\Gamma$$ and
$$A$$ (i.e. the premises include $$A$$), then there is a (different) proof of
"$$A \to B$$" ($$A$$ implies $$B$$) from the same set of premises $$\Gamma$$
without $$A$$.

Very informally a deduction theorem states that "implies implies implies". This
is a pun to the fact that the material implication logical operator $$\to$$ is
closely related to the deduction yields ($$\vdash$$), either of them is called
implication (usually when it's clear from context which one is meant).

The reason for being a general name is that words like "there is a proof",
represented by the symbol $$\vdash$$, are relative to a formal system e.g.
"there is a proof using this specific formal system". A specific formal system
has its own theorem that we call the deduction theorem for that formal system.
For some formal systems a deduction theorem does not exist/does not make sense,
while in others, as we'll see, it comes with additional
constraints/requirements to the basic form above.

The plan in this series of articles is to cover two examples of deduction
theorems: a simple one for propositional calculus and a more complicated one
with additional constraints for predicate calculus.

Will cover:
- [mathematical logic][deduction-logic]
- [sample formal systems][deduction-axioms]
- [sample proof that][deduction-a-to-a] $$A \to A$$
- [induction][deduction-induction]
- [deduction theorem for propositional calculus][deduction-propositional]
- [on subsidiary deductions][deduction-subsidiary]
- [free and bound variables][deduction-free]
- dependent
- deduction theorem for predicate calculus
- what does it mean?


# References

Stephen Cole Kleene: Introduction to Metamathematics (Ishi Press: 2009 reprint)

Elliott Mendelson: Introduction to Mathematical Logic - sixth edition (CRC Press: 2015)

[Encyclopedia of Mathematics: Deduction Theorem](http://encyclopediaofmath.org/index.php?title=Deduction_theorem&oldid=46599)

Euclid: The Thirteen Books of the Elements / Translated and commentary by Sir
Thomas L. Heath / Vol.1 (Books I and II)

[deduction-logic]:         {% post_url 2021-08-21-deduction-logic %}
[deduction-axioms]:        {% post_url 2021-08-24-deduction-axioms %}
[deduction-a-to-a]:        {% post_url 2021-08-28-deduction-a-to-a %}
[deduction-induction]:     {% post_url 2021-09-01-deduction-induction %}
[deduction-propositional]: {% post_url 2021-09-15-deduction-propositional %}
[deduction-subsidiary]:    {% post_url 2021-09-17-deduction-subsidiary %}
[deduction-free]:          {% post_url 2021-09-21-deduction-free %}
