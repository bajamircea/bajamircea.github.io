---
layout: post
title: 'Regular wannabes'
categories: coding cpp
---

There are all sorts of types that sometimes try to have regular
characteristics.

This article is part of a series on [the history of regular data type in
C++][regular-intro].

There are all sorts of types. The quote "_Good types are all alike; every
poorly designed type is poorly defined in its own way_. - Adapted with
apologies to Leo Tolstoy" from [Titus Winters' blog on regular types][abseil]
is particularly relevant.

Regular data types are important because:
- they are close to what the current computer architecture does: they define
  how data memory should be interpreted
- allow algorithmic, mathematical reasoning about the code

This results in scope for efficient computation and ease of reasoning about
code, so some types try to have regular characteristics.

There are proper strong regular types. They have have default constructor,
destructor, copy, move, all proper comparison operators and all of the many
semantic expectations.

Examples are:
- `int`: the dream regular type.
- `std::string`: copy could throw, but that's usually OK, all dynamically
  allocated containers have this issue.
- `std::vector`: it is regular if the `value_type` is regular (it does
  lexicographical compare, which is what one would expect), but not if the
  `value_type` is not regular. It still makes sense to be able to store
  contiguously items, even if not regular.
- `std::pair`: similar issues with the vector, it all depends on member types.
  It does memberwise compare, which is what one would expect.
- `std::shared_ptr`: does shallow copy and comparison, but that OK, it uses
  atomics to address expectations around threading.

And then there are types that miss the regular train in some (often unique to
them) way:
- Types like `std::map` in the Microsoft implementation that might throw for
  default constructor or move constructor, but are otherwise OK. They might
  also not have caught fully with `constexpr` support.
- Types like `std::unordered_map` where the equality time complexity might be
  `N^2`, but are otherwise OK. Maybe you say that those cases are outside the
  domain of equality comparison
- Types like `float` have multiple issues around `NaN` (domain issues) and
  `-0.0`/`+0.0` (`==` does not mean equality)
- Types like `string_view` which are not semantically regular e.g. you take a
  copy, you change the copy, but then it's still equal to the original (because
  they are views to the same data)
- Then the standard relaxed the requirements further where the `std::regular`
  concept does not require order. E.g. C++ iterators
- And then further relaxed for `std::semiregular` to not even have equality
- vtable interface based types that use `clone` methods to copy, with their own issues
  around comparisons
- Types that can't be copied like RAII C-handle wrappers, but can be moved
- Types that aren't even meant to be moved or copied like trait types: they are
  just some syntactic mechanism to communicate with the compiler.

Some deviations from regular are meant to be, but others are caused by poor
design.

In particular using `==` and `<` to mean less than equality and "less than"
(pun intended) is wrong. Define instead methods like `is_equivalent` or
`preceeds` and use those to customise algorithms.

# References

[Revisiting Regular Types][abseil]: by Titus Winters, 2018

[regular-intro]:    {% post_url 2022-11-16-regular-history %}
[abseil]: https://abseil.io/blog/20180531-regular-types

