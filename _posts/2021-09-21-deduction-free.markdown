---
layout: post
title: "Deduction Theorem - Free and bound"
categories: maths logic
---

The free and bound terminology is meant to define some restrictions to applying
some rules in predicate logic.


{% include mathjax.html %}


# Free and bound variables

## Definitions

When we use a quantifier like $$\forall$$ (similar for $$\exists$$), in
predicate logic, the quantifier is followed by a variable and a formula which
might contain that variable (in the scope of the quantifier). These occurrences
of a variable in the scope of the quantifier are said to be _bound occurences_.
Occurrences of a variable in a formula that are not bound are said to be _free
orccurences_.

If a formula has a variable occurring free, then that variable is _free_ in the
formula. Likewise for _bound_.


## Example of terminology

E.g. let's look at something equivalent to $$(a < b) \to (a \ne b + c)$$. Let
our formula $$A$$ be:
> $$(\lnot \forall c \lnot (c' + a = b)) \to \lnot (a = b + c)$$

I reached that by:
- expanding $$a < b$$ to $$\exists x (x' + a = b)$$ (i.e. exists $$x$$ such as
  $$x + 1 + a = b$$)
- expanding $$\exists x B$$ to $$\lnot \forall x \lnot B$$ (as in our sample
  formal system we only use $$\forall$$)
- using $$c$$ instead of $$x$$ so that I can illustrate better the bound and
  free ideas

In our formula $$A$$:
- $$a$$ occurs twice: both occurrences are free occurrences. Rationale: the first
  occurrence is in the scope for the quantifier $$\forall$$, but it's not the
  variable name following $$\forall$$; the second occurrence is not even in the
  scope of a quantifier.
- same for $$b$$
- $$c$$ occurs 3 times: the first two occurrences are bound occurrences, the
  last one is a free occurrence

Note that while a specific occurrence for a variable is either a free or a
bound occurrence in a given formula, the same variable can be both free and
bound in a formula e.g. $$c$$ is both free and bound in $$A$$ because the last
occurrence is free and the other two occurrences are bound.


## Example of restrictions

In our [sample formal system][deduction-axioms], axiom schema A5 allows
$$(\forall x (B \to C)) \to (B \to \forall x C)$$ only if $$B$$ does not
contain free occurrences of $$x$$ (while $$C$$ can contain free occurrences of
$$x$$).


# Term free for variable in formula

## Definition

A _term is free for a variable in a formula_ if when we substitute the term in
the formula on the free occurrences of that variable in the formula, the other
variables in the term do not become bound in the scope of a quantifier.


## Example of terminology

We pick a term, a variable and a formula, then we're replacing the free
occurrences of a variable in the formula with the term and then we assess if
the term is free for the variable in the formula.

For example using the formula $$A$$ above:

- term $$0$$ is free for $$a$$ in $$A$$. Replacing we get $$(\lnot \forall c
  \lnot ( c' + 0 = b)) \to \lnot (0 = b + c)$$ which is equivalent to $$(0 < b)
  \to (0 \ne b + c)$$
- term $$d'$$ is free for $$a$$ in $$A$$. Replacing we get $$(\lnot \forall c
  \lnot ( c' + d' = b)) \to \lnot (d' = b + c)$$ which is equivalent to $$(d' <
  b) \to (d' \ne b + c)$$
- term $$c + d$$ is not free for $$a$$ in $$A$$. The reason is that replacing
  $$c + d$$ in the first occurrence of $$a$$ in $$A$$ (which is a free
  occurrence) will make the variable $$c$$ from the term $$c + d$$ become
  bound, so we don't meet the definition. For reference the result of the
  replacement would be $$(\lnot \forall c \lnot ( c' + c + d = b)) \to \lnot (c + d = b + c)$$.
- $$0$$ is free for $$c$$ in $$A$$. Replacing we get $$(\lnot \forall c \lnot (
  c' + a = b)) \to \lnot (a = b + 0)$$ which is equivalent to $$(a < b) \to (a
  \ne b + 0)$$. Notice we did not replace the bound occurrences of $$c$$, only
  the free one. Note that replacing at bound occurrences will give get things
  like $$\forall 0$$, which is not even part of a well formed formula.
- etc.

## Example of restrictions

In our [sample formal system][deduction-axioms], the axiom schema A4 allows
$$\forall x B(x) \to B(t)$$ provided that $$t$$ is a term that is free for
$$x$$ in $$B(x)$$.


[deduction-axioms]:        {% post_url 2021-08-24-deduction-axioms %}
