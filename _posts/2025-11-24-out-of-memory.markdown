---
layout: post
title: 'Out of memory'
categories: coding cpp
---

Handling out of memory, C++ std::bad_alloc, Rust panic, Windows vs. Linux,
committed vs. fork.


# Preamble

> \- So, in Rust, how do you handle "out of memory" without crashing?<br/>
> \- You open the case of your computer and add more RAM!<br/>
> \- Huh?<br/>

With the advent of 64 bit computers, typically a user process addresses the
memory using a 64 bit pointer.

You might think "Then I can use 2<sup>64</sup> bytes of memory. 2<sup>64</sup>
is a lot, so we're fine, we'll never run out of memory".

Well, no, this is what this article is about.


# So how much memory we have?

Let's assume a x64 process, with 64 bit pointers.

We start with a theoretical limit of 64 bits. That's a humongous 16EB
(exabytes). For a reminder of units for bytes see below [Annex A](#annex-a).

But the Intel x64 architecture has a lower theoretical limit of 52 bits.

But the actual Intel x64 limit might be lower, e.g. 48 bits.

But the operating system might have a yet lower limit, e.g. Windows might limit
it to 44 bits.

The reason for this lower limits usually has to do with either hardware
limitations (wires and gates) or with the fact that to map a process address to
a actual physical location (e.g. in RAM) various data structures are used, and
they would take too big a fraction out of the RAM.

But we're still talking huge numbers: 44 bits is 16TB, compared with RAM
amounts that commonly range today between 4GB and 64GB.

The 64 bit pointer address is translated to a physical address in RAM, and when
there is not enough space in RAM, the OS will use some sort of paging/swapping:
basically memory is transferred in pages (i.e. chunks) between the disk and RAM.

Windows for example uses pages of typically 4KB and typically the space on disk
is a file called `pagefile.sys`.

By default the max size of `pagefile.sys` is limited to 3 times the amount of
RAM (or 4GB whichever is larger)

So say for a system with 8GB of RAM we have a typical limit of memory of
not more than 32GB.

And your process has to share that with the operating system and the other
processes. Some of which might use (sometimes temporarily) quite a lot.

Therefore you can still hit out of memory, the numbers are much smaller, a far
cry from the 16EB we started with.


# C/C++ on Windows behaviour

Not all the address space is available at program start. If you allocate memory
with `malloc` or `new` the standard library manages the heap on your behalf,
and if there is not enough memory on the previously obtained block, the library
will ask the operating system to provide additional blocks of virtual memory to
be used for the heap. If the operating system call returns failure, then that
is propagate back to the program, as a `0` pointer in C from `malloc` or as a
`std::bad_alloc` exception in C++ (though usually `new` in C++ uses `malloc`
behind the scenes).

The programmer can decide what the program should do. Some programs could exit
early with an error. That might be the case with a command line tool that the
user could launch again later. Other programs could decide to recover from the
error, by freeing some memory themselves (e.g. in C++ by unwinding the stack
calling destructors for heap allocated containers) and trying again later on
the hope that the problem was temporary. A program that runs in the background
(e.g. as a Window service), monitors a folder for changes and does a backup
which runs out of memory backing up a file might give up temporarily on that
file, but try to backup another file, and/or might try again later.

What it means in practice is that if your program has a one off large
allocation that the operating system cannot satisfy, then in C++ you get a
`std::bad_alloc` exception that the program can catch and then it will fine if
you ask for more reasonable amount of memory.

But if instead the allocation is an ever increasing number of small blocks of
memory, then Windows will keep on moving pages into `pagefile.sys`, the size of
`pagefile.sys` increases, the system slows down due to disk usage, but
eventually some badly written programs will crash. E.g. Windows Explorer that
is responsible for the Windows shell/desktop/taskbar crashes and the UI becomes
unusable. But things that were written carefully survive, for example Windows
can respond to shutdown requests triggered by pressing the power button
shortly. After reboot the `pagefile.sys` is truncated.

There are lots of details to this behaviour, e.g. "why does `pagefile.sys` do
not grow more that three times the amount of RAM?" "Answer: well, the system
would be very slow, and anyway filling the disk could cause bigger problems".

But the core idea is that in Windows the memory is committed: if Windows gives
memory to a program, the program has the memory. This allows programs to
recover/deal with "out of memory" without just crashing.


# Rust

{% highlight rust linenos %}
let s1 = String::from("Hello world! This is a heap allocated string");
let s2 = s1.clone();
{% endhighlight %}

What happens behind the two code lines above is that each of them allocates.
The first one allocates on the heap, copies the literal string and stores into
`s1` a pointer to the heap allocated data. The second line does the equivalent
of a C++ copy. A data structure can be copied or moved. A simple assignment in
C++ copies, the move requires more typing. In Rust it's the reverse, the
assignment move, the copy requires more typing: you use `.clone()`.

But what happens if the allocation fails? Well, if `.clone()` returned a
`Result` (which includes an error) then we could test for the error. But it
does not. Well, an exception could be thrown. But Rust does not support
exceptions. So then it panics. The program cannot have a meaningful recovery.

One could avoid the `Clone` trait entirely and use an interface that provides a
`Result`. That would mean avoiding `String`, avoiding `Vec`, which means giving
up a lot of (most?) Rust libraries.

The claims that Rust is a memory safe language relies on a very narrow
definition of safety which does not include "it shall not crash and try again
in low memory conditions".

But why did Rust make this choice? I think it's because the handling of "out of
memory" in Rust is similar to the one in Unix-like operating systems.


# fork

In the 1970s `fork` was a way to create processes given the constraints at the
time. The child process inherits all the memory of the parent, which can be
hollowed out to various degrees to customize the child process. This is usually
implemented using "copy on write". So memory that is shared between the parent
and the child is reference counted, and if it's not changed then "hurray,
memory is saved by avoiding duplication", but if one changes it then new
physical memory is required. New physical memory is required on write, not at
specific allocation points.

So this lead to the common strategy in Unix-like systems to "reserve" rather
than "commit" memory, and to detect "out of memory" on writes rather than at
allocation.


# <a id="annex-a">Annex A: Reminder of memory units</a>

Here is a reminder of amounts of bytes as powers of 2, ignoring the difference
between 1024 bytes (1 kibibyte) and 1000 bytes (1 kilobyte), because no
respectable programmer would use the word kibi instead of kilo:
<table>
  <thead>
    <tr>
      <th>Amount</th>
      <th>Unit in multiples of 1024</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>2<sup>10</sup></td>
      <td>1KB - kilobyte</td>
    </tr>
    <tr>
      <td>2<sup>20</sup></td>
      <td>1MB - megabyte</td>
    </tr>
    <tr>
      <td>2<sup>30</sup></td>
      <td>1GB - gigabyte</td>
    </tr>
    <tr>
      <td>2<sup>40</sup></td>
      <td>1TB - terabyte</td>
    </tr>
    <tr>
      <td>2<sup>50</sup></td>
      <td>1PB - pentabyte</td>
    </tr>
    <tr>
      <td>2<sup>60</sup></td>
      <td>1EB - exabyte</td>
    </tr>
  </tbody>
</table>

The maximum addressable memory typically depends on pointer size in bits, here
is a reminder of common values:
<table>
  <thead>
    <tr>
      <th>Bits</th>
      <th>Theoretically addressable memory</th>
      <th>Examples</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>32 bit address</td>
      <td>4GB</td>
      <td>32 bit processor e.g. Intel 80386</td>
    </tr>
    <tr>
      <td>64 bit address</td>
      <td>16EB</td>
      <td>64 bit processor e.g. Intel/AMD x64</td>
    </tr>
  </tbody>
</table>

This ignores all sorts of trickery e.g. even Intel 80386 could use a segmented
addressing system that could access up to 64TB of virtual memory, because as
well see, our problem is not "too much", but "not enough".

# Reference

[Mark Russinovich (2011): Mysteries of Memory Management Revealed (Part
1/2)](https://www.youtube.com/watch?v=AjTl53I_qzY): discusses the system commit
limit, system committed  virtual memory must be backed either by physical
memory or stored in the paging file, when limit is reached, virtual memory
allocations fail. Also [Mysteries of Memory Management Revealed (Part
2/2)](https://www.youtube.com/watch?v=6KZdNsq1YV4)

[Andrew Baumann, Jonathan Appavoo, Orran Krieger, and Timothy Roscoe. 2019. A
fork() in the
road.](https://www.microsoft.com/en-us/research/wp-content/uploads/2019/04/fork-hotos19.pdf)

[P1404r1: bad_alloc is not out-of-memory!](https://www.open-std.org/jtc1/sc22/wg21/docs/papers/2019/p1404r1.html)

