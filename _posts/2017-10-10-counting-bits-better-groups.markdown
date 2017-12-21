---
layout: post
title: 'Counting Bits - Better Adding bits in groups'
categories: coding cpp
---

Counting the bits set: better adding bits in groups


# Better adding bit groups

This is a hacky improvement over the previous adding bits in groups algoritm.

{% highlight c++ linenos %}
int count_bits_5(unsigned int x) {
  x -= (x >> 1) & 0x55555555; // 5 is 0101 in binary
  x = (x & 0x33333333) + ((x >> 2) & 0x33333333); // 3 is 0011 in binary
  x = (x + (x >> 4)) & 0x0f0f0f0f;
  x *= 0x1010101; // magic multiplier
  x >>= 24;
  return x;
}
{% endhighlight %}

# Explanation

The first line masking with `01010101...` is a bit different in that it uses
substraction to avoid one additional masking. It works when you look at all the
possible combinations for a group of two bits.

At this point the group length is 2 and the max value in each group is `10`.

The second line masking with `00110011...` is same as for the [basic adding
bits in groups example][counting-bits-in-groups].

At this point the group length is 4 and the max value in each group is `0100`.

The third line masking with `00001111...` is a bit different. It uses the fact
that the addition fits in the lower half of the group, and the undesired higher
half can be masked at the end, saving one masking operation.

At this point the group length is 8 and the max value in each group is
`00001000`, first 4 bits zero followed by at most 4 bits not zero.

The multiplication with the magic number is what's different. To explain it
let's look at the following multiplication where `p`, `q`, `r`, `s` are the (at
most 4 bits) results from the step above. Multiplying two 32 bit numbers is a
64 bit result (two 32 numbers for the higher and lower part).

<pre>
         0p0q0r0s *
         01010101
         --------
         0p0q0r0s
      0p 0q0r0s
    0p0q 0r0s
  0p0q0r 0s
-----------------
000pxxww vvuutt0s
</pre>

The interesting result is `vv` in the lower part of the result, which just
happens to be the sum of `p`, `q`, `r` and `s`. That can be obtained by
shifting the lower part by 24.

# References

Software Optimization Guide for the AMD64 Processors<br>
8.6 Efficient Implementation of Population-Count Function in 32-Bit Mode<br>
[https://support.amd.com/TechDocs/25112.pdf](https://support.amd.com/TechDocs/25112.pdf)

[counting-bits-in-groups]: {% post_url 2017-10-09-counting-bits-in-groups %}
