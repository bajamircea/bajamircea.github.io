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

NOTE: For Kleene's IM 1952, this needs to be modified to: "the deduction of
$$B$$ contains an application of postulate 9 or 12 with respect to $$x$$ to a
formula depending on $$A$$".  In Kleene's IM postulate 9 is $${C \to A(x) \over
C \to \forall x A(x)}$$ and postulate 12 is $${A(x) \to C \over \exists x A(x)
\to C}$$.

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

[deduction-axioms]:        {% post_url 2021-08-24-deduction-axioms %}
