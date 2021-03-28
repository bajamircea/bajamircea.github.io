---
layout: post
title: 'How vector works - exception safety'
categories: coding cpp
---

C++ exception safety recap, especially for vector

Exception safety refers to what are the reasonable expectation regarding how a
function deals with exceptions.


# The basic guarantee

The basic guarantee is that no resources are leaked if a function throws an
exception and there there is some recovery action that the program can take to
continue. Basically this boils down to objects involved ending up at least in
such a state that the destructor will clean up resources.

For example the `std::vector::insert` might need to resize the underlying array
and copy/move existing values, but should an exception be thrown by a copy/move
then the state of the vector is not fully determined from the caller's point of
view. The caller can destroy the vector, and that in turn will destroy the
appropriate values and the underlying array and there will be no memory leaks.


# No-throw guarantee

The no-throw guarantee is that a function guarantees that it does not throw.

This raises the question: why would an exception be thrown in the first place?
The answer is: to handle errors that are expected to be rare.

Certainly when doing low level operations assigning builtin types like `int`,
`char`, pointers, arrays of those, that can be done without exceptions. Also
it's refreshing to see that for simple microcontroller systems, accessing
devices like configuring the serial port involves writing some values at a
certain memory location, there is no failure feedback. But as systems get more
complex eventually there are errors.

This `std::filesystem` function throws if it fails to delete a file (e.g.
access denied):

{% highlight c++ linenos %}
bool remove(const std::filesystem::path& p);
{% endhighlight %}

It can be `noexcept`, if it returns an error code (as an argument passed by
reference in this case:

{% highlight c++ linenos %}
bool remove(const std::filesystem::path& p, std::error_code& ec) noexcept;
{% endhighlight %}

This requires that `std::filesystem::path` already has a zero terminated string
that it can pass to the underlying C API to delete the file.

But again, at higher levels eventually rare errors could happen. In particular
memory allocations happen so all over the place. What happens if they fail to
allocate? This `std::filesystem` function that recursively removes the content
of a folder is not marked `noexcept`.

{% highlight c++ linenos %}
std::uintmax_t remove_all(const std::filesystem::path& p, std::error_code& ec);
{% endhighlight %}

For most of the errors it will set the error code, but for memory allocation
failure it will throw `std::bad_alloc`. And it needs to allocate memory to
build paths to children of the parent folder, as the underlying C API only
deletes empty folders.

Memory allocations is the reasons why for most containers the copy constructors
and assignment could throw.

For the large majority of cases, destructors don't throw. Usually functions
that guarantee to not throw are marked `noexcept`, but destructors are assumed
to be `noexcept` by default. Destructors that throw are a bad idea, maybe with
the exception of at-scope-exit classes, which is a separate topic.

In particular the `std::thread` design terminates in face of errors (such as
the underlying thread still running), so strictly speaking it will not throw
exceptions (but might terminate for incorrect usage).

For some applications it might be acceptable to terminate on memory
allocation errors, though that usually comes with the expectation that a level
of resilience/recovery exists elsewhere, outside the current process.

The vector destructor does not throw, and it expects that the same is true for
value type.

Unlike the destructors, for the move constructor and assignment, the compiler
will not assume they are `noexcept` implicitly, but a good practice is to
ensure they are and mark the them `noexcept` explicitly.

The vector move constructor and assignment do not throw, they just take shuffle
pointer values around.

However some implementations of standard containers e.g. Microsoft's
`std::list` can throw on move constructors, for reasons that have to do with a
combination of:
- they use a dynamically allocated sentinel: this helps ensure that iterators
  don't get invalidated in a variety of scenarios
- do not have a "moved from" state that is different from an empty container:
  this is a dubious decision, but mandated by the standard
- the way the move semantics is implemented in C++: the move constructor does
  not know if/how the "moved from" object will be used

This combination comes with consequences (see `push_back` below)


# The strong guarantee

The strong guarantee is that if an exception is thrown, the program state is
unchanged: "commit or rollback" semantics.

It can be achieved by taking a copy of the data involved, changing it, then
swapping on success.

Some operations can provide strong guarantees without the additional cost.

This is the intent behind the vector `push_back`:
- if no reallocation happen, there are no changes in the container if the value
  type throws when constructed at the end: the strong guarantee
- if reallocation happen, the strong guarantee is also given if the value type
  is no-throw moveable or copyable (even if copy can throw), otherwise it
  provides just the basic guarantee (the vector can be destroyed).

Currently a vector of container with dynamically allocated sentinel, e.g.
Microsoft's`std::vector<std::list<int>>`, copies the values on a `push_back` resize,
in order to maintain the strong guarantees, in face of the
Microsoft's`std::list` not having a `noexcept` move constructor.

**TODO: work in progress**

# Variations

Guarantees can vary. A component might give stronger guarantees if additional
requirements are met. For example `push_back` is not marked `noexcept`, but if
there is spare capacity, and the new value can be moved/copied without
throwing, then `push_back` will not throw.

- Exception neutrality: in generic code, the expectation that when a generic
  function is used, exceptions thrown by types provided (e.g. as template
  parameters) are propagated unchanged to the caller
- also FIT RAII: does not throw/care about exceptions

# Historical notes

If you dig into the history of the issue, you might encounter an article by 

[originally defined by the likes of David Abrahams][exsafe]
in the context of generic components, because the user of a generic component
can customize it with their own types raising the question of what's the
contract when exceptions are thrown.

stack
Exception Handling: A False Sense of Security by Tom Cargill
https://ptgmedia.pearsoncmg.com/images/020163371x/supplements/Exception_Handling_Article.html

how sorted for stack

some of the complexity comes from error handling complexity

# References

David Abrahams: [Exception-Safety in Generic Components][exsafe]

Ville Voutilainen et al. [N4055: Ruminations on (node-based) containers and
noexcept][N4055] - 2014-07-02


NOTE: I used Microsoft vs g++ compilers as a oversimplification. More
precisely, the behaviour depends on the standard library implementation, not on
the compiler. For a survey of container `noexcept` behaviour see:

Howard E. Hinnant: [Container Survey][containers] - 2015-06-27


Exception Handling: A False Sense of Security by Tom Cargill
https://ptgmedia.pearsoncmg.com/images/020163371x/supplements/Exception_Handling_Article.html


https://www.stroustrup.com/except.pdf

[containers]: http://howardhinnant.github.io/container_summary.html
[N4055]: https://isocpp.org/files/papers/N4055.html
[exsafe]: https://www.boost.org/community/exception_safety.html
