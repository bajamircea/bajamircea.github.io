---
layout: post
title: 'Reducing dependencies'
categories: coding cpp
---

Reducing dependecies is a refactoring technique that leads towards increased
code cohesion.


# Description

Say we have a C++ program that deals with objects in room. Here's how a
fictional `room` class might look like:

### room.h (initial)
{% highlight c++ linenos %}
#include "hinge.h"
#include "knob.h"
#include "display.h"
#include "remote.h"

class room
{
  hinge hinge_;
  knob knob_;
  display display_;
  remote remote_;

public:
  void chillax();

private:
  void open_door();
  void start_tv();
};
{% endhighlight %}

### room.cpp (initial)
{% highlight c++ linenos %}
#include "room.h"

void room::chillax() {
  open_door();
  start_tv();
};

void room::open_door() {
  knob_.turn();
  knob_.push();
  hinge_.screech();
  knob_.release();
}

void room::start_tv() {
  display_.plug_in();
  remote_.press_button();
}
{% endhighlight %}

I've tried to ilustate that the `room` class seems to micromanage two sets of
objects: one belonging to a `door` and another set belonging to a `tv`.  Here's
how the code above would look like when refactored to reduce the number of
dependencies:

### door.h (new)
{% highlight c++ linenos %}
#include "hinge.h"
#include "knob.h"

class door
{
  hinge hinge_;
  knob knob_;

public:
  void open();
};
{% endhighlight %}

### door.cpp (new)
{% highlight c++ linenos %}
#include "door.h"

void door::open() {
  knob_.turn();
  knob_.push();
  hinge_.screech();
  knob_.release();
}
{% endhighlight %}

### tv.h (new)
{% highlight c++ linenos %}
#include "display.h"
#include "remote.h"

class tv
{
  display display_;
  remote remote_;

public:
  void start();
};
{% endhighlight %}

### tv.cpp (new)
{% highlight c++ linenos %}
#include "tv.h"

void tv::start() {
  display_.plug_in();
  remote_.press_button();
}
{% endhighlight %}

### room.h (refactored)
{% highlight c++ linenos %}
#include "door.h"
#include "tv.h"

class room
{
  door door_;
  tv tv_;

public:
  void chillax();
};
{% endhighlight %}

### room.cpp (refactored)
{% highlight c++ linenos %}
#include "room.h"

void room::chillax() {
  door_.open();
  tv_.start();
};
{% endhighlight %}


# Smells

Was it worth it? In the fictional example above, probably not: the original
class was quite small to start with. Let's go through a few
smells (indications that something is wrong) requiring this kind of refactoring
to reduce dependencies.

One indication is a large number of `#include` directives. In general a file
including more than about half a dozen other files indicates that it's content
tries to link too many things together at the same time. Examples of exceptions are:

- `<windows.h>` would include lots of other headers. Changing that is might not
  be feasible for backward compatibilty reasons.
- Some entry point of the application where many objects are linked together.
- Would not count something like `<boost/noncopyable.hpp>
- Would count a sequence including `<vector>`, `<set>`, `<map>` and
  `<algorithm>` like one (it's using some standard containers)

Linked to the above, another indication is a large number of member variables.

Large files. For me above 500 lines is becomming large. One example exception
is very simple, very low complexity code (e.g. some giant switch maping a enum to
strings).

Groupings of member functions and/or variables. E.g. in the initial code above
the knob, the handler and open_door are codewise grouped together.

Another smell are classes called `SomethingManager`, `SomethingAgent` or
similar. They are symptoms of antropomorphic design (to cover in a following
post) resulting in classes doing all the things related to whatever `Something`
is.

The smells above are not constraint to C++. Instead of `#include' read
`require` for Ruby, or `import` for Java and the arguments are pretty much the
same.


# Obstacles

Here are some obstacles on reducing the dependencies of unit of code.

Inertia. People just don't want to change habits. The two responses you get are
on the lines of:

- "That's how we've written code since forever."
- "I like to see all my code together, to be able to see what it's doing.". In
  all fairness there some point to the last comment, it's all an act of
  balancing and taste.

The second obstacle is legacy code where concerns are mixed so it's not easy to
identify islands of functionality that could be separated.

The last obstacle is naming. In the initial example I used objects from the
physical world. It was easy to identify that the knob and hinge belong to the
door. We have words for this. For some problem domains, e.g. networking, again
we have words, we know what sockets, addresses, buffers etc. mean.

But in practice it's difficult to find good names for some new problem domain.
The risk is that thare are too many classes named
like`SomeClassThatHoldsThoseOtherTwoThingsTogether` that are not going to make
instant sense to another developer. I find that pairing helps here. If you can
find a name that at least the pair of you agree then there is chance is a OK
name.

# Conclusion

Learning the technique of reducing dependencies is one of the tools that, if
applied correctly, can result in a system that's easier to test and maintain.
