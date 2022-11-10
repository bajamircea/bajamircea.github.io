---
layout: post
title: 'Programming idiom remarks'
categories: coding cpp
---

Closing remarks on programming idioms. Further issues with threading, smart
pointers in the mocking interfaces idiom

This article is part of a series of [articles on programming
idioms][idioms-intro].


# Recap of idioms

We've seen three popular idioms. These are not the only idioms, there are
special idioms around writing C++ standard library code, around multi-threading
libraries, for `boost::asio` concurrency handling, for coroutines, for compile
time computation, for numerical processing etc.

Of the three the regular data and functions is the most sound one. Surely, I
wish there was no need for so much gobbledigook required to default equality and
order and less madness around float types and containers like `std::list`,
`std::map`, `std::set` etc. for their `constexpr` behaviour and also the
madness around their default constructor and move constructor `noexcept`
behaviour in Microsoft libraries. It will take a long time to address these now
legacy issues in the compiler and libraries.

The API wrapping one might have some controversial issues around error
handling, but the adoption of `std::filesystem` in code bases (and of
`boost::filesystem` before that) shows that it's ballpark right.

The mockable interfaces is the least sound one. If used carefully, it can
provide benefits in terms of ability to unit tests things that are not leafs in
the graph of code dependencies.


# Minor deviation from regular

Consider this:

{% highlight c++ %}
struct person
{
  std::string first_name{};
  std::string last_name{};
  int age{};
};
{% endhighlight %}

We initialized with curly brackets the `std::string` members, not just the
`int`. This is a deviation that is just a matter of style, it does not really
matter.

Also we did not even have to use this class in a test, so we did not even
implement equality. For a class local to a cpp file, it does not matter much.

Despite this minor deviations, we still look at this `person` as (at least
potentially) a fully, proper regular data class.


# Smart pointers for interface members

What if we follow on the C.12 recommendation to use smart pointers? Well, `foo`
might start looking like this:

**example, bad**
{% highlight c++ %}
class foo : public foo_interface {
  std::unique_ptr<bar_interface> bar_;
  std::unique_ptr<buzz_interface> buzz_;
  const std::string fred_;

public:
  foo(std::unique_ptr<bar_interface> bar,
      std::unique_Ptr<buzz_interface> buzz,
      const std::string & fred):
    bar_{ std::move(bar) }, buzz_{ std::move(buzz) }, fred_{ fred }
  {}

  // implement in terms of bar_->, buzz_-> and fred_
  void some_fn() override;
  int some_fn2() override;
};
{% endhighlight %}

There are many problems with this approach. For example we now have to allocate
on the heap. Also if one object like `waldo` also wants to use the same
instance of `bar` as `foo`, then all of them might have to change from using
`unique_ptr` to using `shared_ptr`.

**example, bad**
{% highlight c++ %}
int main() {
  auto z = std::make_unique<buzz>();
  auto y = std::make_unique<bar>();
  foo x{ std::move(y), std::move(z), "flintstone" };
  /*
  but if we add waldo below
  waldo w{ x, y };
  then we also have to change:
  - y to instantiate via std::make_shared
  - x instantiated via std::make_unique
  - pass y into x without moving
  - store buzz_ inside foo as a std::shared_ptr
  - change constructor of foo to take buzz_interface as std::shared_ptr
  */
}
{% endhighlight %}

Using `unique_ptr` subtly changes the life-cycle of the classes, a class like
`buzz` is created outside `foo`, but destroyed inside `foo`.

Using `shared_ptr` has more overhead than `unique_ptr` both in memory
requirements and in additional runtime work to increment/decrement the
reference counts (in a thread safe manner). It also creates the risk of
circular references.

Using pointers raises the question: what if any the pointers is null?

To me it looks like using smart pointers for interface members in the mockable
interfaces idiom is similar with using `const` reference member interfaces:
it's done with good intentions, but it's not smart, it harms more then it
helps, it uses a more complex solution to not achieve more.

But there are two observations from this.

First is that computers are very accepting of bad idioms. **It's easy to get into
the habit of using a bad idiom because there is often no quick negative
feedback**.

Second is that **the mockable interfaces idiom in particular is bad at
isolating issues**. Notice how bad usage of `const` or smart pointers  has a
ripple effect e.g. how because `waldo` is using `bar` means that `foo` also has
to change.


# Threading concerns

With the regular data idiom things are relatively easy. You pass a copy to a
thread, that's about it. Or if you pass a `const` reference, you need to make
sure another thread can't change it (else you need synchronisation), ensure
that the life (scope) of the data outlives the thread using it, but again
that's about it.

With the C API wrap idiom, questions like: "can I open a file from a thread,
pass the handle to another thread and read file contents from there?" are
largely questions for the underlying C API.

With the mockable interfaces idiom, ideally you arrange to pass data between
threads as above. If you pass the interfaces (by reference) then you also have
to ensure the life of the interface (and the interfaces it uses) outlive the
thread using it. But then also if methods could be called from multiple
threads, then if this object does not synchronizes the calls itself, it
forwards the threading handling question to the interfaces it uses and so on,
another example where the mockable interfaces idiom is bad at isolating issues.


# Conclusion

It's important to have a vocabulary of good idioms. There are productivity
gains to be had from separating code in pieces that follow well understood
rules that do not require comments and deviations from the idiom. Deviations
from the idiom fall into several categories:
- Minor and not important
- There might be a good reason to deviate
- Bad, but persistent due to lack of instant negative feedback.


[idioms-intro]:    {% post_url 2022-10-17-idioms %}
