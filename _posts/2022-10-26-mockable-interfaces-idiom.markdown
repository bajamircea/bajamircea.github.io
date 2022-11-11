---
layout: post
title: 'Idiom: Mockable interfaces'
categories: coding cpp
---

Mockable interfaces for easy testing.


This article is part of a series of [articles on programming
idioms][idioms-intro].

Mockable interfaces are essentially the idiom I described as [dependency
injection using interfaces][dep-inj].


# Instantiation

You break some business logic functionality between a number of objects that
depend on each other. One of such classes might be accessing a database
(`buzz`), another might be used to read data from a file (`bar`), and yet
another (`foo`) might use both of them to import data from the file into the
database.

Somewhere in your code you declare these objects and chain them together,
effectively topologically sorting the dependency graph, relying on the [C++
class lifetime for orderly construction and destruction][cpp-lifetime]:

{% highlight c++ linenos %}
int main() {
  buzz z;
  bar y;
  foo x{ y, z, "flintstone" };
  waldo w{ x, y };

  w.do_something();
}
{% endhighlight %}


# Virtual function interfaces

In order to be able to test these objects in isolation of each other, you use
interfaces of pure virtual functions, then derive from those interface: once
with a real implementation and once with a mock one for testing.

Using inheritance raises the question: if someone destroys the object through
the interface base class, what ensures that the derived destructor is called?
There are two approaches.

Ensure that the derived class destructor is called when the base class
destructor is called. This is achieved by adding a virtual destructor (not
pure) to the base class.
{% highlight c++ linenos %}
struct foo_interface {
  virtual void some_fn() = 0;
  virtual int some_fn2() = 0;

  virtual ~foo_interface() = default;
};
{% endhighlight %}

The second alternative is to ensure that you can't destroy though the base
class instance in the first place. This is achieved by hiding (`protected`) the
base class destructor.
{% highlight c++ linenos %}
struct foo_interface {
  virtual void some_fn() = 0;
  virtual int some_fn2() = 0;

protected:
  ~foo_interface() = default;
};
{% endhighlight %}

If you go for this second option then you might want to make the derived class
`final` so that itself can't be a base class (or do a protected destructor
again for similar reasons).
{% highlight c++ linenos %}
class foo final: public foo_interface {
  void some_fn() override;
  int some_fn2() override;
{% endhighlight %}


# Real implementation

You will have an implementation for such an interface:

{% highlight c++ linenos %}
class foo : public foo_interface {
  bar_interface & bar_;
  buzz_interface & buzz_;
  const std::string fred_;

public:
  foo(bar_interface & bar,
      buzz_interface & buzz,
      const std::string & fred):
    bar_{ bar }, buzz_{ buzz }, fred_{ fred }
  {}

  foo(const foo &) = delete;
  foo & operator=(const foo &) = delete;

  // implement in terms of bar_, buzz_ and fred_
  void some_fn() override;
  int some_fn2() override;
};
{% endhighlight %}

A topmost class, e.g. `waldo`, does not need to be inherited from an interface.


# Capturing dependencies

In this case `foo` depends on a couple of other interface based classes. We
store references to these interfaces. It's best to capture references to these
dependencies at construction time into the member variables. Another
alternative is to set them later via an `init` method (or equivalent), but that
would have lifetime issues (e.g. they are not correct/or available between
construction and `init`.

Notice that we stored the interfaces in an almost mechanical/recipe fashion, we
did not use them to create another object. That adds complexity, e.g.  we'll
see later that a unit test would also cover that object, so it should be done
where really there is some gain to be had.

The string `fred` is another customization that is captured at construction
time. It might be something like a database connection string. We could create
an interface for that for more complex cases or simply store a copy of the
connection string in a member variable like above.


# Dangling references risk

Holding references creates questions about ensuring they are not dangling. If
we don't plan to copy or move any of these objects that would address the
issue. Deleting the copy constructor and assignment means this class won't be
copied or moved. We do this for all the classes involved (`foo`, `bar`, `buzz`
and `waldo`).

As we'll see later using smart pointers instead of references is not a good
idea because it introduces more problems that it fixes.

**Note**: we considered deleting the copy constructor and assignment in the
interface. Putting it there would have rhymed with the "Rule of 3": if you have
a destructor also deal with copy constructor and assignment. That is a sound
starting point for types that explicitly release a resource in the destructor.
However in the interface the reason we have a destructor has to do with a
different reason (calling the right destructor). We thought that deleting the
copy constructor and assignment in the class (rather than in the interface
which only deals with the destructor) makes it easier to do local
reasoning. E.g. To get info on what's done to avoid the issue of dangling
references (which classes use), look at the class using the references and the
class that implements the interface stored as reference, without also having to
check their interface definition. Also some like `waldo` might not be derived
from an interface anyway, but still would benefit from knowing it won't be e.g.
returned by accident from a function and have dangling references to objects
from within the function scope.


# Testing foo

It's easy to [create mocks for behaviour verification][mocks] using a test
framework like google test and test the classes that take their dependencies as
interfaces.

{% highlight c++ linenos %}
class bar_mock :
  public bar_interface
{
public:
  MOCK_METHOD(void, bar_fn, (), (override));
};

// ... `buzz_mock

TEST(foo_test, trivial)
{
  StrictMock<bar_mock> y;
  EXPECT_CALL(y, bar_fn())
    .Times(1);
  StrictMock<buzz_mock> z;

  foo x{ y, z, "bedrock" };
  x.some_fn();
}
{% endhighlight %}

You would usually use something like the Google test `StrictMock` to ensure
that unexpected calls fail the test, that's the point of [behaviour
verification][mocks].

We used the mocks to isolate a smaller number of componets that are involved in
the test, but note that the "unit test" still involves other components
(`std::string` at least in this case):

<div align="center" style="max-width: 500px">
{% include assets/2022-10-26-mockable-interfaces-idiom/01-graph.svg %}
</div>


# Testing bar and buzz

`bar` and `buzz` do not have interfaces injected at construction time. They
often either:
- just do data manipulation: in which case they can be tested as in the regular
  data and functions idiom
- just call C APIs: in which case they can be tested like the C API wrappers

# Builder class

Occasionally you can't use the stack directly for instantiation, so then you
use a builder class that relies on the same C++ class lifetime rules for
orderly construction and destruction:

{% highlight c++ linenos %}
class waldo_builder {
  buzz z_;
  bar y_;
  foo x_;
  waldo w_;
public:
  waldo_builder() :
    z_{},
    y_{},
    x_{ y_, z_, "flintstone" },
    w_{ x_, y_ }
  {}

