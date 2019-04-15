---
layout: post
title: 'The limits of TDD'
categories: coding tools
---

TDD is a useful tool to have in programming. But it has limits.


Robert C. Martin aka. Uncle Bob of 'Clean coder', Agile Manifesto and TDD fame
was in town last week, and I was lucky to attend his talk at the local .NET
group. He was in great form, full of energy. The talk covered the evolution of
computing from 1940s to present like the hardware, the demographics of
programmers and development methodologies. In the talk he only touched briefly
directly on TDD.


# The case for TDD as a routine

Early in the talk he told a story about the people copying the Bible in the
ancient times. They had precise habits about various issues: the parchment had
to be made in a particular way, the ink had to be made in a particular way, the
parchment had to have a particular size.

When they finished copying a page, they would then check for correctness. They
would count every letter in the original, check it matches the count in the
copy. They would count the words, and paragraphs, and check the copy against
the original. They would also check the words at the beginning of every line,
check they match, then the words at the end of every line, then the words in
the middle of every line. And if they would find a mistake, they were allowed
to fix a small number of mistakes. But if they did too many mistakes, that
would render the copy invalid, and they would have to start again. The bad
copies were not destroyed, but stored in jars and put into caves, and this is
how ironically some of these manuscripts survived and become available to us.

The other routine they had was related to writing the word God. Before writing
it, the copyist would stop, wash himself properly. Then he would write the word
God. Then he would stop, wash himself properly again. Then he would continue
with the remaining text.

Towards the end of the talk Robert Martin gets to TDD and makes the argument
that, similar to the Bible copyist, other professions have routines. The
accountants use double-entry bookkeeping: they enter a number on one side, they
enter the same number on the other side, they add the sides and check that the
difference is zero; then repeat.

Therefore the programmers need the routine of the TDD, where you write the
failing test, you write the code that makes the test pass; then repeat, and
that is a good thing.


# The case against

TDD is suited for some situations like relative well understood contexts where
the programming tasks are more alike than they are different. In those contexts
is helps with regression testing and maintenance. The poster example is when an
issue is reported, the developer could write a failing test that demonstrates
the bug, then fix the bug, and use the passing test as a proof that the bug was
fixed. In those contexts the activity is more like the checking for correctness
ritual of the Bible copyists.

But other situations are better approached with questions like: "what's the
problem we try to solve?", "how would a solution look like?". The case against
TDD is best captured by this approximate quote on Sean Parent:

> Testing if a sequence is sorted gives no insight on how to implement sort.

For certain contexts, overly focusing on a TDD ritual is more like the washing
routine of the Bible copyists.

Robert Martin is right that people like routines. But I think it's borderline
immoral to encourage the likeness of routines as a substitute for critical
thinking.

Even for situations where TDD is used, it's best to spend effort on thinking
about the functionality that a component should achieve, it's role in the
greater picture, and what a good name for that component would be, before
writing a test trying to construct a not-yet-implemented component just to a
achieve a red-green routine.

