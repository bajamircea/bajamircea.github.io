---
layout: post
title: 'Bayes'' theorem for the layman'
categories: maths statistics
---

Bayes' theorem: what it is, a simple example, and a counter-intuitive example
that demonstrates the base rate fallacy.

{% include mathjax.html %}

# Theorem

Let's say we have two events $$A$$ and $$B$$. We write that the probability of
the event $$A$$ is $$P(A)$$.

Bayes' theorem states that:

$$
\begin{align}
  P(A \mid B) = \frac{P(A)~P(B \mid A)}{P(B)}
\end{align}
$$

The above looks complicated, so let's go back a bit.

If the events are independent, the probability to have both events $$A$$ and
$$B$$ is:

$$
\begin{align}
  P(A \cap B) = P(A)~P(B)
\end{align}
$$

For example with two dice, the probability to get a double six is
$$\frac{1}{36}$$, which is $$\frac{1}6$$ (the probability to get a 6 on the
first dice) multiplied with $$\frac{1}6$$ (the probability to get a 6 on the
second dice).

However if the two events are not independent, then given the notation $$P(A
\mid B)$$ for the event of $$A$$ given that we know $$B$$, then there are two
ways of getting at the same result:

$$
\begin{align}
  P(A \cap B) &= P(B)~P(A \mid B)\\
              &= P(A)~P(B \mid A)
\end{align}
$$

The equality leads directly to Bayes' theorem above.

Another useful observation is that given the event $$not~A$$ written
as $$\neg A$$:

$$
\begin{align}
  P(B) = P(A)~P(B \mid A) + P(\neg A)~P(B \mid \neg A)
\end{align}
$$

Which leads to the often useful:

$$
\begin{align}
  P(A \mid B) = \frac{P(A)~P(B \mid A)}{P(A)~P(B \mid A) + P(\neg A)~P(B \mid
  \neg A)}
\end{align}
$$


# Simple example

Let's say we have two jars:

- one has 6 red balls and 4 blue balls
- the second has 3 red balls and 3 blue balls

You pick at random a ball from a random jar: it is a red ball.

What's the probability that you picked it from the one with 6 red balls?

The intuition says that it should be a number greater than 50%. Bayes' theorem
gives us the exact answer.

With the conventions:

- event A is the event that we choose the ball from the jar with 6 balls
- event B is the event that we choose a red ball

Then given we have a red ball, the chance it came from the jar with 6 red balls
is:

$$
\begin{align}
  P(A \mid B) &= \frac{P(A)~P(B \mid A)}{P(A)~P(B \mid A) + P(\neg A)~P(B \mid
  \neg A)}\\
  &= \frac{0.5 * 0.6}{0.5 * 0.6 + 0.5 * 0.5}\\
  &= 0.545454...\\
  &\approx 54.55\%
\end{align}
$$


# Base rate fallacy

Say we have have drug test that is 99% correct (i.e. out of 100 results, one is
wrong). Say an individual tests positive. What's the probability he is a user
of the drug?

The intuition says that the answer is 99%.

In this case the intuition is wrong. Bayes' theorem helps us ask the relevant
questions to get the correct answer.

With the conventions:

- event A is the event that the individual is a user of the drug
- event B is the event that the individual tests positive

Then to apply Bayes' theorem we need to ask questions like: what's the
probability $$P(A)$$ that an individual is a user of the drug? If the answer is
that in average out of 1000 people only 2 are users that's 0.2%, then we have
the problem that if we test 1000 people then we'll have positive results for
10, but only 2 are users, so the answer should be closer to 20%.

The precise answer is:

$$
\begin{align}
  P(A \mid B) &= \frac{P(A)~P(B \mid A)}{P(A)~P(B \mid A) + P(\neg A)~P(B \mid
  \neg A)}\\
  &= \frac{0.002 * 0.99}{0.002 * 0.99 + 0.998 * 0.01}\\
  &= 0.165551...\\
  &\approx 17\%
\end{align}
$$

The actual result of 17% is quite far from the wrong initial intuitive answer
of 99%. This is because the intuition fails to take into account the base rate
(the base rate fallacy).
