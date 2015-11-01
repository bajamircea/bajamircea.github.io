---
layout: post
title: 'Dependency injection using templates'
categories: coding cpp
---

WORK IN PROGRESS

Using C++ templates to implement dependency injection.


# Introduction

Let's try to implement the [fictional house example
article][dependency-reduction] with a C++ template-based approach.


# Code

Once I got the ideea of using dependency injection using interfaces and reaped
the benefit of more test coverage/less errors, I wondered why people don't beat
the drum more about it. What would Alexander Stepanov do? Well, if you want to
test a vector, you create an instrumented class and you create a vector of that
class. Bingo! A class that uses templates for injection receives the types of
the dependencies as template arguments.

Note that you might choose to not inject all member variables types (e.g. an
`int` or a `std::vector`), or you might choose to still inject some member
variables by reference.

Also now most of the code resides in headers.

This is how the `house` class can change.

### house.h
{% highlight c++ linenos %}
template<
  class cuppa,
  class door,
  class tv>
class house
{
public:
  void house::chillax() {
    cuppa_.finish();

    door_.open();
    door_.close();

    tv_.switch_on();
  }

private:
  cuppa cuppa_;
  door door_;
  tv tv_;
};
{% endhighlight %}


The dependent class do not need to change.

We can now test the `home` class, using `gtest` and `gmock` for example.

TODO: adapt test

### home_test.h
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

  house<cuppa_mock, door_mock, tv_mock> h;
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
  house<cuppa, door, tv> h;
  h.chillax();
}
{% endhighlight %}


# Discussion

TODO:

# Conclusion

TODO:


[dependency-reduction]:    {% post_url 2015-10-30-dependency-reduction %}
