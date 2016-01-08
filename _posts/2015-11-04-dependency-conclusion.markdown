---
layout: post
title: 'Dependency injection: conclusion'
categories: coding cpp
---

Summary of the issues around dependency injection discussed in the previous
articles.


# Why use dependency injection

The purpose of the dependency injection technique is to allow us to test
classes that contain some application logic, but depend on other classes to
perform it. To test, we want to substitute the dependencies with mocks where we
can easily reproduce all sorts of edge case scenarios.

Testing a class that has it's dependencies injected becomes mechanical:

- Create the appropriate mocks.
- Setup expectations on the mocks, if your test library allows it.
- Instantiate the class under test and inject the mocks.
- Call the method.
- Assert your expectations on the mocks and object state.

Testing at class level is not a substitute, but it adds to testing at larger
levels.


# Types of classes

I focused mostly on the "middle" classes, the ones that have the dependencies
injected. But there are two more times of participants in this.

On one side we eventually get to the "leaf" classes on which the other depend,
but themselves are not like the "middle" classes and they actually depend on
the environment. They might be:

- Dealing with the environment through some API (e.g. filesystem, databases,
  sockets etc.). When we test them, we also test the APIs they use. It's no
  longer strictly speaking a class unit test, but we might use the same unit
  test framework. We usually need to build additional functionality to alter
  and prod the environment to perform the test.  E.g.  to test some class that
  iterates through the files in a directory, one might also need some separate
  class/function to create a directory and some files.
- Dealing with simple/fundamental types e.g. `int`s. The environment in this
  case is the machine. Sometimes testing them it's as simple as expecting a
  certain binary output for a certain input.

On the other side of the spectrum are classes that act like builders: they
create all the required dependencies, provide them where required, and let them
do their job. I'm not calling them factories. The alternatives are:

- Inject dependencies using code (as shown in the previous posts).
- Use a specialized class/template argument (a injector). That might work.
- Define injection outside code and use some framework to do it. People do it
  Java where the definition is in XML files. Practically it's unmanageable
  outside a handful of classes.

You might use classes more similar to the classic factory pattern when
providing dependent instances is not enough and a class needs to create its own
instances of something.


# What

What to inject is a decision to take on a case by case basis. You don't need
to inject all the member variables. Also don't inject what you can simply
provide as a method argument.


# Interfaces vs. templates

The main differences between interfaces and templates are:

- Runtime impact: the interfaces approach has more runtime impact than
  templates which depending on the application might be anything between
  unacceptable and less than you would think.
- Development effort: currently editors (e.g. intellisense) work better for
  interfaces.

# Constructor vs. setter

Construction injection is where in where you need to provide the dependencies
in order to create the injected class.

Constructor injection makes the class usage clearer: you can't create the class
without providing the dependencies so testing a method is mechanical.

Injection using a setter is where you provide a method to set dependencies
after the object is constructed. It raises question with regards to the
behaviour of the class before the dependencies are injected, on the same lines
of why use `RAII` is better than using some `init` method. Avoid injection
using a setter.

# Skill

Decomposing a problem domain in a subset of classes is a skill. The bad news is
that it's difficult to get it right the first time. The good news is that
through practice one gets better over time.

In particular it's a matter of taste with regards to what's the appropriate
level of granularity:

- Too much decomposition and you get to classes that don't do anything, they
  just pass things to the next layer.
- Too little decomposition and you have classes with complex logic that are
  difficult to test.

It's difficult to find good names. In examples, I've chosen the easy ones from
the physical world. We have a lot of words for objects in the physical word: a
house has a room, the room has a TV, the TV has a remote, the remote has a
button etc. In practice when coding for a new, unfamiliar domain that language
just does not exist. There is no mecanical way to decompose it into classes,
and what looked like a good decomposition at some point, might not look the
same later when we understand the domain differently and/or the requirements
change.
