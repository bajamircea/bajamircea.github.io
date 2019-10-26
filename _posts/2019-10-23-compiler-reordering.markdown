---
layout: post
title: 'Compiler reordering'
categories: coding cpp
---

Detailed example of execution reordering by the compiler


# Silly Fibonacci implementation

Say we have a silly function like `fib` below, a small `main` function to
calculate the value for `42` and print it.

{% highlight c++ linenos %}
#include <iostream>

int fib(int x)
{
    if (x < 2) return 1;
    return fib(x - 1) + fib(x - 2);
}

int main()
{
    int result = fib(42);
    std::cout << result << '\n';
    return 0;
}
{% endhighlight %}

Then using Visual Studio 2017 we compile it optimized (Release, not Debug) and
run it.

{% highlight shell linenos %}
433494437
Press any key to continue . . .
{% endhighlight %}

It prints the expected value, but it's slow. It takes about 1 to 2 seconds.
[We know how to implement a better one][better-fib]. But we'd like to first
find out how long it takes to run the silly version.


# Measuring the duration using chrono

So we use the standard `chrono` library to take `start` and `stop` timestamps
around the call to `fib(42)`.

Then we print the duration using a weird looking `duration_cast`. Given that it
takes seconds, a resolution of milliseconds should do.

{% highlight c++ linenos %}
#include <chrono>
#include <iostream>

int fib(int x)
{
    if (x < 2) return 1;
    return fib(x - 1) + fib(x - 2);
}

int main()
{
    auto start = std::chrono::steady_clock::now();
    int result = fib(42);
    auto stop = std::chrono::steady_clock::now();
    std::cout << result << '\n';
    std::cout << "It took: " << std::chrono::duration_cast<std::chrono::milliseconds>(stop - start).count() << '\n';
    return 0;
}
{% endhighlight %}

Then using Visual Studio 2017 we compile it optimized (Release, not Debug) and
run it.

{% highlight shell linenos %}
433494437
It took: 0
Press any key to continue . . .
{% endhighlight %}

And the problem is that it prints a duration of 0. But when we run it, it
obviously **takes more than 0 milliseconds** by about three orders of
magnitude.

And some look at the weird looking `duration_cast` and claim that there must be
something wrong with it: **look, it uses templates, so it must be wrong, oh why
don't we use the good ol' GetTickCount?**.


# Measuring the duration using GetTickCount

So we use the good ol' `GetTickCount`. It does overflow after about 48 days,
but it will do for a quick test.

{% highlight c++ linenos %}
#include <Windows.h>
#include <iostream>

int fib(int x)
{
    if (x < 2) return 1;
    return fib(x - 1) + fib(x - 2);
}

int main()
{
    auto start = ::GetTickCount();
    int result = fib(42);
    auto stop = ::GetTickCount();
    std::cout << result << '\n';
    std::cout << "It took: " << (stop - start) << '\n';
    return 0;
}
{% endhighlight %}

Then using Visual Studio 2017 we compile it optimized (Release, not Debug) and
run it.

{% highlight shell linenos %}
433494437
It took: 0
Press any key to continue . . .
{% endhighlight %}

Oh, it still prints a duration of 0, and it obviously still takes more like 1
to 2 seconds.


# Generated code

So then we look at the assembly in the executable that the compiler generates.

{% highlight nasm linenos %}
    12:     auto start = ::GetTickCount();
 mov         esi,dword ptr [__imp__GetTickCount@0 (09B3000h)]
 push        edi
 call        esi
 mov         edi,eax
    14:     auto stop = ::GetTickCount();
 call        esi
    13:     int result = fib(42);
 mov         ecx,29h
    14:     auto stop = ::GetTickCount();
 mov         esi,eax
    13:     int result = fib(42);
 call        fib (09B1000h)
 mov         ecx,28h
 mov         edx,eax
 call        fib (09B1000h)
    15:     std::cout << result << '\n';
 mov         ecx,dword ptr [_imp_?cout@std@@3V?$basic_ostream@DU?$char_traits@D@std@@@1@A (09B3050h)]
    13:     int result = fib(42);
 add         edx,eax
    15:     std::cout << result << '\n';
 push        edx
 call        dword ptr [__imp_std::basic_ostream<char,std::char_traits<char> >::operator<< (09B3038h)]
 mov         ecx,eax
 call        std::operator<<<std::char_traits<char> > (09B13A0h)
    16:     std::cout << "It took: " << (stop - start) << '\n';
 sub         esi,edi
 push        esi
 push        ecx
 mov         ecx,dword ptr [_imp_?cout@std@@3V?$basic_ostream@DU?$char_traits@D@std@@@1@A (09B3050h)]
 call        std::operator<<<std::char_traits<char> > (09B1160h)
 add         esp,4
 mov         ecx,eax
 call        dword ptr [__imp_std::basic_ostream<char,std::char_traits<char> >::operator<< (09B303Ch)]
 mov         ecx,eax
 call        std::operator<<<std::char_traits<char> > (09B13A0h)
{% endhighlight %}

The compiler reordered the code it generated.

In particular it called `GetTickCount` twice in succession (lines from 1 to
7 above) to obtain `start` and `stop`, and the calculation for `fib(42)` is
only done later (starting at line 8). That explains why the difference `(stop -
start)` is almost always `0`.

In this case it seems that the compiler chose to defer the calculation of
`fib(42)` so that the second call to `GetTickCount` at line 7 can reuse the
value of `esi` set at line 2 to the pointer to `GetTickCount`.

Functions like `GetTickCount` and printing the output could have visible side
effects and their relative order is preserved by the compiler. But for others,
like `fib(42)`, the compiler has full visibility, and it has significant
flexibility, as long as it's calculated before it's printed.

The calculation for `fib(42)` was unrolled a bit. `29h` at line 9 is equal to
`41` decimal and will be used to calculate `fib(42-1)`. `28h` at line 14 is
equal to `40` decimal and will be used to calculate `fib(42-2)`. The results
will be added to calculate `fib(42) = fib(42-1) + fib(42-2)`. This unrolling
saves one test for the argument `42` being less than `2`, but in this
particular case it's not a significant optimisation.

We can't really complain about the optimisation for `GetTickCount`. Ideally
the compiler would have gone further and figured out the result of `fib(42)` at
compile time and just printed the constant (a `constexpr` decoration would
probably helped, but it's not a requirement for such optimisations).

As a side note there is also some interleaving of operations. One example:
`ecx` is set to `29h` at line 9, before calling `fib` at line 13 (part of
eventually calculating `fib(42)`), but in between the result of
`GetTickCount` is moved from `eax` to `esi` at line 11 (which is the
assignment of `stop`).


# Compiler operations graph

Another way of looking at it is that the compiler generates a graph of
operations. Ignoring details like the lower level interleaving, the graph looks
like this:

![Operations Graph](/assets/2019-10-23-compiler-reordering/graph.png)

The compiler in effect performs a topological sort and there is more than one
possible ordering, some of which executes `fib(42)` after assigning `stop`.


# Conclusion

We looked at a counter-intuitive example where the compiler reordered
operations. Although inconvenient in this particular example, it is the result
of optimisations with the goal of improving runtime performance.


# References

- Mike Spertus: [P0342R0 Timing barriers][timing], 30 May 2016

[timing]: http://www.open-std.org/jtc1/sc22/wg21/docs/papers/2016/p0342r0.html
[better-fib]: {% post_url 2016-12-14-eop-fibonacci %}
