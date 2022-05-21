---
layout: post
title: 'Deduction Theorem - A implies A'
categories: maths logic
---

Sample proof that A implies A

{% include mathjax.html %}

Recollect that in our sample formal system we have the following postulates:
- Axiom schema A1: $$A \to (B \to A)$$
- Axiom schema A2: $$(B \to (C \to D)) \to ((B \to C) \to (B \to D))$$
- Rule of inference MP: $$A, A \to B \over B$$

Note that we'll only use the postulates above, in particular note that we won't
use the axiom schema A3 for propositional calculus.

The proof schema goes as follows:
1. $$(A \to ((A \to A) \to A)) \to ((A \to (A \to A)) \to (A \to A))$$ : by axiom schema A2 with
$$B$$ and $$D$$ both being $$A$$ while $$C$$ is "$$A \to A$$"
2. $$A \to ((A \to A) \to A)$$ : by axiom schema A1 with $$A$$ being $$A$$ and
$$B$$ being "$$A \to A$$"
3. $$(A \to (A \to A)) \to (A \to A)$$ : by MP using 2 and 1 as premises
4. $$A \to (A \to A)$$ : by axiom schema A1 with $$A$$ and $$B$$ being $$A$$
5. $$A \to A$$ : by MP using 4 and 3 as premises

So we say that we have shown that $$\vdash A \to A$$, that is there is a
deduction that $$A \to A$$ without using any assumptions, only the postulates.

Note that above we have a proof schema where we can take any formula for A
(similar to axiom schemas). Taking $$0 = 0$$ as $$A$$ we can use the proof
schema above to prove $$(0 = 0) \to (0 = 0)$$. Taking $$\lnot(0 = 0)$$ as $$A$$
we can do the same for $$\lnot(0 = 0) \to \lnot(0 = 0)$$.
