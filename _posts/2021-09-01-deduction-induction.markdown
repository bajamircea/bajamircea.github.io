---
layout: post
title: 'Deduction Theorem - Induction'
categories: maths logic
---

Quick recap of induction

{% include mathjax.html %}

Given a predicate $$P$$, let's say that assuming $$P(n)$$ you can prove
$$P(n+1)$$. Then if you can find that $$P$$ is true for some integer $$n_0$$,
then you can apply the proof you have step by step and claim that $$P$$ is true
for any integer $$n$$ where $$n \geq n_0$$.

When $$n_0$$ is $$0$$ this gives us the important case for **basic induction**:
- state the **induction proposition**: a proposition $$P$$ depending on a value $$n$$
- prove the **base case**: $$P(0)$$ is true
- prove the **induction step**: assuming $$P(n)$$ true show that $$P(n+1)$$ is true

then claim **by induction** that $$P(n)$$ is true for all natural numbers 0, 1, 2, ...

Another important case is the one for **course-of-values induction** which
modifies the induction step to be: assume that $$P(k)$$ is true for all $$k$$
where $$0 \leq k \leq n$$ then show that $$P(n+1)$$  is true
