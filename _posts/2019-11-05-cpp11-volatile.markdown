---
layout: post
title: 'C++11 volatile'
categories: coding cpp
---

A brief history of the meaning of volatile in C++


# Original purpose for memory mapped I/O

Traditionally the key word `volatile` in C, was meant to be used in a specific
scenario where devices map I/O devices into memory.

For example in the figure below, a fictional device would document the layout
of it's memory space such that only some of that is backed by actual RAM. Other
regions have different purposes. In particular this sample shows that a range
of addresses reserved for I/O mapped devices.

![memory mapped io sample](/assets/2019-11-05-cpp11-volatile/mappedio.png)

A complete documentation for such a device would detail the behaviour for each
address reserved for I/O device and it's side effects. Some locations are
intended as write only (for output devices), others read only (for input
devices), and others for both read and write. For example writing at a
particular address would actually send data over the serial port. So writing to
a memory address using assembly instructions like `MOV` (for move) or `ST`
(for store) could, depending on the actual address, either write a value to RAM
or send data over the serial port.

The C compiler would **generate reads or writes to memory addresses for
assignments to `volatile` qualified variables, instead of optimising them
away**.

In the example where we want to write two bytes over the serial port we would
have two assignments to a variable qualified by `volatile`, and we want the
compiler to generate two write assembly instructions instead of optimising and
only writing the second value just once.

In this context the relative order of access is important. E.g. one could write
to a I/O memory mapped location to enable the serial port, then write to
another location to send a byte, if the compiler changes the order the net
effect in this case would be no data sent.

The C compiler would **preserve the order of assignments to `volatile` qualified
variables, ensuring they are not reordered**.


# Extending the patters of usage

The `volatile` keyword was then used in other languages: C++ obviously, but also
Java and C#. At the same time multi-threading became popular. And issues were
discovered where programmers were encouraged by books, vendor documentation
etc. to use the `volatile` keyword to fix threading issues, outside it's
original purpose of dealing with memory-mapped I/O.

For example, in a produced-consumer pattern, a producer thread sends some data
to a consumer thread and they use a `flag` to agree on when the data was send.

In the code below, the producer thread writes two variables `a` and `b`, then
sets a `flag` and a consumer thread waits in a loop for the `flag` to be set
before reading `a` and `b`.

{% highlight c++ linenos %}
int a = 0;
int b = 0;
bool flag = false;

void producer_thread()
{
  // write a and b
  a = 42;
  b = 43;
  // set the flag at the end
  flag = true;
}

void consumer_thread()
{
  // wait for the flag to be set
  while (!flag) continue;
  // the flag was set: use a and b
  ...
}
{% endhighlight %}

Sometimes this code would appear to work.

But other times, the compiler would look at the consumer wait loop and notice
that, inside it, the value of the `flag` is not tested, therefore it would read
the value of the flag once, and if not set, wait forever in a `while (true)`
loop. When this happened, it was reasonably obvious: the consumer thread would
loop forever. Qualifying the flag as `volatile` was recommended as a pattern in
these situation to ensure that the compiler will retry the read of the `flag`
and exit the wait loop when the `flag` is eventually set.


# Reordering around volatile

Qualifying the `flag` as `volatile` solves the problem that the consumer thread
reads the value of the `flag` repeatedly until set, but issues that were more
subtle continued to exist and they took longer to be understood.

The programmer's intention is to also have guarantees that:
- the writes to `a` and `b` precede setting the `flag`
- the reads from `a` and `b` follow reading the `flag` (if set)

These expectations look more like the graph shown by the solid arrow lines in
the diagram below:

![mem-fence graph](/assets/2019-11-05-cpp11-volatile/mem-fence-motivation.png)

But while the original guarantees for `volatile` promised that the order of
assignments to `volatile` qualified variable is preserved, **it does not mean
that no reordering will happen around `volatile` assignments**.

In our example, it does not enforce any ordering with regards to `a` and `b`
which are not marked as `volatile`. The compiler will actually generate a
dependency graph shown by the solid arrow lines in the diagram below:

![without mem-fence](/assets/2019-11-05-cpp11-volatile/without-mem-fence.png)

