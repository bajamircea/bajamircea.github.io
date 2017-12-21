---
layout: post
title: 'Counting Bits - Processor can do best'
categories: coding cpp
---

Counting the bits set: processor can do best


# Processor can do best

This is where we address the fundamental point, number 1 on the list of issues
with a naive implementaion for counting the bits set. The processor/hardware
can do that best, because it's simpler circuitry compared with other
operations, even compared with just simple addition of two numbers.

AMD/Intel processors have a `POPCNT` instruction since arround 2008.

C/C++ compilers have intrinsics that map to the assembly instruction if
available or otherwise to some optimized algorithm as we've seen in the
previous posts.  The Microsoft compiler has a `__popcnt` intrinsic, Java has a
`bitCount` method with similar behaviour.

Here is the gcc intrinsic:

{% highlight c++ linenos %}
int count_bits_6(unsigned int x) {
  return __builtin_popcount(x);
}
{% endhighlight %}


# Motivation

# References

CppCon 2017: Matt Godbolt "What Has My Compiler Done for Me Lately? Unbolting the Compiler's Lid"<br>
[https://www.youtube.com/watch?v=bSkpMdDe4g4](https://www.youtube.com/watch?v=bSkpMdDe4g4)

C++Now 2017: Phil Nash "The Holy Grail!? A Persistent Hash-Array-Mapped Trie for C++"<br>
[https://www.youtube.com/watch?v=WT9kmIE3Uis](https://www.youtube.com/watch?v=WT9kmIE3Uis)

Sean Eron Anderson "Bit Twiddling Hacks"<br>
[https://graphics.stanford.edu/~seander/bithacks.html#CountBitsSetNaive](https://graphics.stanford.edu/~seander/bithacks.html#CountBitsSetNaive)

Microsoft C++ compiler intrinsic __popcnt<br>
[https://msdn.microsoft.com/en-us/library/bb385231.aspx](https://msdn.microsoft.com/en-us/library/bb385231.aspx)

Java intrinsic Integer.bitCount<br>
[https://docs.oracle.com/javase/7/docs/api/java/lang/Integer.html#bitCount%28int%29](https://docs.oracle.com/javase/7/docs/api/java/lang/Integer.html#bitCount%28int%29)
