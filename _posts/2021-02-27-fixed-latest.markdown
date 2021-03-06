---
layout: post
title: 'Fixed vs. latest'
categories: software concepts
---

Your software A depends on another piece of software B. Should you build
against a fixed version of B or always get the latest?


Let's look at a specific example. Let's say that we have two source control
repositories for A and B, with Alex and Bob changing, maintaining and
responsible for each respectively.

Alex's component A depends on Bob's component B.

Should Alex configure the build system for A to **take the last** build of B or
should it configure it to get a **fixed known good** build of B? Which option
is the best?


# Latest

Alex and Bob work a new exciting project, they coordinate with each other
constantly.

Alex configures the build system for A to take the last build of B.

![Latest good](/assets/2021-02-27-fixed-latest/01-latest-good.png)

This has the **advantage** that it creates a happy path for getting (presumably
good) changes from B:

- Bob changes B
- Bob rebuilds B
- Alex rebuilds A

Now component A has all new functionality/fixes in B. Alex and Bob are happy,
job done.

However there is the unhappy path:

- Alex changes A
- Alex rebuilds A
- The build of A fails
- Alex is confused, he did not expect the build to fail
- Alex investigates
- It turns out that Bob did a change in B, that latest change in B was
  automatically picked and it breaks the build of A

![Latest bad](/assets/2021-02-27-fixed-latest/02-latest-bad.png)

How much this **disadvantage** is a problem depends on:

- How often it happens
- What's the time lost investigating
- What's the delay of detecting the breaking change: while building A, or much
  Later (if the change is subtle and breaks functionality, but not
  build/existing automated tests)
- How many people are impacted: is it just Alex, or a team of developers that
  have their builds of A fail?
- How quickly Bob can fix the issue


# Fixed

Alex has had enough of component A builds failing when Bob changed component B
without realising (or caring for) the impact of Bob's change.

Alex configures the build system for A to take a specific/fixed build of B that
is first tested and known to be good.

![Fixed good](/assets/2021-02-27-fixed-latest/03-fixed-good.png)

The **advantage** is that Alex has control over when new version of B are
taken. So when Alex takes a new version of B which breaks the build of A, he
knows that the cause has to do with changes in the new version of B.

The **disadvantages** of this approach are that:

- Propagating changes from B to A requires the additional step to change A to
  refer to the newer build of B. The effort required depends on the specifics
  of the build system used
- It creates a maintenance activity to periodically take new versions of B
- When taking a new version of B breaks the build of A there could have done
  many changes to B causing the issue: that will take time investigating


# Lesson

First: there is no solution that is best overall. Each approach has advantages
and disadvantages, which one is taken depends on the context, but **each choice
comes with consequences**.

Second: **the issue generalises for other situations** where a component
depends on another, not just the specific example above. Maybe component B are
binaries produced by a third party or part of the operating system.

Third: **sometimes the problem can be avoided** e.g. if the components are
consolidated in the same source control repository, or for small projects where
Alex and Bob are really a single person, there also options regarding how often
a fixed version is taken.
