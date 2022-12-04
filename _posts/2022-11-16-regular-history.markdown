---
layout: post
title: 'History of normal type in C++'
categories: coding cpp
---

The ideas of regular data in C++ have a long and instructive history.

# Articles in this series

- [struct from C][c-struct]
- [C copy][c-copy]
- [C++ constructor, destructor and class][cpp-constructor]
- [Default constructor][default-constructor]
- [C++ copy][cpp-copy]
- [Exception safety, noexcept][exception-safety]
- [C++ equality and order (first attempt)][compare-classic]
- STL and templates
- C++ move
- rule of three and composing
- regularity syntax and semantics
- concepts in C++
- the many relationships
- three-way comparison, aka the spaceship operator
- better equality
- better member
- constexpr
- sanity and divergence from insanity
- the better future

Also see the above in [presentation form][presentation]


# Introduction

Consider this type, `person` that I [introduced recently][regularidiom] in the
series of [articles on programming idioms][idioms-intro].

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

I called this a regular data type. Regular is another name for normal, usual.
`person` is type that holds some data related to a person. Behind it's relative
simplicity it's a very flexible type: it can be copied, moved, compared for
equality and order, it will not leak memory.

**Regularity is really the benchmark on which other types will be judged** i.e.
"this other type really can't be regular because ..."

In this series of articles I'm going to cover what I know about the history of
the design supporting regular data types. The history is long and contains
interesting deliberate and accidental events.


# References

Again, a lot of the ideas in this series of articles come from [Elements of
Programming][eop] by Alexander Stepanov and Paul McJones, from comments done by
Alexander Stepanov in recordings published on Youtube and from reading
carefully some C++ committee papers.

The "Design and Evolution of C++" by Bjarne Stroustrup is an important source
for how ideas that lead to C++ from C came to be. It does stop at about 1994,
so it does not cover later developments.


[eop]:                 http://elementsofprogramming.com/
[presentation]:        /presentations/2022-11-16-regular-history.html
[idioms-intro]:        {% post_url 2022-10-17-idioms %}
[regularidiom]:        {% post_url 2022-10-20-regular-idiom %}
[c-struct]:            {% post_url 2022-11-19-struct-from-c %}
[c-copy]:              {% post_url 2022-11-22-c-copy %}
[cpp-constructor]:     {% post_url 2022-11-25-cpp-constructor %}
[default-constructor]: {% post_url 2022-11-27-default-constructor %}
[cpp-copy]:            {% post_url 2022-11-30-cpp-copy %}
[exception-safety]:    {% post_url 2022-12-02-exception-safety %}
[compare-classic]:     {% post_url 2022-12-05-compare-classic %}
