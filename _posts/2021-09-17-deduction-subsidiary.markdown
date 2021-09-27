---
layout: post
title: "Deduction Theorem - On subsidiary deductions"
categories: maths logic
---

Notes on subsidiary deductions

{% include mathjax.html %}


A theorem of the simple form $$\Delta \vdash E$$ is _a rule of the direct
type_.

But the deduction theorem is _a rule of the subsidiary deduction type_. For the
application of the rule it requires a deduction $$\Gamma, A \vdash B$$, which
is the _subsidiary deduction_, and it shows how to build a deduction $$\Gamma
\vdash A \to B$$, which is the _resultant deduction_. We say that the
(occurrence) of $$A$$ has been _discharged_ from the list of assumptions.

They behave differently when new postulates get added to a formal system.

A rule of direct type remains true since it shows directly how a deduction is
to be constructed, adding new postulates only potentially provides additional
ways to construct the same deduction.

That is not the necessarily true for rules of subsidiary deduction type. For
example notice that in the proof for for the deduction theorem for the
propositional calculus we did not use the axiom schema A3. Removing it, or
adding similar axiom schemas (or just plain axioms) does not change the proof.
But adding rules of inference invalidates the proof because it creates
additional cases that needs to be considered in the proof if the rule.

In particular our [sample predicate calculus][deduction-axioms] adds the Gen
(generalisation) rule of inference to the propositional calculus rules, hence
we need to reconsider the deduction theorem and it's proof for the predicate
calculus, despite having proven it for the propositional calculus.


[deduction-axioms]:        {% post_url 2021-08-24-deduction-axioms %}
