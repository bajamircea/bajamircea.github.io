---
layout: post
title: 'Reducing dependencies'
categories: coding cpp
---

Reducing dependecies is a fundamental refactoring technique. It addresses the
problem of too many dependencies by introducing additional abstractions, where
each abstraction in turn is smaller and simpler.


# Introduction

The `house` class from the [the previous article][dependency-problem] depends on
several other contributors to do its `chillax` job: the `tea` and `cup`, the
`knob`s and `hinge`, the `display` and `remote`.

The refactoring below will increase the number of classes. New classes are
introduced to capture abstractions like `cuppa`, `door` and `tv`. Each of theese classes
has fewer dependencies.


# Code

### house.h
{% highlight c++ linenos %}
#include "cuppa.h"
#include "door.h"
#include "tv.h"

class house
{
public:
  void chillax();

private:
  cuppa cuppa_;
  door door_;
  tv tv_;
};
{% endhighlight %}

### house.cpp
{% highlight c++ linenos %}
#include "house.h"

void house::chillax() {
  cuppa_.finish();

  door_.open();
  door_.close();

  tv_.switch_on();
}
{% endhighlight %}

### cuppa.h
{% highlight c++ linenos %}
#include "cup.h"
#include "tea.h"

class cuppa
{
public:
  void finish();

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

### door.h
{% highlight c++ linenos %}
#include "hinge.h"
#include "knob.h"

class door
{
public:
  void open();
  void close();

private:
  hinge hinge_;
  knob knob1_;
  knob knob2_;
};
{% endhighlight %}

### door.cpp
{% highlight c++ linenos %}
#include "door.h"

void door::open() {
  knob1_.turn();
  knob1_.push();
  hinge_.screech();
  knob1_.release();
}

void door::close() {
  knob2_.turn();
  knob2_.push();
  hinge_.screech();
  knob2_.release();
}
{% endhighlight %}

### tv.h
{% highlight c++ linenos %}
#include "display.h"
#include "remote.h"

class tv
{
public:
  void switch_on();

private:
  display display_;
  remote remote_;
};
{% endhighlight %}

### tv.cpp
{% highlight c++ linenos %}
#include "tv.h"

void tv::switch_on() {
  display_.plug_in();
  remote_.press_button();
}
{% endhighlight %}

The refactoring took us from 52 lines of code in 2 files to 89 lines of code in
8 files. The increase in number of files is expected, but the almost doubling
in the number of lines of the code is the result of having started with an
already simple class with not much code. Even then, it does say a better
story, mapping itself better to the original problem description: a person
finishes the cup of tea and goes to another room where it switches on the TV.

# Obstacles

Here are some obstacles on reducing the dependencies.

Knowledge. First of all is the knowledge that it can be done and how it can be
done. This article tries to help with that.

Inertia. People just don't want to change habits. The two responses you get are
on the lines of:

- "That's how we've written code since forever."
- "I like to see all my code together, to be able to see what it's doing.". In
  all fairness there some point to the last comment, it's all an act of
  balancing and taste.

The third obstacle is legacy code where concerns are mixed so it's not easy to
identify islands of functionality that could be separated.

The last obstacle is naming. In the initial example I used objects from the
physical world. It was easy to identify that the knob and hinge belong to the
door. We have words for this. For some problem domains, e.g. networking, again
we have words, we know what sockets, addresses, buffers etc. mean.

But in practice it's difficult to find good names for some new problem domain.
The risk is that thare are too many classes named
like`SomeClassThatHoldsThoseOtherTwoThingsTogether` that are not going to make
instant sense to another developer. I find that pairing and iteration helps
here. If you can find a name that at least the pair of you agree then there is
chance is a OK name.


# Conclusion

Learning the technique of reducing dependencies is one of the tools that, if
applied correctly, can result in a system that's easier to test and maintain.


[dependency-problem]:    {% post_url 2015-10-29-dependency-problem %}

