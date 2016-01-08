---
layout: post
title: 'Software Engineering Missjudgements'
categories: coding cpp
---

This is a take on Charlie Munger's collection of human missjudgements.

# Introduction

Many years ago I listened to one of [Charlie Munger][Charlie_Munger]'s speeches
on the psychology of human missjudgements and I found it fascinating. The
basics of it are simple: observe the irrational things people do, make a list
of that, avoid behaving like this yourself. There is more theoretical
background in the works of Kahneman & Tversky and Cialdiny for example.

The difficult part is that althought the principles are simple, you have to
work out the details yourself on a situation by situation basis, including what
to actually positively do, not just what not to do.

This is my take on a list of software product development missjudgements. I'm
not trying to have a minimal set, but one that is easy to apply to real
situations in software development.

- Execute to original plan tendency
- Over-engineering tendency
- Bias towards precission
- Short-termism tendency
- Overoptimism tendency

- Ignoring productivity tendency
- Confusing busy with productive
- Bad time accounting

- Ignore the order-of-magnitude effect
- Exageration of work done tendency
- Minimizing code change tendency

- Question substitution tendency
- Authority bias tendency
- Social proof tendency
- Wrong question tendency
- Form over substance tendency

- Using the wrong tools
- Using the wrong technology
- Using obsolete programming idioms
- Testing at the wrong level

- Lollapalooza effect


# Execute to original plan tendency

This is when a team commits to a project plan to develop some product
functionality, and as time goes along things turn out to be different from the
original plan. The tendency is for the team to continue with the original plan
instead of changing course and deliver something different (but better) based
on what is learned along. The effect of this tendency is for the project to run
late and deliver less value.


# Over-engineering tendency

This is when a team or a individual is faced with two options to implement some
functionality. There is a tendency to choose the one that is more complex
(watch for buzzword count) even if it's pointed out that it is going to take
more time, and the functionality benefits are questionable/marginal. This is
not about avoiding all over-engineering, to do so you incur the cost of
evaluating the infinite space of all the other options.


# Bias towards precission

