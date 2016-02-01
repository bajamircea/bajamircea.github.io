---
layout: post
title: 'Anthropomorphic Design'
categories: coding cpp
---

Anthropomorphic design is an antipattern where developers design software
components as if they were people.


# Description

In his book "Thinking Fast and Slow", Daniel Kahneman comments that by using
"System 1" and "System 2" to describe the way we think he commits the sin of
antropomorphism. "System 1" and "System 2" behave to a certain degree as people
when in reality there is no dirrect mapping to a physical item, e.g. a neuron,
to one of the two systems. He still thinks it helps us undestand how our mind
works, because we are better equiped to think about interactions between people
than to handle abstract concepts.

Anthropomorphic design with regards to software components is when we think of
software components as people. This usually comes together with:

- a common terminology for the components e.g.: the AbcManager, the DceManager,
  the XyzManager
- have a common, heavy runtime layer used to communicate e.g. COM, or message queues
- in addition to their own core functionality, they communicate with their peers


# Example

The Application requires three new components: a DatabaseManager, a
EmailManager and a LogManager. Each component has, to start with, a clear role:
e.g. the DatabaseManager is a data access layer for a database, the
EmailManager sends email and the LogManager writes log entries to a file.

![Original design](/assets/2016-01-08-anthropomorphic-design/01-simple.png)

Over time however the requirements change: the database manager needs to send
an email if the database is full. The DatabaseManager takes a reference to the
EmailManager and uses it to send an email when the database is full.
Requirements change again: the email manager needs to log an entry every time
an email is send, and the logger needs to log to the database in addition to a
log file.

![Anthropomorphic design](/assets/2016-01-08-anthropomorphic-design/02-complex.png)

In the diagram above the DatabaseManager is more like a person: in addition to
doing all that has to do with the database it also talks to/uses the
EmailManager. This is very much like John talking to Paul as part of completing
a task.

# Alternative

The option would have been to refactor the three original entities into more
entities with single responsabilities.

![Refactored design](/assets/2016-01-08-anthropomorphic-design/03-single.png)

The new DatabaseManager only puts the DatabaseLayer and Emailer together. The
new DatabaseLayer only deals with the database. As we're going further away
from an anthropomorphic design we end up with more components and we need more
words to describe the functinality of each component, but each component is
individually simpler.
