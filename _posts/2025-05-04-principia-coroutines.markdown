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
- [Callback](/presentations/2025-05-30-callback.html)
- [Stop source, token, callback](/presentations/2025-06-03-stop.html)
- [Structured concurency](/presentations/2025-06-07-structured-concurency.html)

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
- [Introduction to Wait-free Algorithms in C++ Programming - Daniel Anderson - CppCon 2024](https://www.youtube.com/watch?v=kPh8pod0-gk)

# TODO - topics to cover

- More in threading model
  - embedded concurrency
    - detached mode
    - queue in hardware: interrupt priorities
  - GPU
    - NVIDIA motivation e.g.
      - use local GPU plus remote GPUs
      - use GPU to accelerate CPU work
  - executor/scheduler
  - granularity
- What's wrong with
  - std::async
  - std::future and std::promise
- Cancellation
  - nature of cancellation
  - cooperative
    - poll
    - stop callback
  - asynchronous
    - best effort, e.g. might not cancel immediately or might still complete
  - what if cancel is slow: the server/detection pattern
  - hiding cancellation from function signature (e.g. see `co_await get_cancellation_token()`
- Trampoline
- Timers
- context passing (adv/disadv):
  - explicit as an argument
  - buried
- The issue of dual language:
  - e.g. implementing vs. using (as seen in boost::asio)
- Threading synchronization in await_suspend
  - none (no cancellation)
  - mutex
  - atomic bool
- C++ coroutine weak points
  - weak allocation control: have allocator, but allocation size is runtime
    info
    - no option to allocate on stack e.g. for a know type can control
      allocation on stack or heap (std::unique_ptr)
  - resume and destroy mechanisms are indirect calls: call a function that
    fetches a function pointer that makes a switch
  - a large vocabulary of terms: learning curve obstacle
- senders receivers
  - compare example with read size then data (senders vs. coroutine)
  - design by committee (poorly explained, e.g. alternatives not explained)
    - customization points overload
- Windows Thread Pool

