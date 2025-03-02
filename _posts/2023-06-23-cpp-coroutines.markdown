---
layout: post
title: 'C++ coroutines'
categories: coding cpp
---

C++ coroutines lab presentations. WORK IN PROGRESS

# Presentations

- [Problem domain](/presentations/2023-08-06-coro-problem-domain.html)
- [Mechanics](/presentations/2023-09-05-coro-mechanics.html)
- Scoped coroutines
  - TODO discuss issue with reference parameters, lambda captures, pointers, string_views 
  - TODO the (invalid) `std::move` trick to call once
- Trampoline
- Timers
- Structured concurency
  - TODO: discuss the issue of detach/fire and forget
    - lifetime
    - error propagation
  - TODO: discuss issue with blocking in bounded parallelism cases
  - TODO: discuss issue with destructors blocking
- Cancellation
- Nursery
- Threading models
- Windows Thread Pool

<div align="center"><a href="/presentations/2023-08-06-coro-problem-domain.html">
{% include assets/2023-06-23-cpp-coroutines/00-cover.svg %}
</a></div>


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