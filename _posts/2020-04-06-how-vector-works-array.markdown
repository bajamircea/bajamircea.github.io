---
layout: post
title: 'How vector works - array'
categories: coding cpp
---

What we need to know about C arrays so that we get the C++ vector.


# Introduction

In the "How vector works" series of blogs I'm going to cover how I look at the
`std::vector`, the default container in C++. The first article in the series
looks at arrays, the data structure that the vector competes with.


# Array

An array is a memory contiguous sequence of values.

To identify the position of a value in an array we need a pointer to that
value. Incrementing or decrementing the pointer advances the position a number
of positions forward or backward.

![Array](/assets/2020-04-06-how-vector-works-array/01-array.png)

With an array we need to know where it starts. For that a pointer is usually
used, e.g. `begin`, which points to the memory location of the first value in
the array.

We also need to know how long the sequence is. For that we either need to:
- use another pointer (two pointers define a range)
- or know the size
- or use a special value (a sentinel, e.g. `0` for sequences of characters)

Using two pointers is logically equivalent to using a pointer and size (because
of the pointer arithmetic increments in `sizeof(value)`:
- the `size` can be calculated by `end - begin`
- the `end` can be calculated by `begin + size`

I'm going to focus on the option of using a pointer, call it `end`, and have it
point to one past the last element in the sequence. Rules of the language going
as far as `C` allow us to use such a pointer.

This mechanism allows us to represent empty sequences where `begin` is equal to
`end`. The `end` must not be dereferenced, it does not point to a value. That's
another way of saying that we should not read from or write to the address
pointed by `end`.

They can be used to represent a range, not just the full array and both
generalize to iterators that apply to other sequential data structures.

The mechanism to traverse the range involves a loop similar to the one below:

{% highlight c++ linenos %}
for (auto it = begin; it != end ; ++it)
{
  // process *it;
}
{% endhighlight %}

The pointer and size approach is useful for divide (in half) and conquer. For
situations where we consume from the sequence it requires to update both the
pointer and the remaining size, so using two pointers is better instead for
this consuming scenario. We can convert between the two choices as required.

Using a sentinel is the approach used by C-style zero terminated strings and by
input iterators. This can be made compatible 

# Notes

`std::begin(some_array)` and `std::end(some_array)` (and their `const`
counterparts `std::cbegin` and `std::cend`) can be used to obtain the `begin`
and `end` pointers for some C array.

Beware of using more elements than required. E.g. functions that require an
array, an offset AND a length as arguments in order to pass a array range are
not minimalistic. That might be required only because of language limitations
(e.g. Java). Two pointers (or a pointer and length) is enough.

Similarly, when we access an array using an index e.g. `some_array[i]`, behind
the scenes the array start pointer is incremented `i` positions to obtain the
pointer for the value at index `i`. If we need to store, or pass as a function
argument, or return from a function the position for the value at index `i`, a
single pointer is enough. We don't need to store/pass both a pointer to the
begining of the array AND an index.

