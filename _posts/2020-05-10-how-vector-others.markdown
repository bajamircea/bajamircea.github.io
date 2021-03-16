---
layout: post
title: 'How vector works - the other vectors'
categories: coding cpp
---

"The std::vector is only one kind of vector", I'm paraphrasing Alex Stepanov
here. Let's look at the options.


# Vanilla options

Options out of the box from the standard library:

- Built-in array
: Use it for fixed size memory contiguous sequence of values
- `std::array`
: Like the built-in but with an interface more similar to other containers
- `std::vector`
: Container to use by default, a resizeable array
- `std::deque`
: Gives efficient insertion at the front as well
- `std::string`
: Zero terminated vector of chars

# Specialized

- `std::vector<bool>`
: It's a specialization of `std::vector` that, for historical reasons, came to
compact `bool` values as individual bits. That's fine in principle if it was a
entirely different container, but as such it becomes quite different from the
vector in terms of behaviour, e.g. can't get reference to a individual value (a
bit)
- use allocator for `std::vector`
: That's a low level performance optimisation, so only use with measurements
that justify/prove improvements


# Build your own

- customize the growth factor/strategy for vector
- size instead of pointers
: Instead of pointers store the `end` and `capacity` as size values, use
smaller values e.g. 32-bit on a 64-bit machine. Especially for strings: when
was the last time you needed to store a string longer than 4GB? This could lead
to more calculations/less space trade-offs.
- small size optimisations
: When the contents is just a few elements, could use space inside the `end`
and `capacity` to store contents, saving an allocation when the size is small.
A lot of strings in particular are small.
- don't duplicate capacity
: With enough knowledge of how the allocator works, notice that most of the
time the default allocator needs to store/know the allocated size. Use that
instead of duplicating the capacity as a member variable for the vector.
- customize handling of value types that could throw on move
: As per the previous article
- build your own `deque`
: The default implementation of `std::deque` uses chunks. This leads to
particular allocation/deallocation behaviours. You could customize the size of
the chunks, or just use a circular buffer, without chunks.
