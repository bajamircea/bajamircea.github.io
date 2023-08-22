---
layout: post
title: 'Shallow vs. deep'
categories: coding cpp
---

Brief note on terminology that is fine for describing an element of a class
design, but not useful when deciding how to design a class.


# Const and pointers

When you have an `int` variable, `const` can be used before or after the type,
it's just a matter of taste, it does not make a difference to the type of the
variable.  You can't change the value for a `const int`, but you can take a
(non const copy and change the copy as much as you want to:

{% highlight c++ linenos %}
const int some_int = 41;

// equivalent to:
// int const some_int = 41;

// would get an error:
// some_int = 42;

int another_int = some_int;
another_int = 42;
{% endhighlight %}


When you have a pointer however, it does matter if the `const` is before or
after the `*`, you can have both or either. The `const` preceding `*` refers to
the pointed type: can't change the pointed value. The `const`, following `*`
refers to the value of the pointer: can't change the pointer itself, but can
take a (non const) copy, and change the copy as much as we want to (to point to
something else).

{% highlight c++ linenos %}
const int * const some_ptr = &some_int;

// equivalent to:
// int const * const another_ptr = &some_int;

// pointer to const int, pointed value is const
const int * ptr_to_const = some_ptr;
// can't do this:
// *ptr_to_const = 42;
// or this
// *some_ptr = 42;
// but can do this:
ptr_to_const = nullptr;

// pointer to int, pointer is const
int * const ptr_const = &another_int;
// can't do this:
// ptr_const = nullptr;
// or this:
// some_ptr = null_ptr;
// but can do this:
*ptr_const = 42;
{% endhighlight %}


# Examples

## std::vector

`std::vector` typically stores three pointers to manage the start , the used
and the available space of the dynamically allocated array.

Despite these pointers, when you put `const` in front of a vector, it behaves
like an `int`: can't change the values in the vector. When you take a copy of
the vector it copies all the values of the vector, not just the three pointers.
When you compare two vectors, it compares the values, not the three pointers.

One shortcut is to say that vector propagates `const` deep, does a deep copy,
implements deep comparison.

The deep `const` behaviour is why we use way more often `const
std::vector<int>` than `std::vector<const int>`.


## std::shared_ptr

`std::shared_ptr` however has pointer semantics: `const std::shared_ptr<int>`
means can't change this pointer, but can change the pointed value, copy points
to the same thing as the original rather than copy the pointed value,
comparison compares the underlying pointer.

We say that `std::shared_ptr` uses shallow `const, shallow copy and shallow
comparison.


## std::string_view and std::span

`std::string_view` and `std::span` provide views into contiguous sequences. To
do that they each typically store two pointers.

They copy shallow (like pointers), but then they diverge.

`std::string_view` offers a immutable view, so `const std::string_view`, or not
`const`, the view is constant, to say that constness propagates deep is somehow
incorrect: it's always deep const. `std::span` offers a mutable view, so
`const std::span<int>` is shallow i.e. can't change the pointers, but can
change the pointed values; use `std::span<const int>` to make the view
constant.

Comparison operations of `std::string_view` perform a deep comparison,
comparing the pointed sequence. `std::span` does not implement comparisons.


# Discussion

Using terminology like deep or shallow is only useful as a quick descriptive
word, but it does not offer any clue into why the examples above were designed
that way and what is good choice for a new type. A better insight is given by
the thought that good types behave properly. One reasonable expectation is
the following:

> Axiom: If you take a copy and change the original, then the copy is different
> from the original

This is only one of the many expectations of a regular concept in particular.
Even if you design a class that's not regular, it's often better to not
implement behaviour that would lead to confusing behavior (e.g. not implement
copy, move, comparisons) than to implement it and contradict axioms like the
one above.

When we look at it this way, it makes sense that `std::vector` does deep copy,
`const` and comparisons: it's like an int. It makes sense that
`std::shared_ptr` does it shallow: it's like a pointer. `std::string_view` gets
away with a combination of shallow copy and deep compare because it's a
constant view: the deep compare is debatable, but it's handy as well.
`std::span` does not get away with a combination of shallow and deep because
it's not a constant view; a combination of shallow copy, shallow `const` and
deep compare would not meet the axiom above.

