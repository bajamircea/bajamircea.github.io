---
layout: post
title: 'Computational models'
categories: coding cpp
---

Computational models from mathematics to software engineering


# Mathematical roots of computation models

In a way, what is the Pythagorean theorem but an algorithm to calculate the
root of the sum of two squares?

But the things directly consequential for the way we program today have their
origin in metamathematical questions about the limits of natural numbers
systems, largely in the first half of the 20<sup>th</sup> century.

Kurt Gödel used a model involving primitive recursion to start with. It turns
out that a lot of mathematical functions on natural numbers are primitive
recursive, a scheme briefly described as: they are defined in terms of a
initial value, the successor function (i.e. plus_one), and recursively where
the value of a parameter is one less. So for example `sum(a, b)` is defined in
terms of `sum(a, 0) = a` and `sum(a + 1, b) = sum(a, b) + 1`, similarly for
many other common functions like product, exponentiation, subtraction,
division, reminder etc. A generalisation of the rules of recursion results in
the ability to calculate any function that could be calculated (on natural
numbers).

Alonzo Church used lambda calculus for similar purposes, though there were
initial debates of the equivalence. The Greek letter lambda is used to
disambiguate between defining a function or calling it for particular
arguments.

The debate was settled largely by Alan Turing who in turn started with the
Turing machine model of a state machine that performs simple operations using
symbols on an infinite tape.

Turing showed that the recursion, the lambda calculus and the Turing machine
are equivalent: **once a system is Turing complete, it can simulate a Turing
machine (or equivalents) and can calculate whatever the other system can
calculate as well**.

Note that often in the proofs, for which these mathematical systems were
developed, very very large numbers are involved. Mathematicians were aiming for
easy to understand proofs and, as long as one can imagine the algorithm on how
such numbers would be calculated, they were not concerned with actually
calculating them in practice (e.g. how much paper would be required).


# Programming languages computation models

Programming languages are usually defined against a virtual machine.

Sometimes developers are clearly aware of this such as in the case of Java
running against the Java Virtual Machine (JVM). Same applies to languages like
C#.

C/C++ are also defined in terms of a virtual machine. Often developers are not
aware of this because the C/C++ virtual machine is very similar to the physical
machine: it has data memory (stack and heap), registers etc. This allows for
good efficiency as only little runtime work has to be done to adapt the virtual
one to the physical one. 

These machines (the physical and the virtual ones) have their roots in the
Turing machine, e.g. with the (finite) random access memory (and hard disks) as
a substitute for the infinite tape.

Another major approach is the case where the virtual machine is a chain of
contexts where names are looked up. This has a long tradition that goes all the
way back to Lisp. Lisp embraced the lambda calculus paradigm in a dogmatic way:
everything is a lambda. Obviously functions are lambdas. Recursive function
calls are used to implement `for` loops, the compiler tries to identify a
special type of recursion (tail recursion) and optimise it (to loop rather than
recurse). To implement lambdas properly, the Lisp compiler uses dictionaries to
hold the context of a function, it's these dictionaries that are used to hold
data indirectly in Lisp, instead of providing direct support for data
structures.

Javascript inherited this approach from Lisp via Scheme (practically a Lisp
subset). This is visible in the object creation in Javascript.


# Equivalence and differences

While programming environments do not have infinite resources, there are
parallels to the Turing equivalence. Once a programming language has enough
richness (which practically means most general usage ones), it can do any
calculation that the other ones do. The difference is in efficiency.

Languages that use abstractions closer to the physical machine are more
efficient at runtime (e.g. execution time, memory and CPU usage). It is
possible sometime to compensate for an inefficient language by designing a
solution to work around inefficiencies, e.g. in a reference counted garbage
collected language, like C#, design the program to avoid memory allocations.
Also inherent efficiency of the language can be negated by using an inferior
algorithm.

Programming languages also differ in terms of the development effort required
to solve certain types of problems. The IDE support, the available libraries,
the number of concerns that the developer has to take care of, the ability of
the language to scale in large code bases: they all make a difference on how
long it takes to write and test a program.

There are lots of options and variations on this theme of "it's all the same in
terms of the calculation that is done, but a difference in the resources used
(including time)":
- is it compiled or interpreted?
- even if compiled: what's calculated at compile time vs. what's calculated at
  runtime
- threads and coroutines change the time when the results are available


# Conclusion

**While is true that there are different equivalent computational models,
inspired by mathematical research, which result in different programming
languages choices, equivalence in mathematical sense does not make them
entirely equivalent in efficiency (and there are many measures of
efficiency).**

E.g. doctrinary claiming that "everything is a lambda" is fine if you want to
design a simple to understand mathematical model, but not fine if you want to
ensure that you use a reasonable amount of memory and running time.
