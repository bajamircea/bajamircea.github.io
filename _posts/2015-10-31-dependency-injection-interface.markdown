---
layout: post
title: 'Dependency Injection Using Interfaces'
categories: coding cpp
---

A look at what is dependency injection, and how to implement constructor
injection in C++ for member variables of a class, using interfaces with virtual
functions.


# Introduction

I first saw dependency injection used systematically in AngularJS, a Javascript
framework. However the technique comes from Java and this example illustrates
how it would apply to C++.

Let's try to implement the example from [the previous
article][dependency-reduction] in such a way so that we can write tests for
`house` class.


# Code

This is how the `house` class can change. It receives its dependencies in the
constructor. The relevant member variables become references that get
initialized in the constructor with the values passed from the outside. Note
that you might choose to not inject all member variables (e.g. an int, or a
standard container member variable that is part of the logic of that class).

### house.h
{% highlight c++ linenos %}
#include "cuppa_interface.h"
#include "door_interface.h"
#include "tv_interface.h"

class house
{
public:
  house(
    cuppa_interface & cuppa,
    door_interface & door,
    tv_interface & tv);

public:
  void chillax();

private:
  cuppa_interface & cuppa_;
  door_interface & door_;
  tv_interface & tv_;
};
{% endhighlight %}

### house.cpp
{% highlight c++ linenos %}
#include "house.h"

house::house(
    cuppa_interface & cuppa,
    door_interface & door,
    tv_interface & tv) :
      cuppa_{ cuppa },
      door_{ door },
      tv_{ tv }
{
}

void house::chillax() {
  cuppa_.finish();

  door_.open();
  door_.close();

  tv_.switch_on();
}
{% endhighlight %}

Here's how for example the `cuppa` class can change. First we need to define an
interface of pure virtual functions.

### cuppa_interface.h
{% highlight c++ linenos %}
struct cuppa_interface
{
  virtual void finish() = 0;

protected:
  ~cuppa_interface() {};
};
{% endhighlight %}

The virtual destructor in the interface helps with the issue of someone taking
a pointer to the interface and deleting it. A protected destructor stops that
from happening. The other option would be to have a public virtual destructor.

Then the `cuppa` class implements this interface.

### cuppa.h
{% highlight c++ linenos %}
#include "cuppa_interface.h"

#include "cup.h"
#include "tea.h"

class cuppa :
  public cuppa_interface
{
public:
  void finish() override;

private:
  tea tea_;
  cup cup_;
};
{% endhighlight %}

### cuppa.cpp
{% highlight c++ linenos %}
#include "cuppa.h"

void cuppa::finish() {
  tea_.drink();
  cup_.rinse();
}
{% endhighlight %}

We can now test the `house` class, using `gtest` and `gmock` for example.

### house_test.h
{% highlight c++ linenos %}
#include <gtest.h>
#include <gmock.h>

#include "house.h"

class cuppa_mock :
  public cuppa_interface
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

  house h{ c, d, t };
  h.chillax();
}
{% endhighlight %}

We are left now with the issue that somewhere we need to instantiate all the
objects.

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

  house h{ c, d, t };
  h.chillax();
}
{% endhighlight %}


# Discussion

Was it worth it? In the fictional example above, probably not. We went from 24
lines of code in 2 files for the `house` class to I recon in this example
about 70 lines required to implement and support it.

The advantages are:

  - It makes it trivial to unit test in isolation classes that are in the
    middle of the application logic. For this alone I'm willing to forego its
    problems (until a better option becomes feasible).
  - Constructor injection makes it obviously (compiler checks it) which
    dependencies need to be created to instantiate a class. That is better than
    using a setter method to inject dependencies.

The disadvantages are:

  - A small runtime cost from the usage of the virtual functions. For a certain
    class of applications this can be ignored.
  - More code and additional files. This is mitigated by the fact that the code
    is simple, and can be described in rules.
  - Risc of low value tests. For a simple class like the above one can infer from
    reading the code in the `chillax` function as to what's going to happen.
    The mitigation is: then don't write unit tests for such simple
    functionality.
  - When there are multiple types implementing the same interface, debugging is
    harder. This is mitigated by the fact that the ability to unit test more
    classes, leads to less issues to debug in the first place.
  - This style also introduces the need for places where components are put
    together like the `main` function above, or a factory-like class.
  - It's not easy to create objects of a type. You need to inject a factory
    class which adds to the code complexity.

# Conclusion

Using some form of dependency injection makes it trivial to write unit tests
for any class of your choosing. It is a style that most developers from a
traditional OO background will find it easy to understand.

However I expect that in the future the concepts and modules for templates will
make a template based approach a better method to do dependency injection.


[dependency-reduction]:    {% post_url 2015-10-30-dependency-reduction %}