That meant that sometimes `a` and `b` were written after the `flag` was set,
and the consumer thread would see incorrect values. These issues were more
difficult to understand and fix.


# Java and C#

Over time it became clear that programming languages need to define a memory
model that must provide guarantees to fix multi-threading problems by, among
other things, inserting appropriate memory fences (explicit or implicit).

Java was the first to clarify its memory model in [JSR 133][javavolatile], for
Java 5 (also known as Java 1.5), around 2004. With regards to the `volatile`
keyword it chose to ensure that it's atomic, that it also adds full memory
fences.

This approach has the advantage that popular solutions to multi-threading
issues like the producer-consumer scenario above, but also others, like the
double-checked locking, were working now.

C# followed the suit. For example it's specification for `volatile` mentions:

> A read of a volatile field is called a volatile read. A volatile read has
> "acquire semantics"; that is, it is guaranteed to occur prior to any
> references to memory that occur after it in the instruction sequence


# C++11

A memory model was added to the C++11 standard to support multi-threading. But
in C++ the decision was to keep the keyword `volatile` as a mean to solve the
original memory mapped I/O problems. **In C++11 `volatile` does not guarantee
memory bariers for non-volatile access**.

For multi-threaded problems as above, low level available operations are meant
to be addressed by atomics (which are quite fine grained, at least in theory).

Some legacy code still relies on previous guidance for `volatile`. Microsoft
provided such guidance, and after some confusion, they decided to have [two
mode of operation][msvolatile]:
- `/volatile:ms` which is more akin the Java approach of providing full memory
  barriers, enabled by default on x86 platforms
- `/volatile:iso` which abides the C++ standard behaviour

My recommendation is for new C++ code is to not use `volatile` to address
multi-threading issues.


# That's not the end of it

For example, for a processor similar to the one described in the fictional
example above, the programmer intends to assign to a 16-bit variable.  The
processor is 8-bit, the assignment is not atomic, an interrupt could see only
half of the value, unless interrupts are disabled while the assignment
instructions are performed. The value is also the result of a calculation.
Sample code looks like this:

{% highlight c++ linenos %}
void fn(unsigned int value)
{
  value = 65535U / value; // calculation
  cli(); // disable interrupts (cli = clear interrupt)
  global_variable = value; // assignment
  sei(); // enable interrupts (sei = set interrupt)
}
{% endhighlight %}

The [real example][gccavr] has additional complexity. For example `cli()` and
`sei()` are implemented as assembly instructions. But in summary, using
techniques equivalent to using `volatile` as a qualifier, the best dependency
graph that can be generated looks like below:

![non-volatile reordering](/assets/2019-11-05-cpp11-volatile/gccavr.png)

The problem is that the calculation can be reordered by the compiler inside the
region where the interrupts are disabled. On that processor, performing a
division can take a long time; interrupts can't be served. This has
implications on the duration for which interrupts can't be served, changing the
real-time characteristics of the system.

This kind of timing problem is not fixable given the current threading support
or current meaning of `volatile`, and it's not limited to the processor in the
example.


# Conclusion

The understanding and meaning of the `volatile` keyword evolved and changed
over time. This article is a just a brief introduction, for the precise
meaning, limits and guarantees in a specific programming language and
dialect/version/vendor check the official documentation of the language.


# References

- Jeremy Manson and Brian Goetz: [JSR 133 (Java Memory Model) FAQ][javavolatile], February 2004
- [C# language specification on volatile][csharpvolatile]
- MSDN in Visual Studio 2019: [volatile (C++)][msvolatile], 7 May 2019
- Jan Waclawek: [Problems with reordering code][gccavr]

[javavolatile]: https://www.cs.umd.edu/~pugh/java/memoryModel/jsr-133-faq.html#volatile
[csharpvolatile]: https://docs.microsoft.com/en-us/dotnet/csharp/language-reference/language-specification/classes#volatile-fields
[msvolatile]: https://docs.microsoft.com/en-us/cpp/cpp/volatile-cpp?view=vs-2019
[gccavr]: https://www.nongnu.org/avr-libc/user-manual/optimization.html
