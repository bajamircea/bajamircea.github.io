---
layout: post
title: 'Efficient Programming with Components - Perls'
categories: coding cpp
---

Alex Stepanov's pontificative perls from Efficient Programming with Components
(A9 Videos)


Equality is not by default implemented for a `struct` in C++. This comes from
the historic link to C. Copy for `struct`s was implemented in C by default (at
some point) using `memcpy`. The thinking was (wrongly) that `memcmp` needs to
be used for equality, and that (correctly) `memcmp` would not be suitable
because of padding. Instead of `memcmp` memberwise comparison should have been
done by default.

`enum`s were added in C by Dennis (Ritchie?) under duress (given know
limitations like the difficulty to list the options, get the index of the
largest one etc.)

(A related comment from Bjarne Stroustrup: "Even I could design a pretty
language". The point is that his design of C++ took into account important
concerns such as backward compatibility, efficiency, ability to solve a variety
of problems. Addressing concerns like this is hard and it results in a less
pretty language)

Relative efficiency refers to solution that is as efficient as other solutions
possible in the language. Absolute efficiency refers to a solution that is as
efficient as possible on that hardware (i.e. as assembly).

As a quick method to evaluate a language pay attention on how the following
three functions can be implemented: swap, min and linear find.

Implicit conversions in C++ come from C. The need for them in C arises from
needs to deal with functions like `double sqrt(double);` and the lack of better
mechanisms like function overloading, templates etc.

Do not do unnecessary work.

Do not optimise uncommon cases.

One reason for using `<` as the default comparison in algorithms is that
sorting numbers with `<` results in an ascending sequence which is the natural
order for numbers.

`std::max` is not ideal: for equal values it returns the first, hence is not
stable.


# References

A9 Videos: Efficient Programming with Components<br/>
[https://www.youtube.com/watch?v=aIHAEYyoTUc&list=PLHxtyCq_WDLXryyw91lahwdtpZsmo4BGD][a9-efficient]

Bjarne Stroustrup - The Essence of C++: With Examples in C++84, C++98, C++11,
and C++14<br >
[https://www.youtube.com/watch?v=D5MEsboj9Fc][cpp-essence]

[a9-efficient]: https://www.youtube.com/watch?v=aIHAEYyoTUc&list=PLHxtyCq_WDLXryyw91lahwdtpZsmo4BGD
[cpp-essence]: https://www.youtube.com/watch?v=D5MEsboj9Fc
