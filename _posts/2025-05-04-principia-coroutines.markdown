---
layout: post
title: 'Principia coroutines'
categories: coding cpp
---

Index of articles exploring C++ coroutines


What would it mean to create your own coroutine framework?

This series of articles/presentations is reviving an attempt to explore C++
coroutines that I worked on and off from 2023 onwards. It is a learning
journey that covers interesting, but less common parts of C++.

> Ivan: "This is not the C++ I'm used to see"

There are multiple goals. There is the indirect goal of generally learning
about concurrency, about C++, but also specifically answering the question
"what would it take to write a library that can do concurrency in C++,
potentially involving coroutines"?

WORK IN PROGRESS

# Presentations

- [Problem domain](/presentations/2025-05-06-coro-problem-domain.html)
- [Mechanics](/presentations/2025-05-11-coro-mechanics.html)
- [Synthetic coroutine](/presentations/2025-05-13-synthetic-coroutine.html)
- [Generator](/presentations/2025-05-20-generator.html)
- [Lazy task](/presentations/2025-05-24-lazy-task.html)
- [Intrusive heap](/presentations/2025-05-15-intrusive-heap.html)
- [Concurency threading models](/presentations/2025-05-28-threading-models.html)

<div align="center">
{% include assets/2025-05-06-cpp-coroutines/00-cover.svg %}
</div>


# Bibliography

- [spec N4775](https://www.open-std.org/jtc1/sc22/wg21/docs/papers/2018/n4775.pdf):
relatively short, readable, but background info required
- [Lewis Baker's posts](https://lewissbaker.github.io/): long, not up to
date, but really good background info required to understand coroutines
- [Nathaniel J. Smith: Notes on structured concurrency, or: Go statement considered harmful](https://vorpus.org/blog/notes-on-structured-concurrency-or-go-statement-considered-harmful/)
- [C++ Coroutines at Scale - Implementation Choices at Google - Aaron Jacobs - C++Now 2024](https://www.youtube.com/watch?v=k-A12dpMYHo)
- [C++ Coroutines and Structured Concurrency in Practice - Dmitry Prokoptsev - C++Now 2024](https://www.youtube.com/watch?v=sWeOIS14Myg)
- [Structured Concurrency: Writing Safer Concurrent Code with Coroutines... - Lewis Baker - CppCon 2019](https://www.youtube.com/watch?v=1Wy5sq3s2rg)
- [CppCon 2018: G. Nishanov “Nano-coroutines to the Rescue! (Using Coroutines TS, of Course)](https://www.youtube.com/watch?v=j9tlJAqMV7U)
- [Structured Networking in C++ - Dietmar Kühl - CppCon 2022](https://www.youtube.com/watch?v=XaNajUp-sGY)
- [P2300R10 std::execution](https://www.open-std.org/jtc1/sc22/wg21/docs/papers/2024/p2300r10.html)
- [P2175R0: Composable cancellation for sender-based async operations](https://www.open-std.org/jtc1/sc22/wg21/docs/papers/2020/p2175r0.html#appendix-a-the-stop_when-algorithm)
- [P3552R1 Add a Coroutine Task Type](https://www.open-std.org/jtc1/sc22/wg21/docs/papers/2025/p3552r1.pdf)

# TODO - topics to cover

- callback
- stop_token
- Structured concurency
  - chains
  - sane principles
    - a child coroutine does not outlives its parent
    - a coroutine runs uninterrupted until a co_await
  - discuss issue with reference parameters, lambda captures, pointers, string_views
    - the generator problems with scope
  - discuss the issue of detach/fire and forget
    - lifetime
      - discuss bad advice that uses detached models
      - https://isocpp.github.io/CppCoreGuidelines/CppCoreGuidelines#Rcoro-capture
      - more bad advice https://devblogs.microsoft.com/oldnewthing/20211103-00/?p=105870
      - though they really like detached in embedded environments, explain why
    - error propagation
  - sync start a chain
  - wait_any, wait_all
  - wait_for
  - nursery
- Cancellation
  - hiding cancellation from function signature (e.g. see `co_await get_cancellation_token()`
- Trampoline
- Timers
- Threading synchronization in await_suspend
  - none (no cancellation)
  - mutex
  - atomic bool
- Windows Thread Pool

