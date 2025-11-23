---
layout: post
title: 'Idiom: regular data and functions'
categories: coding cpp
---

Handling normal, pure data and functions.


This article is part of a series of [articles on programming
idioms][idioms-intro].

This idiom is suitable for when you just have some data, a group of values on
which processing is just pure calculation producing different data that is then
transferred elsewhere.

# Regular data

If you want some number you use `int`.

If you want some string you use `std::string`.

If you want group some pieces of data you build your own class like this in C++20:

{% highlight c++ linenos %}
struct person
{
  std::string first_name;
  std::string last_name;
  int age{};

  constexpr std::strong_ordering
    operator<=>(const person &) const noexcept = default;
};
{% endhighlight %}

Other than the `operator<=>` gobbledigook it looks straightforward.

Though a combination of the special operations that the compiler defaults
implicitly and the comparison that is defaulted explicitly, you end up with a
class that is very much like the `int` and `std::string`:
- you can default construct an instance
- you can destroy it (when it gets out of scope)
- you can copy and move
- it has equality and order

And these operators work properly, e.g. if you take a copy, the copy is equal
to the original: it's a regular class.

**Regularity is really the benchmark on which other types will be judged** i.e.
"this other type really can't be regular because ..."

You can compose this kind of classes on top of `person` in a similar fashion by
having a `person` as a member.


# Regular functions

You might obtain a `person` instance by parsing a JSON string or you might
check that the `age` member is in a reasonable range.

{% highlight c++ linenos %}
person person_from_json_string(const std::string & input) {

  person return_value;

  // parse the input and assign to members
  return_value.first_name = ...;
  return_value.last_name = ...;
  return_value.age = ...;

  return return_value;
}

bool is_valid_age(const person & x) {
  return (x.age >= 0) && (x.age < 150);
}
{% endhighlight %}

These are functions that just do calculations on regular data and called again
on equal inputs they return equal results: they are regular functions.

They take regular types as arguments, by `const &` usually, unless very small
like `int` when they go by value. Errors are usually rare, mostly out of memory
and exceptions are the way to indicate errors.

Notice how characteristics of the regular data already come useful even in this
simple example: default constructor: to "just" declare the `return_value`
variable, equality for the tests.


# Testing

Regular entities are easy to test, you can write pure unit tests in the style
"for these input values, expect output equals this value": value testing.

{% highlight c++ linenos %}
TEST(person_from_json, trivial)
{
  person actual  = person_from_json_string("...");
  person expected{
    .first_name = "Father",
    .last_name = "Christmas",
    .age = 100
  };
  ASSERT_EQ(expected, actual);
}
{% endhighlight %}

Note: using the dots for the fields we initialize is called _designated
initializer list_.

We often think this as a unit test for the `person_from_json_string` function.
It indirectly tests `person` as well, though often we would not write an
explicit test for `person`.


# STL style containers and algorithms

Related and supporting the regular idiom are STL style containers and
algorithms.

If you need to store several `person` instances you use a
`std::vector<person>`.

Containers like `std::vector` or `std::string` have to explicitly define all
the operations that are required for a regular class. For example they need to
explicitly implement the copy assignment `container operator=(const container &
other)` the details of which are quite low level especially for a generic,
library quality type (e.g. the destination buffer, if large enough, can be
reused).  Their implementation lacks the simplicity of the `person` type above.
But the net result is that such a container accepts regular types and itself
it's a regular type when instantiated with regular types.

You can use `std::sort` to sort the vector. And it can be sorted by a different
criteria, e.g. by the value of the `age` member variable. Assuming such a
sorted vector, you can use `std::equal_range` to find the range of people
having a certain age, or just use `std::lower_bound` to find the beginning of
the range (the position where the first `person` of a certain age would be).

The iterators used for such positions are almost as regular, but they miss
order (they only have equality).


# Why this idiom works?

The reason it works is that it maps to the way computers work: data is memory,
functions are instructions, it does not need additional virtual machine
processing to adapt the code world to the real hardware world.

The data types define how to interpret memory. On a typical 64 bit machine our
`person` class has for each string 3 pointers of 8 bytes each (or a bit more to
allow for small string optimisation), the pointers pointing to heap allocated
arrays of `char`s, followed by integer of 4 bytes (signed, two's complement
representation), followed by a padding of 4 bytes (so that in an array the
string pointers are aligned to a multiple of 8 address).

Of the characteristics of a regular data type, some are programming related
like destructors, move, default constructor. But others like copy, equality and
order are the very things that allow for mathematical reasoning involved in
algorithm design, optimisations, costs and performance.

Concretely, if you think about it, `std::sort` needs to be able to move things
around (a sorted sequence is a permutation of the original) and it needs that
the data type can be ordered.

**Historical note**: The design of STL, that was incorporated and extended into
the C++ standard libraries, was intended to provide generic solutions to handle
these regular data types and functions. The terminology **regular** comes
ultimately from the design of STL (i.e. from asking the question of what kind
of types should the containers be able to hold).

Note: The `std::regular` concept in C++20 is a downgrade on the requirements as
shown in this table:

<table>
<tr>
  <th>Characteristics</th>
  <th>Elements of Programming</th>
  <th>Standard library</th>
</tr>
<tr>
  <th>Fully regular e.g person</th>
  <td>Regular (basically as used here)</td>
  <td>-</td>
</tr>
<tr>
  <th>Without order</th>
  <td>Semiregular (probably)</td>
  <td>std::regular</td>
</tr>
<tr>
  <th>Without equality</th>
  <td>-</td>
  <td>std::semiregular</td>
</tr>
</table>

The downgrade is probably the result of the effort to accommodate more weird
scenarios in the standard library.


# Compared with OOP

This approach diverges from the traditional object oriented programming
(approach).

`person_from_json_string` is not a member function, it's just a standalone
function. The common OOP choice of making such a function a member of the
`person` type is more a reflection of the fact that usually `std::string` is
not user defined, but `person` is and can be extended, rather than some sound
principle.

Members of `person` are not private, they don't have getters and setters.
`const person` allows read-only access to the members. Direct access to member
variables comes useful sometimes e.g. to move into their values.


# What are its limits?

Not all the functions that are pure calculation are regular. E.g. `addressof`
for any type and also `capacity()` for `std::string` and `std::vector` are not
regular.

A function like
{% highlight c++ linenos %}
std::string download_url(const std::string & url);
{% endhighlight %}
looks very much like the regular functions above, but is not regular if it
connects to the network and at different times will return different results.

Not all the work done by a computer is pure calculation and for that [we'll
look at another idiom][cwrapperidiom].

[idioms-intro]:    {% post_url 2022-10-17-idioms %}
[cwrapperidiom]:   {% post_url 2022-10-23-c-api-wrap-idiom %}

