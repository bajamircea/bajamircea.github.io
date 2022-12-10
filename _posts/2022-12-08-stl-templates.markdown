---
layout: post
title: 'Templates and STL'
categories: coding cpp
---

Templates and STL come to C++.

This article is part of a series on [the history of regular data type in
C++][regular-intro].


# Templates

One difference between C and C++ is that the latter added support for
abstractions. And containers are important abstractions. But it's also useful
if they can be reused for different types in the container.

For a while Bjarne Stroustrup believed C macros are enough. The reality is that
in small programs macros. But at scale, in large code bases with many
independent developers, it's easy to get conflicting macros. Some particular
macros are particularly tempting: `MAX`, `LOG`, `LIST`, `TRUE`, `BOOL`, `WORD`.

So then Bjarne Stroustrup introduced templates in early 1990s. Now templates
are not entirely different from macros, fundamentally they are still: "here is
a recipe to copy-paste with some configuration". But on the other side they
have enough differences that puts them to a different level. Sure, the compiler
template error messages can be notoriously difficult, but they are noting like
the horror stories that come from macros such as:

{% highlight c++ linenos %}
#define private public
// or
#define true 1
// or
# define min(a, b) a < b ? a: b
{% endhighlight %}

Templates come with restrictions to patterns that more complete compared with
the macros above, They also have some mechanisms like specialization,
overloading etc.

With this the search for a container library to be included in the C++ standard
started.


# STL

Alex Stepanov became interested in generic algorithms and data structures in
the 1970s. And he kept on trying to implement such libraries for academical
languages, for Ada, then eventually for C++ when he got a job at the Bell Labs
where he encountered (among others) Bjarne Stroustrup.

Back then, in the 1987 or so, C++ did not had templates, he urged Bjarne
Stroustrup however to also add templates for functions (i.e. so that he can
implement algorithms, not just containers.

Then he went to HP Labs and worked on what became the STL: the Standard
Template Library. It used the C++ templates that were added in the meantime to
create a large library of algorithms and containers.

In 1993 through a fortunate sequence of events that also involved Andrew Koenig
from the C++ Standards Committee, large parts of STL were incorporated in the
C++ standard library. It's design influenced later parts of the C++ libraries.


# Regular concept

C++ concepts arose from questions around generic algorithms and data structures
The point of "generic" is that you have a reusable implementation that accepts
different types. You need to plan, and eventually define, the characteristics
of those types for which the generic algorithms and containers library would
work. Most developers are familiar with iterator concepts e.g. bidirectional
iterator. Alex Stepanov in in the early to mid 1990s had a vision on how they
can be incorporated into C++ (took about 35 years):

> What is an iterator? Not a class. Not a type. It is a concept. [...] It is
> something which doesn't have a linguistic incarnation in C++. But it could.

The regular concept arouse from questions like: "__if you design a `vector` as
a resizable array container, what types should the `vector` template
accept?__". Surely `int`, otherwise utility and efficiency are lost. What of
the properties of `int` make it suitable for `vector`. Surely not `operator+`,
but subtle things like the ability to copy. Algorithms often also rely on
equality and order so that values can be found. And equality better be working
consistently with copy: a copy must be equal to the original.


# References

[The Design of C++, lecture by Bjarne
Stroustrup](https://www.youtube.com/watch?v=69edOm889V4) recorded in March
1994.

Al Stevens Interviews Alex Stepanov: Dr. Dobb's Journal, March 1995.
[See http://stepanovpapers.com/](http://stepanovpapers.com/) or [web
archive](https://web.archive.org/web/20171205042113/http://www.sgi.com/tech/stl/drdobbs-interview.html),
(e.g. from which the quote above is taken).

[regular-intro]:   {% post_url 2022-11-16-regular-history %}
