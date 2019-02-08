---
layout: post
title: 'Premature optimisation - reading notes'
categories: review book
---

Reading notes on Knuth's article


# Introduction

These are my reading notes on Knuth's article with the famous quote that
"premature optimisation is the root of all evil".

It turns out that the article is full of gems that include "people have a
natural tendency to set up all easily understood quantitative goal [...]
instead of working directly for a qualitative goal", and examples on how small
variations on simple algorithm lead to very different solutions, such as the
faster linear find with a sentinel on a mutable range compared with the one
operating on a const range.

The article was published in 1974 in Computing Surveys, and the main focus is
on looking at `go to` as a language construct. The article has about 40 pages,
the page numbers, such as "[p263]", refer to the page number in the
publication.


# Notes

- "then we will be almost certain that these programs cannot lead us into any
  trouble, but of course we won't be able to solve many problems." [p263]
  - This comment was made in the context of suggestions to ban all unsafe
    features in programming languages
  - It is as old as ever that there is often a compromise between safety and
    performance

- "And ouch, what subscript checking does to the inner loop execution times!"
  [p269]
  - Compiler generated bounds-checking adds to safety, but reduced performance.
    This is an example of compromise between safety and performance. I've
    experienced the performance implications of checked iterators in Visual
    Studio

- "I do consider assignment statements and pointer variables to be among
  computer science's "most valuable treasures!"" [p263].
  - Related to the whole discussion about C++ having the capability to use
    pointer
  - But also notice the assignment, this is related to regularity of a type,
    which includes the ability to assign

- "Experience has shown ... that most of the running time in non-IO-bound
  programs is concentrated in about 3% of the source text. We often see a short
  inner loop whose speed governs the overall program speed to a remarkable
  degree; speeding up the inner loop by 10% speeds up everything by almost 10%.
  ... I can then afford to be less efficient in the other parts of my programs,
  which therefore are more readable and more easily written and debugged."
  [p267]
  - This is the basis for the statement about premature optimisation.  What I
    can add is that sometimes significant code restructuring is required to
    make performance gains possible

- "In established engineering disciplines a 12% improvement, easily obtained,
  is never considered marginal; and I believe the same viewpoint should prevail
  in software engineering. Of course I wouldn't bother making such
  optimizations on a one-shot job, but when it's a question of preparing
  quality programs, I don't want to restrict myself to tools that deny me such
  efficiencies." [p268]
  - Improving performance has a development cost. It should be done based on
    return on investment.

- "We should forget about small efficiencies, say about 97% of the time:
  premature optimization is the root of all evil. Yet we should not pass up our
  opportunities in that critical 3%." [p268]
  - This is the context of the famous quote

- "It is often a mistake to make a priori judgements about what parts of a
  program are really critical, since the universal experience of programmers
  who have been using measurement tools has been that their intuitive guesses
  fails"  [p268]
  - I think the issue is more of the programmer knowing what he/she really
    knows. Skilled expert intuition is still a great tool.

- Example 2 p267 uses a find where it sets the searched value one past the last
  of the sequence so that value is always found, and the test in the inner loop
  for the end of sequence can be eliminated.
  - The unexpected behaviour is that it mutates the sequence for a search, it's
    not const in this scenario, therefore it's not thread safe/compatbile with
    concurrent usage from multiple threads without separate additional locking
  - Another observation is that the best implementation varies quite a lot
    based on different choices made, such as: does it need to be thread
    safe/compatible?
  - However note that is trick for improving performance was knows since quite
    long time ago

- some of discussions on p274 with regards to program equivalence (other than
  efficiency), between languages that use `go to` and others that use different
  constructs (e.g. loop and if/else blocks only). He quotes a Böhm and Jacopini
  paper for example.
  - I'm confused that it gives more convoluted explanation as to why using `go
    to` is equivalent to the other constructs when one can derive that by
    showing that both approaches are Turing complete and therefore they are
    equivalent (other than the efficiency).
  - But on the other side this is part of the conclusion of this paper, that
    `go to` alows sometimes efficiency improvements not obtainable by some
    other constructs though other constructs are often better than `go to`
    [p294]

- "people have a natural tendency to set up all easily understood quantitative
  goal [...]  instead of working directly for a qualitative goal" [p275]
  - That's another gem of the paper, widely applicable to a lot of contexts
  - The full context is: "But there has been far too much emphasis on go to
    elimination instead of on the really important issues; people have a
    natural tendency to set up all easily understood quantitative goal like the
    abolition of jumps, instead of working directly for a qualitative goal like
    good program structure. In a similar way, many people have set up "zero
    population growth" as a goal to be achieved, when they really desire living
    conditions that are much harder to quantify."

- code like the one on p277:
```
  for i := 1 step 1 until m do
    if A[i] = x then found(i) fi;
  m := m + 1; A[m] := x; found(m);
```
  - There `found` is a label-ish language construct
  - Today we would return after calling a function called `found`
   - And that `return` is a equivalent way of handling `go to`s in this case
   - And that was know to Knuth at the time because he later says: "go to
     statements can always be eliminated by declaring suitable procedures, each
     of which calls another as its last action." [p281]

- "I have always felt that the transformation from recursion to iteration is
  one of the most fundamental concepts of computer science, and that a student
  should learn it at about the time he is studying data structures." [p281]
  - Elements of Programming by Alex Stepanov spends considerable time on this
    topic (e.g. on implementing a generic `power` function).
  - also Elements of Programming includes later the same topic of iterating
    through a tree which is one of the examples where it also uses `goto`
    statements.

- Quoting and agreeing with Dijkstra: ""For what program structures can we give
  correctness proofs without undue labour, even if the programs get large?" By
  correctness proofs he explained that he does not mean formal derivations from
  axioms, he means any sort of proof (formal or informal) that is "sufficiently
  convincing"; and a proof really means an understanding. We understand complex
  things by systematically breaking them into successively simpler parts and
  understanding how these parts fit together locally." [p291]
  - That is related to the consequence from Turing's paper that it might in
    general be impossible to show a program is correct, but one can construct a
    program in such a way to be able to show it's correct.

- Quoting and agreeing with Dijkstra: "I feel somewhat guilty when I have
  suggested that the distinction or introduction of "different levels of
  abstraction" allow you to think about only one level at a time, ignoring
  completely the other levels. This is not true." [p292]
  - An aspect of this is functions having expectations about the input (e.g.
    type and values) e.g. `lower_bound` expects the input range is partitioned
    by the value searched. These kind of concerns might cross a few levels.


# Reference

Donald E. Knuth: Structured Programming with go to Statements<br/>
Computing Surveys, Vol. 6, No. 4, December 1974
