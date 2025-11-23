---
layout: post
title: 'std::string_view corners'
categories: coding cpp
---

`std::string_view` introduction and the dark corners of its usage


# Motivation

## Functions taking const char pointers

Given the function below taking a char pointer:

{% highlight c++ linenos %}
void foo_taking_char_ptr(const char * input);
{% endhighlight %}

It can be straight forward called with a literal string:

{% highlight c++ linenos %}
foo_taking_char_ptr("some string");
{% endhighlight %}

However, if we have a `std::string`, for example returned from a function
`bar`:

{% highlight c++ linenos %}
std::string bar() {
  return "abc"; // constructs, then returns, a std::string containing "abc"
}
{% endhighlight %}

Then we need to use `c_str()`:

{% highlight c++ linenos %}
foo_taking_char_ptr(bar().c_str());
{% endhighlight %}

Using `c_str()` is inconvenient, but efficient.


## Functions taking const std::string references

Similarly the function below taking a string reference:

{% highlight c++ linenos %}
void foo_taking_string_ref(const std::string & input);
{% endhighlight %}

Can be straight forward called with a `std::string`

{% highlight c++ linenos %}
foo_taking_string_ref(bar());
{% endhighlight %}

Can be called with a string literal:

{% highlight c++ linenos %}
foo_taking_string_ref("some string");
{% endhighlight %}

However in the latter case, the call will allocate a temporary `std::string`,
possibly involving a memory allocation, which is not efficient, despite the
convenient syntax.

# Enter std::string_view

## What it is?

A pointer and a size (or two pointers). It provides a constant view into either
a `std::string` or a string literal, a sub-range of, or any other contiguous
sequence of characters. The pointer points at the beginning, the size is the
length of the sequence (or pointer to one past the last, i.e the end). It's a
constant view, it does not allow changing the sequence it points to (in order
to be able to provide views into literal strings).


## Functions taking std::string_view

This function taking a `std::string_view` by value (yes, not by const
reference):

{% highlight c++ linenos %}
void foo_taking_string_view(std::string_view input) {
  // can use input.begin(), input.end()
  // and input.data(), input.size(), etc.
}
{% endhighlight %}

Can be straight forward called with a `std::string`

{% highlight c++ linenos %}
foo_taking_string_view(bar());
{% endhighlight %}

Can be called with a string literal:

{% highlight c++ linenos %}
foo_taking_string_view("some string");
{% endhighlight %}

With no issues about lack of convenience or efficiency.


# Usage corner cases

## It's not zero terminated

Maybe it is, but **can't rely on it**.

{% highlight c++ linenos %}
void bad_foo(std::string_view input) {
  FILE * f = fopen(input.data(), "r");
  ...
}
{% endhighlight %}

You would need instead something that would ensure that the sequence is zero
terminated, maybe named`zstring_view` or similar.

You can of course take a copy and ensure it's zero terminated

{% highlight c++ linenos %} 
void copying_foo(std::string_view input) {
  std::string file_name(input);
  FILE * f = fopen(file_name.c_str(), "r");
  ...
}
{% endhighlight %}

But then this is fake economy of allocations, because calling `copying_foo`
with a `std::string` results in an unnecessary copy into `file_name`.

Also if this is repeated then this repeats the copy into `std::string` for zero
termination purposes to call into C APIs.

{% highlight c++ linenos %}
void copying_foo_usage() {
  std::string input = get_file_name();

  copying_foo(input); // takes a copy to zero terminate
  // some more code, then use it again:
  copying_foo(input); // takes another copy to zero terminate
}
{% endhighlight %}

Practically (short of using some `zstring_view`), the solution of passing a
string is not too bad: it only allocates unnecessarily if the original argument
is a literal string.

{% highlight c++ linenos %} 
void foo_taking_string(const std::string & input) {
  FILE * f = fopen(input.c_str(), "r");
  ...
}
{% endhighlight %}

{% highlight c++ linenos %}
void foo_taking_string_usage() {
  std::string input = get_file_name();

  foo_taking_string(input); // no allocation
  // some more code, then use it again:
  foo_taking_string(input); // no allocation
}
{% endhighlight %}

## Using std::string_view variables is risky

The example below is incorrect, it creates a dangling pointer situation:

{% highlight c++ linenos %}
std::string_view a = bar();
foo_taking_string_view(a);
{% endhighlight %}

That's because the `std::string` returned by `bar()` is a temporary that gets
destroyed on the same line. By the time `a` is used, as a function argument, it
points to destroyed data.

The example below is correct, but non idiomatic:

{% highlight c++ linenos %}
std::string b = bar();
std::string_view c = b;
foo_taking_string_view(c);
{% endhighlight %}

That's because the scope of `b` is larger than the scope of `c`.

The example below is incorrect, it again creates a dangling pointer situation:

{% highlight c++ linenos %}
std::string d = bar();
std::string_view e = d + "something";
foo_taking_string_view(e);
{% endhighlight %}

That's because the plus operator returns a temporary that gets destroyed on the
same line. By the time `e` is used, as a function argument, it points to
destroyed data.

The example below is correct, it's idiomatic usage:

{% highlight c++ linenos %}
std::string f = bar();
foo_taking_string_view(f);
{% endhighlight %}

The example below is correct, it's also idiomatic usage:

{% highlight c++ linenos %}
foo_taking_string_view(bar());
{% endhighlight %}

And yet, why is it correct? Specifically: what guarantees that the temporary string returned
from bar is still alive by the time foo is executed?

Or put another way: what guarantees that the temporary string is not destroyed
as soon as the temporary string_view is constructed, before foo is executed?

The C++ standard quote ensuring correctness for the last example is:

> Temporary objects are destroyed as the last step in evaluating the
> full-expression that (lexically) contains the point where they were created.

Plainly put: the temporary returned by `bar()` gets destroyed after the
semicolon `;`.

The moral is probably: **avoid `std::string_view` variables, their usage is
risky** (as opposed to usage as function arguments).

The reason the risky usage is not prevented is that the easy mechanisms of
preventing it (such as `std::string_view` not allowing construction from
temporary `std::string`) would also prevent idiomatic usage (provide temporary
to a `std::string_view` argument function call).


## Not quite Regular

Another way of looking at it is that `std::string_view` behaves like a
reference (underlying it has a pointer).

That way of thinking makes for alternative reasoning with regards to usage
e.g.:
- pass by value, when a function argument, like a pointer
- a variable that points to a temporary will become dangling when the temporary
  gets destroyed

But **`std::string_view` shares with references issues with regards to the
applicability of the `Regular` concept**:

{% highlight c++ linenos %}
std::string g = bar();
std::string_view h = g; // take a copy
assert(h == g); // copy is same as original
g[0] = 'z'; // change original
assert(h == g); // not Regular behaviour, but expected for references
{% endhighlight %}

For a `Regular` type, when you copy construct, the copy is equal to the
original, but if the original changes, the copy is no longer equal.

That is not the case for `std::string_view`, making it not quite `Regular`.

