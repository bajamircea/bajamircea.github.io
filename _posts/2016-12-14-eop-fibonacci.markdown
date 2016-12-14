---
layout: post
title: 'EOP: Implementing Fibonacci'
categories: coding eop
---

Outline of how to implement a function to calculate a value in a Fibonacci
series.

{% include mathjax.html %}

PLEASE DO NOT USE THIS AS AN INTERVIEW QUESTION. IT IS SILLY. BUT I'M NOT GOING
TO TELL YOU EXPLICITLY WHY NOT, JUST IN CASE YOU DECIDE TO IGNORE THE ADVICE.

# Definition

The Fibonacci series is defined by:

$$
\begin{align}
  f(n) = f(n-1) + f(n-2)
\end{align}
$$

and initial values:

$$
\begin{align}
  f(0) = 0\\
  f(1) = 1
\end{align}
$$

# Implementation basics

Let's look at an implementation that calculates the value in a Fibonacci series
for a value $$n >= 0$$, and the complexity with regards to the number of
arithmetic operations required.

The naive implementation using recursion has exponential complexity $$O(e^n)$$.
Most programmers will be able to write a $$O(n)$$ solution using a loop
instead of recursion.

But the problem is solvable with logarithmic complexity $$O(log(n))$$.

To do so, the first observation is that if we represent `f(n)` and `f(n-1)` as a column
vector, we can obtain it from the previous vector using a simple matrix
multiplication (in the general case this is called liner recurrence).

$$
\begin{align}
  \begin{bmatrix}
    f(n)\\
    f(n-1)
  \end{bmatrix}
  =
  \begin{bmatrix}
    1 & 1\\
    1 & 0
  \end{bmatrix}
  \begin{bmatrix}
    f(n-1)\\
    f(n-2)
  \end{bmatrix}
\end{align}
$$

Which leads to:

$$
\begin{align}
  \begin{bmatrix}
    f(n)\\
    f(n-1)
  \end{bmatrix}
  =
  \begin{bmatrix}
    1 & 1\\
    1 & 0
  \end{bmatrix} ^ {n - 1}
  \begin{bmatrix}
    f(1)\\
    f(0)
  \end{bmatrix}
\end{align}
$$

Calculating power can be done in $$O(log(n))$$, because one can calculate power
for `n/2` and adjust for `n` odd.

As a minor improvement the matrix has a certain symmetry, only 2 values out of 4
need to be calculated.

# Details to watch

First of all: is the implementation generic? You can see how a generic
implementation of calculating power of n can be used for a matrix in the case
above, not just for `int`s. For the golden standard on how to achieve this see
[Elements of Programming][eop].

In particular if you really want to calculate Fibonacci, you'll soon want to be
able to calculate it for more digits than what `int` can store. This will lead
to the next problem: what's the complexity of arithmetic operations for such a
type.

# References

- [Elements of Programming - on amazon.co.uk][eop]

[eop]: http://www.amazon.co.uk/Elements-Programming-Alexander-A-Stepanov/dp/032163537X

