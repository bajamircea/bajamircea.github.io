---
layout: post
title: 'Pragmatic StrictTotallyOrdered structs'
categories: coding cpp
---

How to implement comparisons for user defined data structures, using `tie`,
before better reflection capabilities are added to C++


# Introduction

Say you define a custom data structure.

{% highlight c++ linenos %}
struct person {
  std::string first_name;
  std::string last_name;
  int age;
};
{% endhighlight %}

Soon you'll want to check if two `person` objects are equal. This requires `==`
to be defined. Then you'll want to be able to sort an array of `people`
objects. This requires `<` to be defined. And soon you'll want the counterparts
`!=`, `>`, `<=`, `>=` defined as well.

If all these comparisons are defined in a sane way the type is said formally to
meet the `StrictTotallyOrdered` [concept][concepts-basics]. Then you can use
the type `person` such as below:

{% highlight c++ linenos %}
person bob_smith{ "Bob", "Smith", 42};
person bob_builder{ "Bob", "Builder", 5};

if (bob_smith != bob_builder) {
  std::cout << std::min(bob_smith, bob_builder).last_name << '\n';
}

// Prints: Builder
{% endhighlight %}

The comparisons are not implemented by default for a `struct` in C++. This
comes from the [historic link to C][pearls].

So then the programmer needs to implement these operators. The naive approach
is tedious, repetitive and requires care (with regards to how `<` is
implemented for example) even when most of the time we would be happy if the
implementations just check member variables in order. Formally this is said to
be lexicographical comparison.

I've covered various parts of achieving it elsewhere, but here it is put
together:

- It uses the [tie trick][tie-trick] to define a helper function that returns a
  tuple of references to the member variables. This allows to only repeat the
  member variables once, and will rely on `std::tuple` to do the work for `<`
  in particular.
- It uses a template to [check that all the member][reflection] variables were
  included. It basically checks that a structure with the same member variables
  has the same size as our type. This check is not perfect, but catches errors
  often enough.
- It does not use inheritance or additional member functions, keeping the
  structure simple as it should be. It uses a macro instead, which is the
  undesired downside.

When reflection will be available in C++, [better solutions will be
possible][reflection].

# person.h header file
{% highlight c++ linenos %}
#pragma once

#include "tie_with_check.h"

#include <string>

struct person {
  std::string first_name;
  std::string last_name;
  int age;
};

inline auto tie_members(const person & x) noexcept {
  return tie_with_check<person>(x.first_name, x.last_name, x.age);
}

MAKE_STRICT_TOTALY_ORDERED(person)
{% endhighlight %}

The effort to make `person` meet `StrictTotallyOrdered` concept is small. It
involves:

- Include an additional header
- Define a method `tie_members` straight after the `struct` definition.  This
  involves an unfortunate repeat of member variables in the same order as they
  appear in the `struct` definition
- Call preprocessor macro `MAKE_STRICT_TOTALY_ORDERED` to implement comparison
  operators based on `tie_members`


# tie_with_check.h header file

The more complex parts are in this header, but it's reusable.

{% highlight c++ linenos %}
#pragma once

#include <tuple>

template<typename ... Args>
struct struct_layout;

template<typename T0>
struct struct_layout<T0>
{
  T0 m0;
};

template<typename T0, typename T1>
struct struct_layout<T0, T1>
{
  T0 m0;
  T1 m1;
};

/*
Keep on specializaing struct_layout to the maximum number of member variables.
Use this python3 script to generate specializations for struct_layout:
{% raw %}
for i in range(0,30):
  print("template<{0}>\nstruct struct_layout<{1}> {{\n{2}\n}};\n".format(
    ", ".join("typename T{0}".format(j) for j in range(0, i + 1)),
    ", ".join("T{0}".format(j) for j in range(0, i + 1)),
    "\n".join("  T{0} m{0};".format(j) for j in range(0, i + 1))
    ))
{% endraw %}
*/

template<class T, typename ... Args>
auto tie_with_check(Args & ... args) noexcept
{
  static_assert(sizeof(T) == sizeof(struct_layout<Args...>),
      "You forgot a member variable");
  return std::tie(args...);
}

#define MAKE_STRICT_TOTALY_ORDERED(some_type) \
inline bool operator==(const some_type & x, const some_type & y) noexcept { \
  return tie_members(x) == tie_members(y); \
} \
inline bool operator!=(const some_type & x, const some_type & y) noexcept { \
  return !(x == y); \
} \
inline bool operator<(const some_type & x, const some_type & y) noexcept { \
  return tie_members(x) < tie_members(y); \
} \
inline bool operator<=(const some_type & x, const some_type & y) noexcept { \
  return !(y < x); \
} \
inline bool operator>(const some_type & x, const some_type & y) noexcept { \
  return y < x; \
} \
inline bool operator>=(const some_type & x, const some_type & y) noexcept { \
  return !(x < y); \
}

{% endhighlight %}

The `tie_with_check` arguments are similar to `std::tie`. They are passed by
reference, but in the way the function is used in `tie_members`, the types of
the `tie_with_check` arguments are actually `const` references. They are
automatically deduced by the compiler. It passes the arguments to `std::tie`
and uses them as the return value (a tuple of references).

For example when used for the `person`, the `Args...` are `const std::string &,
const std::string &, const int &`, and the return type is `std::tuple<const
std::string &, const std::string &, const int &>`.

In addition to that, the function checks that the size if the type `T` is the
same as the size of a structure that has the arguments as member variables. The
type `T` is not deduced.

The check is imperfect, in that if we forget to pass a member variable which
fits in the padding, then the check will wrongly not assert, but it is right
often enough.

`struct_layout` specializations are used to define a structure with certain
member variables, with the only purpose to calculate the size. The types `T0`,
`T1` etc., parameters for `struct_layout`are actually `const`, but we assume
that people do not specialize different layouts for `const` and non-`const`
(`std::map::extract` relies on similar assumptions).

NOTE: This simple implementation fails for `struct`s containing `float`s or
`double`s with values `NaN`.


# Reference

- [Concepts basics][concepts-basics]
- [Alex Stepanov pearls][pearls]
- [Tie trick][tie-trick]
- [C++ reflection intro][reflection]


[concepts-basics]: {% post_url 2017-07-18-concepts-basics %}
[pearls]:          {% post_url 2018-05-06-alex-stepanov-pearls %}
[tie-trick]:       {% post_url 2017-03-10-std-tie %}
[reflection]:      {% post_url 2018-01-29-reflection %}


