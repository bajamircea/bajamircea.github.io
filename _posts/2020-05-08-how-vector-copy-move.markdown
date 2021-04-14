---
layout: post
title: 'How vector works - copy vs. move'
categories: coding cpp
---

When a vector resizes and needs to transfer existing values to the larger
array: does it copy or does it move them? It's more complicated than it should
be.

In the previous articles I used ambiguous expressions such as "move/copy" when
referring to the transfer of existing values when resizing a vector. This
article explains why.

- dynamical sentinel
  - why
  - deque as well

- allocators

- in practice

# Pre C++11

Pre C++11 the vector would copy on resize. That's not a problem for built-in
types like `int`s that can just be bitwise copied.

But vectors of containers, such as `std::vector<std::string>` would usually
have to copy the values on resize. The library could have done something
special about types it knew, such as `std::string`, but it will have to copy
when faced with new types, even as simple as:

{% highlight c++ linenos %}
struct some_struct {
  std::string m0;
};
// pre C++11 would copy for resize of
// std::vector<some_struct>
{% endhighlight %}

Also there are types that hold a resource, which are not copyable. Pre C++11
such types would have private copy operations to prevent accidental copying,
but then they could not be stored easily in containers such as `std::vector`.

{% highlight c++ linenos %}
template<typename T>
struct pre_cpp11_ptr {
  T * ptr;
  pre_cpp11_ptr(T* raw) : ptr(raw) {}
  ~pre_cpp11_ptr { delete ptr; }

  //make copy private, but can't use std::vector<pre_cpp11_ptr<int> >
private:
  pre_cpp11_ptr(const pre_cpp11_ptr &);
  pre_cpp11_ptr & operator=(const pre_cpp11_ptr &);
};
{% endhighlight %}


# C++ 11

C++ 11 introduces the move semantics.

That means that `std::vector<std::string>` moves the `std::string` values
instead of copying when it resizes, even if they are inside structures as
`some_struct` above.

Also C++ 11 comes with `std::unique_ptr`, which can be put in a vector, i.e.
`std::vector<std::unique_ptr<int>>`. The `std::unique_ptr` values are moved when the
vector resizes. Note that you can't take a copy of a
`std::vector<std::unique_ptr<int>>` as the `std::unique_ptr` can't be copied.

So it's all good, right?


# Standardese

It turns out it's very difficult to determine based on the standard if a values
of a vector are moved or copied. For example you might get that the choice
depends on the result of `!std::is_nothrow_move_constructible_v<T> &&
std::is_copy_constructible_v<T>`.

But then it gets complicated. For example for `std::is_move_constructible` on
which the `nothrow` version is based has edge cases where it returns true even
if there is no move constructor, because types without a move constructor, but
with a copy constructor that accepts `const T &` arguments, satisfy
`std::is_move_constructible`.

Also `std::is_copy_constructible` returns true for types that cannot be copied
e.g. `std::vector<std::unique_ptr<int>>`. In this case the `std::vector` has a
copy constructor, which actually can't be instantiated successfully.


# Recommended idiom

But all this standardese is irrelevant if types that you might put into a
container have a non throwing move constructor. That is a good idiom to follow:

- For low level classes, e.g. for RAII classes, for your own container classes,
  ensure you have a non-trowing move which just transfer ownership involving
  copying of handles/pointers and invalidating the ones at the source of the
  move. These operations don't involve anything that might throw. Mark the move
  constructor and assignment as `noexcept`.
- For the rest of classes let the compiler generate moves. They will be
  `noexcept` assuming only types as above are used.


However there are also cases where move could throw.

One example is if you use certain kinds of allocators and you "move" from a
container that uses a allocator in some area of memory to a container with
allocation in some other area of memory. That "move" really involves copy,
which means it might throw if allocations fail. If you don't use custom
allocators this does not apply to your application.

# Containers with dynamically allocated sentinel

However there is another case that involves standard containers such as `std::list`,
`std::deque`, `std::map` etc. even if custom allocators are not involved.

For example Microsoft's `std::list` can throw in move constructors.

![Array](/assets/2018-06-28-linked-lists-examples/06-double-dummy-node.png)

This is due to a combination of design decissions that end up having
consequences.

- It uses a dynamically allocated sentinel: the dummy node with two pointers
  `next` and `prev`, but value. This has the advantage that it provides an end
  iterator that does not get invalidated in a variety of scenarios. E.g. the
  end iterator for `std::vector` gets invalidated on resizes, inserts etc.
- It does not have "moved from" state that is different from an empty
  container. This is a dubious decision, but I believe it's mandated by the
  standard and would be difficult to change. A much better idiom would have
  been to say "moved from objects can be destroyed or assigned to, but not
  usable otherwise".
- The way the move semantics is implemented in C++: the move constructor does
  not know if/how the "moved from" object will be used. 

Therefore a vector of container with dynamically allocated sentinel, e.g.
Microsoft's`std::vector<std::list<int>>`, copies the values on a `push_back`
resize, in order to maintain the strong guarantees, in face of the
Microsoft's`std::list` not having a `noexcept` move constructor.

It turns out that many other of Microsoft's standard containers have the same
issue `std::map`, `std::unordered_map`, `std::deque` etc.

g++ seems to kind of avoid this issue except for `std::deque`. To complicate
further, `std::vector<std::deque<int>>` is fine, because of a special
treatment.

However for both:

{% highlight c++ linenos %}
struct some_struct {
  std::list<int> m0;
  std::deque<int> m1;
};
// would copy for resize of
// std::vector<some_struct>
// just as it did pre-C++11
{% endhighlight %}


# References

NOTE: I used Microsoft vs g++ compilers as a oversimplification. More
precisely, the behaviour depends on the standard library implementation, not on
the compiler. For a survey of container `noexcept` behaviour see:

Howard E. Hinnant: [Container Survey][containers] - 2015-06-27

Ville Voutilainen et al. [N4055: Ruminations on (node-based) containers and
noexcept][N4055] - 2014-07-02

Testing the vector behaviour [source code][main-cpp].

[containers]: http://howardhinnant.github.io/container_summary.html
[N4055]: https://isocpp.org/files/papers/N4055.html
[main-cpp]: https://github.com/bajamircea/cpp-play/blob/master/src/how_vector_works
