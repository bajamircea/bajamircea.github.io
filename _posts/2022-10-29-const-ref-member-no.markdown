---
layout: post
title: 'Const ref member: No'
categories: coding cpp
---

Should you use const for the members that store the interface references in the
mockable interfaces idiom?


This article is part of a series of [articles on programming
idioms][idioms-intro].


# Const attempt

With good intentions developer try to use `const` as much as possible.

Consider this `foo` class from the [mockable interfaces
article][interfacesidiom], but with as much `const` as possible (**example;
bad**):
{% highlight c++ linenos %}
class foo : public foo_interface {
  const bar_interface & bar_;
  const buzz_interface & buzz_;
  const std::string fred_;

public:
  foo(const bar_interface & bar,
      const buzz_interface & buzz,
      const std::string & fred):
    bar_{ bar }, buzz_{ buzz }, fred_{ fred }
  {}

  foo(const foo &) = delete;
  foo & operator=(const foo &) = delete;

  // implement in terms of bar_, buzz_ and fred_
  void some_fn() const override;
  int some_fn2() const override;
};
{% endhighlight %}

Once we made the member references `const`, in order to be able to call methods
on the interface, they have to be `const` (**example; bad**):
{% highlight c++ linenos %}
struct bar_interface {
  virtual void bar_fn() const = 0;

  virtual ~bar_interface() = default;
};
{% endhighlight %}


# What's wrong with it

At least three things.

First it allows now accidentally creating `foo` with temporary `bar` and `buzz`
that go out of scope as soon as the constructor completes.

{% highlight c++ linenos %}
int main() {
  foo x(make_bar(), make_buzz(), "flintstone");
  // ups, x has dangling references now
  // to temporaries that have been destructed
}
{% endhighlight %}

Second it's semantically wrong. For data, like in our regular data and
functions idiom, `const` means `const`. In the mockable interfaces idiom, the
classes are doers. E.g. one such class might access a database and read/write
to from the database, so a sequence `read()`, `write()`, `read()` might get a
different result for the second read despite all methods being `const`. Here
we're just abusing the syntax, technically it is correct that we don't change
member variables, but with no benefit in the ability to reason about the code,
that you would expect `const` to bring.

Third. In  test mock class, behind a macro like `MOCK_METHOD` the test
framework stores a state machine as a member variable so that `EXPECT_CALL`
methods configure that state machine and when a method is called, the mock
implementation goes through the state machine to check the expectations. If the
mocked method is `const`, the state machine will be declared `mutable` to
satisfy the complier that would complain about changing members from a `const`
method. Often an interface is implemented twice: one for the actual
implementation to be used in the delivered program and the other by a mock to
be used in unit tests and for 50% of the cases the `const` methods are not
really `const`.

Forth: multi-threading. In general `const` is useful to address some threading
concerns, but on it's own it's not sufficient. Just marking interface functions
`const` will not make your object thread safe.


# Conclusion

Interface methods don't play well with `const`. There is a contradiction
between using `const` on a method, which limits what the method can do, and
having the method declared in an interface as pure `virtual`, which means it
can choose to do what it pleases.


[idioms-intro]:    {% post_url 2022-10-17-idioms %}
[interfacesidiom]: {% post_url 2022-10-26-mockable-interfaces-idiom %}
