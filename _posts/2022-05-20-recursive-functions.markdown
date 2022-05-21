---
layout: post
title: 'Recursive functions'
categories: maths logic
---

What are recursive functions?


{% include mathjax.html %}

The idea of recursion started in mathematics closely related to induction. This
association can be traced back to Richard Dedekind's "Was sind und was sollen
die Zahlen?" ("The nature and meaning of numbers") (1888), in theorem 126, the
theorem of the definition by induction.

The idea is to define functions (and predicates) using a set of simple rules
that include one where the value for $$n + 1$$ is defined based on it's value
for $$n$$. $$n + 1$$ is expressed as $$n'$$, the successor of $$n$$. When a
function has more than one argument, the rest of arguments are held constant
when this recursion rule is used.

For example Peano style definitions for addition and multiplications look like:

$$
\begin{align}
  & a + 0 = a\\
  & a + b' = (a + b)'\\
  & a \cdot 0 = 0\\
  & a \cdot b' = a \cdot b + a
\end{align}
$$

In both cases a function of two arguments $$f(a, b)$$ is defined using first a
simple rule for when $$b$$ is $$0$$, i.e. for $$f(a, 0)$$, and then a second
rule where the value for $$f(a, b')$$ defined in terms of $$f(a, b)$$, i.e.
with $$a$$ held the same, and the value $$b$$ used for $$b'$$ (i.e. $$b + 1$$).

This style of definition has advantages such that it can be proven that: such a
function exists, that it is unique, that the calculation for a particular value
of the arguments terminates in a finite number of steps.

Many of the commonly used functions (and predicates) in mathematics can be
defined using such definitions: addition, multiplication, exponentiation,
subtraction, less than, factorial, next prime, n-th Fibonacci number.

However it was discovered that if the rules are relaxed, new functions can be
defined that cannot be defined in therms of the simpler ones above, such as the
celebrated Ackerman function:

$$
\begin{align}
  & A(0, n) = n'\\
  & A(m',0) = A(m, 1)\\
  & A(m',n') = A(m, A(m', n))
\end{align}
$$

Notice that while the function $$A$$ is defined in terms of itself, it does not
adhere to the stricter rules where the successor is used only for one argument.

In particular the Ackerman function can be shown that it grows faster than any
of the functions defined using the stricter rules. Around this discovery a
renaming happened: functions defined the stricter rules, having the nice
properties, were renamed as **primitive recursive**, while functions defined by
the more relaxed rules were renamed as **general recursive**.

The advantage of the general recursive functions is that they capture a larger
class of functions, that was shown to be the kind of functions that can be
computed by Turing machines. The disadvantage is that they loose some nice
properties, and simple issues, like the fact that the function is unique or
that the calculation of the function value terminates eventually, have to
proved on a case by case basis, they do not derive from the way the function
was defined.

From mathematics the idea of recursion got into programming, where it can be
used as follows:

{% highlight c++ linenos %}
int factorial(int n) {
  if (n <= 1) return 1;
  return n * factorial(n - 1);
}
{% endhighlight %}

However in this, and many academic examples of recursion in programming like ,
it's [more efficient to implement it using a loop][fib], so recursion is not
encountered that much in practice, often due to the fact that many common
functions are primitive recursive that can be calculated using a bound `for`
loop.

Recursion is also used [as subtle jokes][humor-ref]. For example in some
editions of "The C Programming Language" book by Brian Kernighan and Dennis
Ritchie the index entry on page 269 recursively references itself ("recursion
86, 139, 141, 182, 202, 269").

[fib]:       {% post_url 2020-03-22-fibonacci-experiments %}
[humor-ref]: https://en.wikipedia.org/wiki/Recursion#Recursive_humor
