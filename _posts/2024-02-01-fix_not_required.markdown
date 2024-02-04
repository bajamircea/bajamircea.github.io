---
layout: post
title: 'Fix not required'
categories: coding cpp
---

An interesting lesson on C++ capabilities and complexity and an introspection
on developer's thinking process.


# Problem

You want a type to store a JSON value: a simple one (like null, number,
boolean, string) or a compound one (like a sequence/array or a
dictionary/object). How hard can it be?

So you start with a `std::variant`:

{% highlight c++ linenos %}
using Value = std::variant<std::monostate, int, double, bool, std::string,
  std::vector<Value>, std::map<std::string, Value>>;
// fails here ^ with "'Value' was not declared in this scope"
{% endhighlight %}

This does not work. When encountering `std::vector<Value>` on line 2, the
compiler will error with something like `'Value' was not declared in this
scope`, because `Value` can only be used after the semicolon `;` at the end of
the line 2.

This is because `using` is used in this context to create an alias (an
alternative name) to a type and the alias cannot be used (currently) to define
the very thing that it tries to name.


# Attempt 1: usage of incomplete type

We can declare a `struct` and have the variant as a member variable:

{% highlight c++ linenos %}
struct Value
{
  std::variant<std::monostate, int, double, bool, std::string,
    std::vector<Value>, std::map<std::string, Value>> data;
};
{% endhighlight %}

Unlike the `using` above, this works. When the compiler encounters
`std::vector<Value>` on line 4, the `Value` type is incomplete, which allows
using it subject to limitations regarding the size of `Value`. And it does not
matter because the size of `data` depends on the size of `std::vector<Value>`,
which is typically three pointers (for begin, end and capacity), it does not
depend on the size of `Value` (similarly for the `std::map`).

This is a very old trick, required to do basic things such as to define the
`Node` in a linked list. The compiler can determine below the size of a `Node`:
it's the size of the member variable, which is a pointer:

{% highlight c++ linenos %}
struct Node {
  Node * next;
  // more members here
};
{% endhighlight %}

However the code below does not work, we hit the limitations of an incomplete
type, because to determine the size of a `Node` the compiler needs to know the
size of the member `x`, which is of the size of a `Node`: the very thing that
it tries to establish to start with.

{% highlight c++ linenos %}
struct Node {
  Node x;
  //   ^ error "field 'x' has incomplete type 'Node'"
};
{% endhighlight %}

The problem with this solution is that we have to keep on using `.data` to
access the value we're looking for inside a variable of type `Value`. That is
not the end of the world, but we've been there before: overuse of `c_str()` for
strings anyone?


# Attempt 2: "fix"

This second attempt uses the advice from [a stackoverflow answer using the Fix
type][stack]:

{% highlight c++ linenos %}
template<typename T>
using Var = std::variant<std::monostate, int, double, bool, std::string,
  std::vector<T>, std::map<std::string, T>>;

template <template<typename> typename K>
struct Fix : K<Fix<K>> {
  using K<Fix>::K;
};

using Value = Fix<Var>;
{% endhighlight %}

There are three parts to the code above.

The first is straight forward. It declares `Var` as a alias for a variant where
actual type to store in the `std::vector` and `std::map` is a type `T` to be
specified later.

The last part just declares that our `Value` type is a instantiation of `Fix`
with `Var` as a template parameter.

But the middle part declaring `Fix` is relatively unusual despite it's brevity.

The stackoverflow answer provides a link to the [wikipedia page describing the
fixed-point combinator][wiki]. In summary, it's about a higher-order function
which takes a function as an argument and returns a value that maps to itself
of its argument function (if such a value exists). The claim is that the `Fix`
template does such a thing at compile time, therefore the name "fix" does not
mean the verb "to repair", but rather the verb "to fasten something in a
particular place".

But I find it really hard to determine how the code maps to the mathematical
idea (we deal with types, not functions), so let's look at the three elements
of `Fix`.

First: it's a template, the template parameter `K` is a "template template
parameter". Let's remind ourselves. A template parameter is usually a type,
Also sometimes it can be something that's not a type e.g. an integral value.
But there is a third choice, where the template parameter is a type which
itself it is a template: a "template template parameter". That template that
`K` is, takes one type as a template parameter.

Second: `Fix` is derived from `K<Fix<K>>`. Later, in `using Value = Fix<Var>`,
`Fix` ends up instantiated with `K` being `Var`, so this is an attempt to
derive from a `Var` instantiated with the derived type. Deriving from a base
class that uses the derived class as a template argument is a known pattern
called [curiously recurring template pattern][crtp], but in this case it's a
more unusual usage because `K` is a template template parameter.

Third: the constructors of the base class are lifted in the derived class. This
means that the derived class, which is meant to keep a JSON value, can be
constructed from an `int`, `std::string`, etc. in the same as a the base class
can, the base class being a `std::variant` of those.

This attempt achieves the goal of not having to use `.data` to reach the value.
This is because inheritance from `std::variant` creates the situation where the
derived class **is** a variant compared with the previous attempt where the
class **has** a variant as a member variable.

But it does so with a significant cost of complexity. Sure, it's one off
complexity, which makes usage easier, but despite it's brevity **it's still
code that very few would be able to completely understand and explain how it
works**.


# Attempt 3: "no fix"

But what if from the previous attempt we try to keep the essential parts: the
inheritance mechanism and the `using` to lift the constructors. Then we end
with something like:

{% highlight c++ linenos %}
template<typename T>
using Var = std::variant<std::monostate, int, double, bool, std::string,
  std::vector<T>, std::map<std::string, T>>;

struct Value : Var<Value> {
  using Var<Value>::Var;
};
{% endhighlight %}

This solves the problem of the first attempt, no need to use `.data`, but with
much lower complexity than the second attempt, the troubling `Fix` is gone,
we're left with
- a `using` statement for `Var` (it makes sense, it's used more than once
  later)
- inheritance from `Var` instantiated with the derived type
- a `using` statement to lift the constructors of the base class into the
  derived one

We can use `Value` like this:

{% highlight c++ linenos %}
int main() {
  Value a{ 42 };
  Value b{ "some string" };
  Value v = std::vector<Value>{ a, b };
  return std::get<int>(std::get<std::vector<Value>>(v)[0]);
  // returns 42
}
{% endhighlight %}


# Discussion

Even the final solution is not trivial. But it actually demonstrates a strength
of C++. We started with a very specific requirement and we could accomplish it,
most importantly to simplify the usage which helps since most types are used
more than once.

There are psychological obstacles in transitioning between the solution
attempts. The first attempt requires you to use `.data` to access the value.
It's easy to just stop there. The second attempt is very complex, it's hard to
not be overwhelmed by the details of the complexity and continue to look for a
simpler solution.


# References

[Stack overflow answer using the Fix type][stack]

[Wikipedia page on the Fixed-point combinator][wiki]

[Wikipedia page on Curiously recurring template pattern][crtp]


[stack]: https://stackoverflow.com/questions/53502760/in-c-how-to-make-a-variant-that-can-contain-a-vector-of-of-same-variant/53504373#53504373
[wiki]: https://en.wikipedia.org/wiki/Fixed-point_combinator
[crtp]: https://en.wikipedia.org/wiki/Curiously_recurring_template_pattern
