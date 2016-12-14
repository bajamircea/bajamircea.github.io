---
layout: post
title: "Beautiful maths: Euler's formula"
categories: maths euler
---

Starting with power series and building on derivation, factorials, exponential
function, trigonometry and complex numbers we'll get to Euler's formula; some of
the most beautiful mathematics I've seen coming together.

{% include mathjax.html %}

# Power series

Let's start with powers of $$x$$:

$$
\begin{align}
  x^0~~~x^1~~~x^2~~~x^3~~~...
\end{align}
$$

Obviously:

$$
\begin{align}
  x^0 = 1\\
  x^1 = x
\end{align}
$$

So here's usual way of writing powers of $$x$$:

$$
\begin{align}
  1~~~x~~~x^2~~~x^3~~~...
\end{align}
$$

We can create a function where we multiply each power of $$x$$ by some
coefficient and we add up the infinite series:

$$
\begin{align}
  f(x) = a_0 + a_1 x + a_2 x^2 + a_3 x^3 + ...
\end{align}
$$


# Derivations of a power series

So now let's look at the derivations for $$f(x)$$:

$$
\begin{align}
  f'(x) &= a_1 + 2~a_2 x + 3~a_3 x^2 + 4~a_4 x^3 + ...\\
  f''(x) &= 2~a_2 + 2~3~a_3 x + 3~4~a_4 x^2 + 4~5~a_5 x^3 +...\\
  f'''(x) &= 2~3~a_3 + 2~3~4~a_4 x + 3~4~5~a_5 x^2 + ...\\
  ...
\end{align}
$$

If we choose $$x = 0$$ then all the terms except the constant at the front go
away:

$$
\begin{align}
  f(0) &= a_0\\
  f'(0) &= a_1\\
  f''(0) &= 2~a_2 = 2!~a_2\\
  f'''(0) &= 2~3~a_3 = 3!~a_3\\
  ...
\end{align}
$$

And in general because $$2~3~4~...~n$$ is $$n~factorial$$ written as $$n!$$:

$$
\begin{align}
  n^{\text{th}}~derivative~of~f(0) &= n!~a_n
\end{align}
$$

One useful fact is that for two functions $$g$$ and $$h$$:

$$
\begin{align}
  \left\{\exists x_0~|~n^{\text{th}}~derivative~of~g(x_0) =
  n^{\text{th}}~derivative~of~h(x_0)~,~\forall n >=
  0\right\}
\end{align}
$$

then $$g$$ and $$h$$ are equal for all $$x$$.

So then we could pick some function and then choose the coefficients $$a_0,
a_1, a_2, a_3, ...$$ so that we have equality with that function for $$x = 0$$.

# Exponential function as a power series

In particular let's pick $$e^x$$ for which we know that all its derivatives
are equal (i.e. $$e^x$$)

$$
\begin{align}
  (e^x)' &= e^x\\
  (e^x)'' &= e^x\\
  (e^x)''' &= e^x\\
  ...
\end{align}
$$

We also know that $$e^0 = 1$$:

$$
\begin{align}
  e^0 &= 1\\
  (e^0)' = e^0 &= 1\\
  (e^0)'' = e^0 &= 1\\
  (e^0)''' = e^0 &= 1\\
  ...
\end{align}
$$

To express $$e^x$$ as a power series we need to choose the coefficients $$a_0,
a_1, a_2, a_3, ...$$ for our power series so that:

$$
\begin{align}
  1 &= a_0\\
  1 &= a_1\\
  1 &= 2!~a_2\\
  1 &= 3!~a_3\\
  ...
\end{align}
$$

which leads to:

$$
\begin{align}
  e^x = 1 + x + \frac{1}{2!}x^2 + \frac{1}{3!}x^3 + ...
\end{align}
$$

# Sine as a power series

Let's pick another function: $$sin(x)$$. The derivatives of $$sin(x)$$ are:

$$
\begin{align}
  (sin(x))' &= cos(x)\\
  (sin(x))'' = (cos(x))' &= -sin(x)\\
  (sin(x))''' = (-sin(x))' &= -cos(x)\\
  (sin(x))'''' = (-cos(x))' &= sin(x)\\
  ...
\end{align}
$$

For $$x = 0$$ the values are:

$$
\begin{align}
  sin(0) &= 0\\
  (sin(0))' = cos(0) &= 1\\
  (sin(0))'' = -sin(0) &= 0\\
  (sin(0))''' = -cos(0) &= -1\\
  (sin(0))'''' = sin(0) &= 0\\
  ...
\end{align}
$$

To express $$sin(x)$$ as a power series we need to choose the coefficients $$a_0,
a_1, a_2, a_3, ...$$ for our power series so that:

$$
\begin{align}
  0 &= a_0\\
  1 &= a_1\\
  0 &= 2!~a_2\\
  -1 &= 3!~a_3\\
  0 &= 4!~a_3\\
  ...
\end{align}
$$

which leads to:

$$
\begin{align}
  sin(x) = x - \frac{1}{3!}x^3 + \frac{1}{5!}x^5 - \frac{1}{7!}x^7 + ...
\end{align}
$$

# Cosine as a power series

The relative of $$sin(x)$$ is $$cos(x)$$. Its derivatives are:

$$
\begin{align}
  (cos(x))' &= -sin(x)\\
  (cos(x))'' = (-sin(x))' &= -cos(x)\\
  (cos(x))''' = (-cos(x))' &= sin(x)\\
  (cos(x))'''' = (sin(x))' &= cos(x)\\
  ...
\end{align}
$$

For $$x = 0$$ the values are:

$$
\begin{align}
  cos(0) &= 1\\
  (cos(0))' = -sin(0) &= 0\\
  (cos(0))'' = -cos(0) &= -1\\
  (cos(0))''' = sin(0) &= 0\\
  (cos(0))'''' = cos(0) &= 1\\
  ...
\end{align}
$$

To express $$cos(x)$$ as a power series we need to choose the coefficients $$a_0,
a_1, a_2, a_3, ...$$ for our power series so that:

$$
\begin{align}
  1 &= a_0\\
  0 &= a_1\\
  -1 &= 2!~a_2\\
  0 &= 3!~a_3\\
  1 &= 4!~a_3\\
  ...
\end{align}
$$

which leads to:

$$
\begin{align}
  cos(x) = 1 - \frac{1}{2!}x^2 + \frac{1}{4!}x^4 - \frac{1}{6!}x^6 + ...
\end{align}
$$

# Euler's formula

Remember that in complex numbers we have the imaginary number for which its
powers are:

$$
\begin{align}
  i^0 &= 1\\
  i^1 &= i\\
  i^2 &= -1\\
  i^3 &= -i\\
  i^4 &= 1\\
  ...
\end{align}
$$

So going back to $$e^x$$, what if we use an (complex) imaginary $$ix$$ we get:

$$
\begin{align}
  e^{\text{ix}} &= 1 + ix + \frac{1}{2!}(ix)^2 + \frac{1}{3!}(ix)^3 + ...\\
  &= 1 + ix - \frac{1}{2!}x^2 - i\frac{1}{3!}x^3 + ...\\
  &= (1 - \frac{1}{2!}x^2 + ...) + i( x - \frac{1}{3!}x^3 + ...)
\end{align}
$$

which lead to Euler's formula:

$$
\begin{align}
  e^{\text{ix}} &= cos(x) + i~sin(x)
\end{align}
$$

# References

- [Gilbert Strang: Power Series/Euler's Great Formula | MIT Highlights of
  Calculus][gs-psef]

[gs-psef]: https://www.youtube.com/watch?v=N4ceWhmXxcs

