---
layout: post
title: 'One, two, some, many, lots'
categories: maths engineering
---

Reiteration of the paradox that despite being able to precisely identify large
numbers, unless they put a particularly unusual effort, people count: one, two,
some, many, lots.


I [mentioned this before][numbers], but decided it's worth it's own article.

# The conjecture

Unless someone makes a particularly unusual effort, maybe using computers,
other tools or peer reviews, people have a simplistic intuition about numbers.
The thresholds that I'm using as an example are approximate, but about right.

- the distinct range: they can have a clear perception of an exact number up
  to about 7, i.e. "zero", "one", "two", "three", "four", five", "six" they are
  all distinct
- the "some" range: between 7 and 12
- the "many" range: between 12 and 40
- the "lots" range: over 40


# The source of the insight

Long time ago I had to investigate why a list in a product has lots of entries.
I picked one such case. It had about 2000 entries. That's a lot, but decided to
go through them and classify them to try figure out what's the underlying
cause. Are certain types of entries more common? What's the cause? In the
process of going through the 2000 entries one by one I soon discovered another
issue.

The list displayed the entries page by page, but pagination was broken and the
first 50 entries were repeated instead of displaying 50 different entries each
time. So in my case, the first 50 entries would have been repeated about 40
times.

And this issue was not reported. Thousands of customers complained by the large
number of entries, but none complained that only 50 are displayed, the rest are
repeats. **No customer complained "Hey, the 51st entry is a repeat of the first,
the 52nd a repeat of the second etc."**

My empirical observation is that somewhere between 20 and 50 our brains stop
having a intuitive perception of precise numbers and use heuristics based on
"there's lots", rather than precise numbers.


# Other supporting evidence

A class of about 30 pupils uses a register. Even with pupils sitting neatly in
rows of benches the teacher does not have a grasp to instantly see that Jack is
missing.

In the movie "Rain man" the character Ray played by Dustin Hoffman involved in
an incident with toothpicks falling on the floor, says "246 total" out of a box
of 250. It turns out that there were 4 left in the box. It's a movie scene
because it's unusual to grasp such numbers.

Daniel Kahneman in his book "Thinking Fast and Slow" mentions the effort
required for calculating "17 x 24". We can do it, it's easier with a pen and
paper rather than mentally, it's easier with a calculator, but we don't have a
precise intuitive expectation of the result. 17 and 24 are already large
numbers (not humongous, but large).


# Where is this useful

In all sorts of ways. One example is when designing user interfaces: question
cases where a list would display large number of entries. E.g. "Export to PDF"
Does not make sense for a table of 1 million entries? Who is going to check
that the entry 492342 is wrong?

[numbers]: {% post_url 2023-04-15-numbers %}

