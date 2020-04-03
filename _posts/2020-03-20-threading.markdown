---
layout: post
title: 'Advanced Introduction to Multithreading'
categories: coding cpp
---

Advanced in that it assumes audience used/heard of threads, introduction in that the subject is deep and complex


I [presented this](/presentations/2020-03-20-threading.html) at Sophos.


# Agenda

- Compiler re-ordering
  - Demo
  - DAG
- CPU Memory model
  - "The sample"
  - Speculative execution
  - CPU data dependency ordering
  - Weak and strong memory models
  - TSO model for x86
  - Why memory fences
- Threading before C++11
- C++11 data races
  - Multiple writes mythical defence
  - Integer data race
  - Boolean data race
- C++11 standardeese - synchronises with
  - Mutex
  - Thread creation
  - Thread completion
- The volatile myth
- Mention the thread sandwich pattern
