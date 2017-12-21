---
layout: post
title: 'Counting Bits - Naive Loop'
categories: coding cpp
---

You have a 32-bit (unsigned) integer. Write a function to calculate how many
bits are set. The naive implementation.


# Naive implementation

The naive implementation checks the least significant bit. If set, increment a
count. Shift to the right to move the next bit into the least significant
position. Loop.

{% highlight c++ linenos %}
int count_bits_1(unsigned int x) {
  int count{ 0 };
  while (x != 0) {
    if (x & 1) {
      ++count;
    }
    x >>= 1;
  }
  return count;
}
{% endhighlight %}

There are several problems with the naive implementation:

1. The major problem is that we've got a lot of operations (adding, shifting,
looping). But overall we're adding up to 32 (5 bits worth) for what for the
silicon in the processor should be simpler than adding two 32 bit integers.

2. The loop is where most of the problem lies. A loop means a jump. Due to the
pipelining of instructions jumps are expensive, except if either the processor
or compiler can predict the path for the jump, or if there are many
instructions inside the loop that amortize the const of the jump. However we
have here a tight loop with almost nothing inside and the processor would have
a hard time to figure out how many times we're going to loop.

3. The number of loops is the position of the most significant bit set. So if
only one bit is set in the most significant bit position, we'll loop 32 times
to return a count 1.

4. A minor problem is with an easy solution is that we could replace the `if`
test with adding unconditionally the value of last significant bit. `count +=
(x & 1);`.

In the following articles we'll eventually also address points 1, 2 and 3.

