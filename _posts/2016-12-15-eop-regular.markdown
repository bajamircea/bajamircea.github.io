---
layout: post
title: 'EOP: Regular types and procedures'
categories: coding eop
---

Short intro into what regular types and procedures are about (as per "Elements of
Programming").

# Regular types

A data type is regular if it has: a default constructor, destructor, copy
and move constructors and assignment, equality and total order **and** they all
behave properly.

By properly I mean things that are easy to expect intuitively like:

- if you have a object and you assign to it, then it's equal to the source
- if you have two objects then they are either equal or not equal
- if you have two objects that are not equal, then one is less than the other

A subtle aspect is that the default constructor only has to initialize enough so
that the object can either be assigned to, or destroyed.

An example of a regular type is `int`.

Not all types are regular. That ranges from almost regular like `float` (for
which all comparisons with `NaN` return `false`) to say a type wrapping a TCP
socket that does not make sense to copy.


# Regular procedures

A procedure/function is regular if it returns the same result when called again
with same inputs.

An example of a regular function is say `fibonacci(n)`.

Again, not all functions are regular. That ranges from a function that receives
a pointer to node in a list and returns the next node (which will return the
same value until the list changes) to say a function that receives an URL and
returns the HTML page content (but the page can change or can fail to reach it).


# The implications

Confusingly the definitions for regular types and regular functions are quite
different. The thing that unifies both is that the consequences are identical.

When dealing with regular types and functions we can re-shuffle things around
to achieve simple/beautiful/elegant/efficient code e.g. we can make a copy of
the data and re-use it later, or see how a [Fibonacci
implementation][fibonacci] can be transformed.

When dealing with irregular types we can't make a copy of the TCP socket, we
can't always cache the contents of a web page (we might need to download it
again at a specific point in the program).

# References

- [Elements of Programming - on amazon.co.uk][eop]

[eop]: http://www.amazon.co.uk/Elements-Programming-Alexander-A-Stepanov/dp/032163537X
[fibonacci]:     {% post_url 2016-12-14-eop-fibonacci %}