  void do_something() {
    w_.do_something();
  }
};
{% endhighlight %}

Then you would instantiate that `waldo_builder` once, e.g. using a
`std::unique_ptr`. This class would not be unit tested, though it's simple
functionality might be covered by component or system tests.


# Why this idiom works?

Mock interfaces are well supported by unit test frameworks like Google test,
both their creation using `MOCK_METHOD` macro and test primitives like
`EXPECT_CALL`.

The compiler might remove the usage of the virtual table, something called
devirtualization. In the instantiation example at the top it is often clear to
the compiler that `foo` calls a method of `bar`, so it does not need to store a
reference to the interface and do the virtual table indirection, removing the
storage and call overheads.

**These classes are often "doer classes", i.e. classes that are there for doing
things rather than "data classes", e.g. reading data from a file, accessing a
database, while at the same time they have named methods for doing things,
being less refined than function objects that do things via the function
operator `operator()` which they implement.**

Java Spring users might notice analogies with `@Service` and `@Component`
annotations. The diference is that here the dependency injection was done by
hand.


# What are it's limits?

**Of the three idioms presented here this one is the least intellectually sound
one**.

In it's defence we can say that it is useful in the context of lack of
compiler/build tools support for intrusive testing where you want to substitute
entities for testing purposes with minimal code bloat complexity. For example
even if there is some code bloat in the declaration and use of the interface,
including declaring the same function 3 times (interface, implementation and
mock), the compiler will catch many divergence errors (e.g. implementation does
not implement interface method) at compile time.

It is a direct blast from the Object Oriented Programming of the early 90s.
Many an enthusiastic programmer has created an overly complex and inefficient
program after reading the GoF patterns book. For issues around inheritance, see
talks like Sean Parent's talk ["Inheritance is the Base Class of
Evil"][evil-inheritance]. To keep the idiom usable you need to take active
steps to avoid it's pitfalls.

Avoid the factory pattern where an interface returns another interface. Usually
that requires additional unnecesary memory allocations. Return data from
interface methods if possible.

Create abstractions at the right level. Avoid both over fragmented tiny classes
with absolutely no real functionality. See the usage of a `std::string fred`
above in order to avoid an interface with one method returning a hardcoded
string. Also avoid classes that depend on a large number of interfaces in the
constructor with complex code to orchestrate them. E.g. you can have a `router`
class that routes data to a large number of interfaces if the code is simple
(e.g. a large `switch` that does the dispatch). Otherwise as a rule of thumb
about 7 dependent interfaces is usually too much, with a sweet spot of between
3 and 5 dependent interfaces.

Avoid deep or wide inheritance hierarchies. This introduces a lot of coupling
making it hard for the code to evolve gradually. It's also hard when debugging
you see that some interface method is called, it's not easy to see which class
it belongs especially where there might be more than one candidate.

Not all the classes are testable with pure unit tests. The ones in the middle
of the dependency graph are, like `foo` and `waldo`. Others, like
`waldo_builder`, are simple and would be covered by component/system tests,
it's hard and little value from trying to unit tests. Yet others like `buzz`
and `bar` might use C wrapper APIs and should follow a similar strategy like
those, where testing is not pure unit tests, but rather against real artefacts.

And lastly there are misunderstanding around the alternatives like usages of
smart pointers and `const` for holding to the interfaces. In the next article
we'll have a look at `const`.

[idioms-intro]:    {% post_url 2022-10-17-idioms %}
[cpp-lifetime]: {% post_url 2015-04-02-class-lifetime %}
[dep-inj]:      {% post_url 2015-10-31-dependency-injection-interface %}
[mocks]:        {% post_url 2022-05-31-mock-fake-spy %}
[evil-inheritance]: https://www.youtube.com/watch?v=bIhUE5uUFOA
