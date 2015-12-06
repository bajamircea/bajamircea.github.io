---
layout: post
title: 'Alternative dependency grouping'
categories: coding cpp
---

When reducing dependencies we usually have several ways of grouping
dependencies.


# Introduction

This article builds on previous articles on dependency injection using C++ and
ilustrates a different grouping to reduce dependencies for the `house` example,
using interfaces. We'll group objects into a `living_room` and `kitchen` which
share the same `door`.

# Code

### house.h
{% highlight c++ linenos %}
#include "kitchen_interface.h"
#include "living_room_interface.h"

class house
{
public:
  house(
    kitchen_interface & kitchen,
    living_room_interface & living_room);

  void chillax();

private:
  kitchen_interface & kitchen_;
  living_room_interface & living_room_;
};
{% endhighlight %}

### house.cpp
{% highlight c++ linenos %}
#include "house.h"

house::house(
  kitchen_interface & kitchen,
  living_room_interface & living_room) :
    kitchen_{ kitchen }
    living_room_ { living_room }
{
}

void house::chillax() {
  kitchen_.exit();
  living_room_.enter();
}
{% endhighlight %}

Here's how for example the `kitchen` is implemented:

### kitchen_interface.h
{% highlight c++ linenos %}
struct kitchen_interface
{
  virtual void exit() = 0;

protected:
  ~kitchen_interface() {};
};
{% endhighlight %}

### kitchen.h
{% highlight c++ linenos %}
#include "kitchen_interface.h"

#include "cuppa_interface.h"
#include "door_interface.h"

class kitchen :
  public kitchen_interface
{
public:
  kitchen(
    cuppa_interface & cuppa,
    door_inteface & door);

  void exit() override;

private:
  cuppa_interface & cuppa_;
  door_interface & door_;
};
{% endhighlight %}

### kitchen.cpp
{% highlight c++ linenos %}
#include "kitchen.h"

kitchen::kitchen(
  cuppa_interface & cuppa,
  door_inteface & door) :
    cuppa_{ cuppa },
    door_{ door }
{
}

void kitchen::exit()
{
  cuppa_.finish();
  door_.open();
}
{% endhighlight %}

The `living_room` class will follow a similar pattern with a `door` to
`close()` and a `tv` to `switch_on()`. Testing should be obvious by now.

The point of this article is that we can arrange if we wish for both the
`kitchen` and the `living_room` to share the same `door`, and the place to do
that is when we construct the `house`:

### main.cpp
{% highlight c++ linenos %}
#include "cuppa.h"
#include "door.h"
#include "tv.h"

#include "kitchen.h"
#include "living_room.h"

#include "house.h"

int main() {
  cuppa c;
  door d;
  tv t;

  kitchen k{ c, d };
  living_room lr{ d, t};

  house h{ k, lr };
  h.chillax();
}
{% endhighlight %}

