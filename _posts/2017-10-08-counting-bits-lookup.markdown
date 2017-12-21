---
layout: post
title: 'Counting Bits - Lookup'
categories: coding cpp
---

Counting the bits set: lookup methods.


# Lookup

This algorihm uses a lookup. Now a table of `2^32` entries would be almost
always too large, but we can easily afford a table with 16 entries (a
nibble/half a byte) and loop for each nibble in the input. This partially
addresses problem 2 because the number of times we loop is fixed and a compiler
could unwrap the loop.

{% highlight c++ linenos %}
int count_bits_3(unsigned int x) {
  static int bit_count_array[] = {
    0, 1, 1, 2, 1, 2, 2, 3, 1, 2, 2, 3, 2, 3, 3, 4
  };
  int count{ 0 };
  for (unsigned int i = 0; i < sizeof(x) * 2 ; ++i) {
    int nibble = x & 0xFu;
    x >>= 4;
    count += bit_count_array[nibble];
  }
  return count;
}
{% endhighlight %}

# A bit better lookup

One could use a larger lookup table (e.g. `2^8) and reduce the number of
iteration, and clever ways to initialize it.
