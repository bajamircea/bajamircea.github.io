---
layout: post
title: 'Counting Bits - Adding Bits In Groups'
categories: coding cpp
---

Counting the bits set: adding bits in groups


# Adding bits in groups

This is another way of addressing problem 2 and make calculate the number of
bits set in a constant number of steps.

{% highlight c++ linenos %}
int count_bits_4(unsigned int x) {
  const unsigned int m1 = 0x55555555; // 5 is 0101 in binary
  x = (x & m1) + ((x >> 1) & m1);

  const unsigned int m2 = 0x33333333; // 3 is 0011 in binary
  x = (x & m2) + ((x >> 2) & m2);

  const unsigned int m4 = 0x0f0f0f0f;
  x = (x & m4) + ((x >> 4) & m4);

  const unsigned int m8 = 0x00ff00ff;
  x = (x & m8) + ((x >> 8) & m8);

  const unsigned int m16 = 0x0000ffff;
  x = (x & m16) + ((x >> 16) & m16);

  return x;
}
{% endhighlight %}


# Explanation

Given the representation in bits for an unsigned number:

<pre>
x at beginning
 MSB                             LSB
+------------------------------------+
| a | b | c | d | e | f | g | h | ...|
+------------------------------------+

</pre>

We first mask and allign alternating bits, creating (virtual) groups of two bits
where the first bit in the group (half of the group length) is zero.

<pre>
x & m1 // m1 is 01010101...
 MSB                             LSB
+------------------------------------+
| 0   b | 0   d | 0   f | 0   h | ...|
+------------------------------------+

(x >> 1) & m1
 MSB                             LSB
+------------------------------------+
| 0   a | 0   c | 0   e | 0   g | ...|
+------------------------------------+

</pre>

When we add the two values above, the outcome is that there is no carry from
one group to the other because the highest value in a group is `01`, so the
highest value by adding two groups is `01 + 01 = 10` which will fit in a two bit
group.

<pre>
x = (x & m1) + ((x >> 1) & m1);
 MSB                             LSB
+------------------------------------+
| a + b | c + d | e + f | g + h | ...|
+------------------------------------+

</pre>

So now we mask alternating two bit groups to create four bit groups (double the
size) and align them. Again the starting half length of the new group is zero.

<pre>
x & m2 // m2 is 00110011...
 MSB                             LSB
+------------------------------------+
| 0   0   c + d | 0   0   g + h | ...|
+------------------------------------+

(x >> 2) & m2
 MSB                             LSB
+------------------------------------+
| 0   0   a + b | 0   0   e + f | ...|
+------------------------------------+

</pre>

When we add the two values above, the outcome is that there is no carry from
one group to the other because the highest value in a group is `0010`, so the
highest value by adding two groups is `0010 + 0010 = 0100` which will fit in a
four bit group.

<pre>
x = (x & m2) + ((x >> 2) & m2);
 MSB                             LSB
+------------------------------------+
| a + b + c + d | e + f + g + h | ...|
+------------------------------------+

</pre>

And so on until we have the sum of all the bits which is the number of bits
set.
