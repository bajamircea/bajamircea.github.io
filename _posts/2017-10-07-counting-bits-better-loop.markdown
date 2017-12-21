---
layout: post
title: 'Counting Bits - Better Loop'
categories: coding cpp
---

Counting the bits set: the better loop approach.


# Better looping

This algorithm, described by Kernighan, addresses problem 3 (the number of
times we loop) and only loops as many times as there are bits set, regardless
of their position.

{% highlight c++ linenos %}
int count_bits_2(unsigned int x) {
  int count{ 0 };
  while (x != 0) {
    ++count;
    x &= (x - 1);
  }
  return count;
}
{% endhighlight %}

If the loop above looks difficult to understand, but very clever, it's because
it is. It relies on the fact that `x - 1` flips all the bits up to and
including the last bit that is set.


# Detailed explanation

If `x` is not zero and we peform a iteration in the loop, the representation of
`x` as bits can be divided into three components (from LSB/right to MSB/left):

- a suffix range of all zeros following (but not including) the last bit set up
  to the LSB (the least significant bit)
- the last bit that is set: the bit counted in this iteration
- a prefix range of mixture of ones and zeros from the MSB (most significant
  bit) to (but not including) the last bit that is set: this is the prefix
  range of bits

Either of the two ranges around the bit counted in this iteration can be empty.

<pre>
x at the start:
 MSB                                                      LSB
+----------------------------------+---+---------------------+
| 0 | 1 | 0 |  ... | 0 | 1 | 1 | 0 | 1 | 0 | 0 |   ...   | 0 |
+----------------------------------+---+---------------------+
|                                  |   |                     |
|<- prefix (mixture of 0s and 1s)->| ^ |<- all zero range  ->|
                                     |
           the last bit set: the bit counted in this iteration

</pre>

When we substract 1, all bits up to and including the last bit set flip:

- the suffix range of all zeros becomes a range of all ones
- the bit counted in this iteration becomes 0
- the prefix range stays the same

<pre>
x - 1:
 MSB                                                      LSB
+----------------------------------+---+---------------------+
| 0 | 1 | 0 |  ... | 0 | 1 | 1 | 0 | 0 | 1 | 1 |   ...   | 1 |
+----------------------------------+---+---------------------+
|                                  |   |                     |
|<-       stays the same         ->| ^ |<- all ones range  ->|
                                     |
                  the bit counted in this iteration flips to 0

</pre>

After bitwise AND between the two values above we get the value for the next
iteration.

<pre>
x at the end (after "x &= (x-1)")
 MSB                                                      LSB
+----------------------------------+---+---------------------+
| 0 | 1 | 0 |  ... | 0 | 1 | 1 | 0 | 0 | 0 | 0 |   ...   | 0 |
+----------------------------------+---+---------------------+
|                          |   |                             |
|<-   new prefix range   ->| ^ |<-   new all zero range    ->|
                             |
                   the bit to be counted in the next iteration

</pre>

This value preseves the invariant of the loop (three components) or `x`
becomes zero.
