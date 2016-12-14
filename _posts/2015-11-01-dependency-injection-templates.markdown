---
layout: post
title: 'Dependency Injection Using Templates'
categories: coding cpp
---

Using C++ templates to implement dependency injection.


# Introduction

Let's try to implement the [fictional house example
article][dependency-reduction] with a C++ template-based approach.


# Code

Once I got the idea of using dependency injection using interfaces and reaped
the benefit of more test coverage/less errors, I wondered why people don't beat
the drum more about it. What would Alexander Stepanov do? Well, if you want to
test a vector, you create an instrumented class and you create a vector of that
class. Bingo! A class that uses templates for injection receives the types of
the dependencies as template arguments.

This is how the `house` class can change (now most of the code resides in
headers):

### house.h (injected types)
{% highlight c++ linenos %}
template<
  class Cuppa,
  class Door,
  class Tv>
class house
{
public:
  void chillax() {
    cuppa_.finish();

    door_.open();
    door_.close();

    tv_.switch_on();
  }

private:
  Cuppa cuppa_;
  Door door_;
  Tv tv_;
};
{% endhighlight %}


The dependent class do not need to change.

As above however, it's not very easy to write tests, because we don't have
access to the private member variables. One option is to leave the class as
above, and capture results from mocked dependencies in static data. The other
option is to inject the values as well by reference:

### house.h (injected types and references)
{% highlight c++ linenos %}
template<
  class Cuppa,
  class Door,
  class Tv>
class house
{
public:
  void house(
    Cuppa & c,
    Door & d,
    Tv & t) :
      cuppa_(c),
      door_(d),
      tv_(t) {
  }

  void chillax() {
    cuppa_.finish();

    door_.open();
    door_.close();

    tv_.switch_on();
  }

private:
  Cuppa & cuppa_;
  Door & door_;
  Tv & tv_;
};
{% endhighlight %}

Testing is now trivial:

### house_test.h
{% highlight c++ linenos %}
#include <gtest.h>
#include <gmock.h>

#include "house.h"

class cuppa_mock
{
public:
  MOCK_METHOD0(finish, void());
};

// ... `door_mock` and `tv_mock` ...

TEST(house_test, trivial)
{
  cuppa_mock c;
  EXPECT_CALL(c, finish())
    .Times(1);
  door_mock d;
  tv_mock t;

  house<cuppa_mock, door_mock, tv_mock> h{ c, d, t };
  h.chillax();
}
{% endhighlight %}

We are left now with the issue of the way the `house` class is instantiated
when used in production.

### main.cpp
{% highlight c++ linenos %}
#include "cuppa.h"
#include "door.h"
#include "tv.h"
#include "house.h"

int main() {
  cuppa c;
  door d;
  tv t;

  house<cuppa, door, tv> h{ c, d, t };
  h.chillax();
}
{% endhighlight %}

The need to have a place where the dependencies are instantiated is a mixed
blessing. On one side it introduces another layer.

Sometimes this layer is useful, e.g. what if we wanted to decompose the
`house` class differently?  What if we wanted it to have a `kitchen` and a
`living_room`, but the two rooms share the same `door`. Having a place where
dependencies are created allows us to create a `door` then each room (and pass
each the same `door`) and then the rooms to `house`.


# Conclusion

Dependency injection using templates is very similar to dependency injection
using interfaces.


[dependency-reduction]:    {% post_url 2015-10-30-dependency-reduction %}
