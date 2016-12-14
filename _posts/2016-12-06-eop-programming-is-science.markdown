---
layout: post
title: 'EOP: Programming is science'
categories: coding eop
---

The first in a series of articles on Alex Stepanov's awesome book "Elements of
Programming", looks at a basic, but the most important idea in the book.


# Introduction

> "This book contains some of the most beautiful code I've ever seen"<br/>
> &nbsp; &nbsp; - Bjarne Stroustrup on "Elements of Programming":

"Elements of Programming" is a book by Alex Stepanov (of C++ STL fame) and Paul
McJones. It's a relatively short book: about 250 pages, with lots of deep,
inspiring ideas: a gem. An easy read it is not, this is a difficult book.

I came across the book while following the proposals for concepts in C++17 when
I figured out that this book is where some of the original ideas for concepts
came from. So I purchased the book, and I hoped I will read it in the evenings.
But the first day I only managed a couple of pages, so then in my summer
holiday I decided to not take my laptop and focus on the bool. And that worked
at about 20 pages per day in almost two weeks ... I did it.

Here are two examples of what I mean by difficult, but rewarding.

# Example 1

>  &nbsp; An entity belongs to a single species, which provides the rules for its
> construction or existence. An entity can belong to several genera, each of
> which describes certain properties.<br/>
>  &nbsp; We show later in the chapter that objects and values represent entities,
> types represent species, and concepts represent genera.

The book starts with a lot of definitions and dense statements like the ones
above. For me that's one of the reasons I found it hard to read it at a
leasurly pace in the evenings.

The beauty is that these dense statements have long reaching consequences. For
example that the classical object oriented programming way of using inheritance
is not sound.

Here is a concrete example. If I were to represent myself on a computer I would
have an object of a type `Person`. And a person belongs to several categories
(genera) like it is a mammal, a living being.

When using classical interfaces you would create interfaces `Mammal`, and
`LivingBeing` and, using inheritance, you would create a hierarchy `Person
> Mammal > LivingBeing`. But over time we discover new genera that a type
belongs to (I'm a citizen as well). In the classical inheritance approach we
have to go back to each type and inherit from new interfaces. That might not be
possible e.g. we can't change types in other libraries or fundamental types
like `int`.

For an alternative, see the STL containers that all happen to have a `size()`,
but do not derive from a `WithSize` interface.

# Example 2

Below is a little short function from the book. Can you guess what it does (in
the five lines from 6 to 10)?

{% highlight c++ linenos %}
template<typename T>
  requires(ArchimedeanMonoid(T))
T fn(T a, T b)
{
  // Precondition a >= b > 0
  if (a - b >= b) {
    a = fn(a, b + b);
    if (a < b ) return a;
  }
  return a - b;
}
{% endhighlight %}

That's the other thing about the book. All the code samples are short. But they
require long explanations. This is the opposite of my daily experience
of reviewing code where more often than not I'm looking at long pieces of code
that accomplish the functionality in ways that are more difficult than
required.

I came to love the code above:

- for the care of expressing requirements and preconditions
- for deciding how to pass arguments (by value in the case above)
- for the careful test in the `if` condition to avoid overflows.
- for being generic (it would work with `int` and with a custom type expressing
  fractions)


# The most important idea: programming is science

For me the most important idea in the book is that programming is science. In
particular the book makes a strong case in that there are strong connections
with mathematics.

This might soud trivial, but I see so many examples of pseudo-science in
programming.

In particular when we have to make a judgment/or a decission (should we go with
`A` or with `B`?) there are two valid approaches (or a combination of):

- we're in a hurry, we make a arbitrary choice, we go on with the main task. If
  we realise it was a bad choice that stops us from accomplising the task we go
  back and make the other choice.
- we make an informed choice based on rigurous reasoning

The pseudo approach I often see is when an arbitrary choice was made, but it is
presented as if it THE TRUE ONE when it is actually flawed logically.

# References

- [Elements of Programming - on amazon.co.uk][eop-amz]

[eop-amz]: https://www.amazon.co.uk/d/cka/Elements-Programming-Alexander-Stepanov/032163537X

