---
layout: post
title: "Deduction Theorem - Dependence and variation"
categories: maths logic
---

The dependent and varied terminology is meant to define some restrictions to
applying some rules in predicate logic.

{% include mathjax.html %}


# Dependent

Given a deduction as a sequence of formulas $$D_0,D_1, ... D_n$$ from a set of
assumptions including the assumption $$A$$. Then $$D_i$$ _depends on_ $$A$$ if:

- $$D_i$$ is justified as being $$A$$
- $$D_i$$ is justified via a rule of inference where at least on of the
  premises depends on $$A$$.

The definition is done by induction and assumes that dependence is only defined
as above.

The importance of dependence is that it can be shown that:

> If in $$\Gamma, A \vdash B$$, $$B$$ does not depend on $$A$$, then $$\Gamma
> \vdash B$$

So basically if the result of a deduction does not depend on an assumption,
then the assumption can be eliminated, because it means that the result of the
deduction was reached from the other assumptions and postulates only.


# Varied

Given a deduction (with justification for each step) for a formula $$B$$, a
variable $$x$$ _is varied for the assumption_ $$A$$ if:
- $$x$$ occurs free in the assumption $$A$$
- $$B$$ depends on the assumption $$A$$
- the deduction of $$B$$ contains an application of the Gen rule with respect
  to $$x$$ to a formula depending on $$A$$.

NOTE: The above is for our [sample formal system][deduction-axioms] inspired by
Mendelson IML (6th edition), remember that the Gen rule is $$B \over \forall x
B$$.

NOTE: For Kleene's IM (1952), this needs to be modified to: "the deduction of
$$B$$ contains an application of postulate 9 or 12 with respect to $$x$$ to a
formula depending on $$A$$". In Kleene's IM postulate 9 is the rule of
inference $${C \to A(x) \over C \to \forall x A(x)}$$ and postulate 12 is the
rule of inference $${A(x) \to C \over \exists x A(x) \to C}$$.

NOTE: in both cases the application refers to the additional rules of inference
for the propositional calculus.

**TODO:** Note that Mendelson uses the strong rule $$B \over \forall x B$$,
whereas in Kleene only the weaker one is used in the generality-introduction
$$A(x) \vdash^x \forall x A(x)$$. Figure out the consequences.


# Held constant

If a variable $$x$$ _is not varied_ for an assumption $$A$$ in a deduction for
$$B$$, we say that $$x$$ _is held constant_.

A simple example where a variable is held constant is when it does not occur
free in the assumption $$A$$.

# Superscript in Kleene's IM (1952)

In Kleene's IM (1952), the generality-introduction uses a superscript e.g.
$$A(x) \vdash^x \forall x A(x)$$. The superscript indicates that variation
might occur/not necessarily held constant as follows.

His definition for the superscript usage "is to mark the application of Rule 9
or 12 with respect to $$x$$ in constructing the resulting deduction".

The generality-introduction in Kleene is proved as follows. Let $$C$$ be some
axiom that does not contain $$x$$ free.

1. $$A(x)$$ - the assumption formula, depends on the assumption formula because
it is the assumption formula
2. $$A(x) \to (C \to A(x))$$ - axiom schema $$1a$$.
3. $$C \to A(x)$$ - rule of inference 2 (on steps 1 and 2), depends on the
assumption formula because it's rule 2 on a premise that depends on assumption
formula (the first premise - step 1)
4. $$C \to \forall x A(x)$$ - rule 9 (on step 3), depends on the assumption
formula (uses step 3 as a premise), and that's the application of rule 9 with
respect to $$x$$
5. $$C$$ - the axiom we have chosen
6. $$\forall x A(x)$$ - rule 2 (on steps 5 and 4), deducted formula depends on
the assumption formula (uses step 4 as a premise)

This means that for generality-introduction we almost have all the conditions
for variation, except if $$x$$ does not occur free in $$A(x)$$.

The situation for for the existence-elimination is more complex and explained
in Lemma 7b on p104.


[deduction-axioms]:        {% post_url 2021-08-24-deduction-axioms %}
