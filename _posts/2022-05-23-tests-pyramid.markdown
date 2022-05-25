---
layout: post
title: 'Tests pyramid'
categories: coding cpp
---

Because of the cost versus reward, it makes sense to have a few system tests,
some component tests and lots of unit tests.


# Test levels

When you develop a product of non trivial complexity, it has to be tested. Some
manual testing is required, but for cost effectiveness most tests are
automated. The automated tests can be performed at different levels.

<div align="center">
{% include assets/2022-05-23-tests-pyramid/01-pyramid.svg %}
</div>

The higher level tests are **system tests**. They are done using the whole
installed/running product stack: you would use a real database, a real
web server and a real browser. Their advantage is that they returns results
that directly relate to the way a user would experience the system and cover a
large surface area of the code and sub-components. One disadvantage is that it
takes a lot of time and resources to do the setup before each test and to tear
down (restore the state to a known one) after each test. Another disadvantage
is that when a test fails, there could be multiple reasons for the failure and
that takes time to investigate.

In between there might be **component tests**. They test a part of the whole
system.

At the opposite end there are low level **unit tests**. They test a small unit
of code, e.g. the functions and classes of a pair of `.h` and `.cpp` files.
Each test covers a smaller area of code, but this has advantages.  Failures are
easy to investigate: there is not much code that could cause the failure. Each
test takes little to setup and tear down. It is possible to set up scenarios
that would be prohibitively expensive at a higher level.


# Cost versus reward

The amount of tests and the area they cover are driven by cost versus reward
decisions.

Unit tests are quite cost effective, you'll want to have lots of them. You
might not cover everything, don't write silly trivial tests either, but you
want to at least segregate important or complex computations and decisions in
areas that are covered by unit tests. Also you want to cover scenarios that are
difficult to reproduce at the higher level.

You will still want to have a few system tests, to at least cover the most
important scenarios of your application. But having more system tests than unit
tests results in badly allocated costs. The reality is that tests fail from
time to time. For a system test, e.g. if the test makes a HTTPS request and
that fails, there could be many reasons: it could be a physical network error,
it could be that the database service crashed, it could be a coding error in
many parts of the product. A day later you discover that the HTTPS certificate
used in the test environment expired. You fix this, but it was not a real issue
that actually made the product better. Multiply this with many tests, just
keeping it up and running will take valuable time from other activities.

This is what leads to the pyramid where it makes sense to have a few system
tests, some component tests and lots of unit tests.