This is when teams start a project by spending two weeks in January to plan it.
They decompose the tasks to at most 3 days of work each ("if it's more than 5,
you did not undestand the work enough"). By adding all the tasks, divided by
the number of "resources" (accounting for holidays and sickness) the team
commits to a completion date: EOB Tuesday 23rd of April. The project actually
completes in August. This is the precission vs. accuracy story.


# Short-termism tendency

This is when to solve a problem there are two options: use a library or
hand-craft code. The library has a barrier of entry e.g. it needs to be
included in the build system  which would take say 1 day (but the usage is
trivial, say 15 minutes). To hand craft the code takes say 1/2 day. We're under
time pressure, we choose the locally cheaper option.  Over the course of a
month we take the same decision 4 times.


# Overoptimism tendency

This is when to estimate a task we can't think of what it can get wrong, so we
underestimate by estimating for the best case when nothing goes wrong. This can
be addressed by using historical data on how long similar tasks took in the
past. The other example is when we hope we'll accelerate towards the end of a
project. If 50% of the project scope took 4 months, something has to
fundamentally change to do the remaining 50% in 2 months.


# Ignoring productivity tendency

It is a tautology: to deliver more you need to be more productive/efficient.
Especially for activities that have a repeatable patern (e.g. a sequence like:
change code, build, write test, build, run test, commit, deploy, mark ticket
done), it is worthwhile improving the amount of time to complete a cycle.

For this tendency there is not necesarily a single punctual moment in time. For
example the team uses a 10 year old compiler, the vendor published about 5
versions in the meantime, they are available at no additional cost and yet the
team did not find time in a decade to upgrade the compiler and reap the
benefits of better compiler messages, better libraries etc.


# Confusing busy with productive

This is when a team or individual is running around, doing things, but at the
end of the larger period of time, e.g. weeks to months, the net result is to
have just about stood still.


# Bad time accounting

This is when at the beginning of the project the team raises tickets for the
work to be done. Soon the actual work diverges from the tickets for good
reasons. The tickets that the team works on, do not reflect actual work done.
In the glorious end everyone scrambles to fix bugs or "release activities" with
no tickets at all. With all this ticketing in place there is no real insight as
to where the time has actually gone.


# Ignore the order-of-magnitude effect

There are significant additional effort requirements between:

- code written vs. it compiles
- it compiles vs. it runs
- it runs on a machine vs. it runs on several machines
- it handles a speciffic input vs. it handles malicious input
- it runs on a OS vs. it is multi-platform
- single-threaded vs. multi-threaded
- synchronous vs. asynchronous
- console vs. GUI
- single-machine vs. distributed
- fix bug in small vs. large program
- focused development time vs. interrupted
- maintain one version of the code vs. maintain multiple product versions or
  code branches

Each increment requires if not a tenfold, at least double effort, and
combinations compound almost exponentially.


# Exageration of work done tendency

This is when a developer says "I've done it, it works, closed the ticket, ship
it, give me something else to do", but uppon closer inspection there is
discrepancy between the claim and the facts e.g.:

- the code is written and the developer had a few manual tests on his machine
- the task was 'Product does X' and he only wrote a library to do X, but the
  library is not invoked, hence the product does not really do X
- the code quality means it's going to be a maintenance drag


# Minimizing code change tendency

This is when code changes are done in such a way to minimize code diffs. To
pick one example it might mean that to achive some similar functionality to
existing code, the developer just copy pastes existing code and changes the new
copy in a few places instead of extracting the common parts. This is based on
the thinking that changing existing code has the risk of introducing bugs in
existing functionality. Over time this risk aversion makes it certain that code
is difficult to maintain (e.g. in the example above changes and bugs have to be
fixed in two places).


# Question substitution tendency

This happens when to answer a question the brains substitute it with another
question that is easier to answer e.g.:

- Question: How long will it take to implement functionality X? It is required
  for Milestone 1 in May.
- Substitute question: How many months thare are until May?
- Answer: Four months.

- Question: I don't understand the logic around operation X. What's the
  reasoning around how it was implemented?
- Substitute question: Who told us to implement operation X?
- Answer: The prodct manager asked for it to be implemented this way.


# Authority bias tendency

This is where there are several approaches to a problem (e.g. related to
architecture, security, test) each with it's pros and cons, and decission is
taken not by judging the facts/arguments/reaons, but by accepting the decission
of the person with the job title matching the domain (e.g. the Architect, the
Security Expert, the Test Manager).


# Social proof tendency

This is where there are several approaches to a problem each with it's pros and
cons, and decission is taken not by judging the facts/arguments/reaons, but by
accepting the decission of the majority of the team members/participants to the
meeting.


# Wrong question tendency

This is when the question asked is already wrong. E.g. "Can it be done?".
Usually most of the things in software can be done. The better questions are
"Should we do it?" "Is there a better/faster alternative?"


# Form over substance tendency

This is when the team adopts processes and substitutes them for reasoning. This
is when the team is commited on a release criteria of at most 3 high impact
defects, 5 medium impact defects and 10 low impact defects. At the end of the
project there are 0 high and medium, but 11 low impact defects. Endless
meetings required to debate the issue.


# Using the wrong tools

The classical example is a ticketing/bug tracking system. Clearly the previous
version that he company uses became unusable so a comitee selected from
different department representatives is formed to choose a new one. A collated
list of different ticketing/bug tracking requirements is drafted. A new vendor
is chosen who can tick all the boxes. Their product can do anything and has
beautifull reports, just add one more custom field for each usage scenario.
Over time the system becomes unusable because for example more and more custom
fields are added. To raise a ticket/bug, you need to fill 20 fields.


# Using the wrong technology

This is when the wrong technology is used. It used to be the right technology 5
years ago, there are better alternatives now, but the product continues to be
developed using the old one.


# Using obsolete programming idioms

This is when new code is written in C++, using C language idioms.


# Testing at the wrong level

This is when significant effort is spend in testing with little reflection if
there are better ways of achieveng the same level of quality. E.g. manually
testing a input field on a form for a variety of invalid input, instead of
manually testing it for a small set of invalid input to ensure that the
validation code is invoked and unit testing the intput field validation code.


# Lollapalooza effect

Rarely one of issues above comes in isolation, and the effects are multiplied
by more than one coming together. For more on that: see what Charlie Munger has
to say.


# Conclussion

Each missjudgement has a reason: the wrong behaviour is actually useful. To
take just the first tendecy as an example "Execute to original plan tendency":
we like it when a team  delivers to it's commitments. It is only a problem when
we learn that the original plan was wrong and we fail to react to that and
change course.

When things are bad in a project, usually there is no single major cause, but a
tricke of smaller issues, which individually don't seem a big deal (the
lollapalooza effect).

There is a negative phrasing in the issues above (i.e. avoid/don't do). But one
can work out the positive actions to take to reverse the situation.


[Charlie_Munger]:      https://en.wikipedia.org/wiki/Charlie_Munger

