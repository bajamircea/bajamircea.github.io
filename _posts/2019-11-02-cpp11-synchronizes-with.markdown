---
layout: post
title: 'C++11 synchronizes-with'
categories: coding cpp
---

A few examples involving synchronizes-with: the C++ key word for basic thread
synchronization


# Introduction

The C++ standard specifies that accessing the same data from multiple threads
with no appropriate synchronization leads to undefined behaviour. We'll look
at three simple scenarios in C++ that do appropriate synchronization, exclusive
data access in particular, using `std::mutex` and `std::thread`.


# Mutex locking

To exclusively access shared data using a `std::mutex`, each thread will
`lock()` the mutex, change the data then `unlock()` the mutex.

To ensure that `unlock()` is called, using a class like`std::scoped_lock`
or similar is highly recommended.

From the programmer's perspective one thread "produces" the shared data, while
another thread "consumes" the shared data. For anything other than the
simplest piece of data (e.g. a `bool`) usually "producing" means both reads and
writes. E.g. if the data is a queue, `push_back()` will read and increment the
size. The same applies to "consuming".

In C++ standard legalese this is appropriate synchronization because the mutex
`unlock()` synchronizes with any subsequent `lock()` operations that obtain
ownership of the same mutex. This guarantees that all the reads and writes done
by a thread before `unlock()` are seen by reads and writes done by another
thread after `lock()`.

![mutex sample](/assets/2019-11-02-cpp11-synchronizes-with/mutex.png)


# Thread creation

Before we create treads we usually initialize data that will be used by the
thread, including the objects used for synchronization (e.g. mutex, condition
variables). The standard guarantees that all the reads and writes of this
initialization are seen consistently by the function that the tread executes.

In C++ standard legalese: the completion of the invocation of the constructor
synchronizes with the beginning of the invocation of thread function.

![creation sample](/assets/2019-11-02-cpp11-synchronizes-with/creation.png)


# Thread completion

Similarly when completing/ending a thread the function `join()` is used to
confirm that the thread function completed. The standard guarantees that all
the reads and writes done by the function that the thread executes are then
seen consistently after the `join()` function returns.

In C++ standard legalese: the completion of the thread synchronizes with the
corresponding successful `join()` return.

![join sample](/assets/2019-11-02-cpp11-synchronizes-with/join.png)


# References

- Jeff Preshing: [The Synchronizes-With Relation][sync], 23 Aug 2013

[sync]: https://preshing.com/20130823/the-synchronizes-with-relation/
