---
layout: post
title: 'Dependencies: the problem'
categories: coding cpp
---

Sometimes a C++ class grows too big and complex, dealing with too many issues,
to the point where it is difficult to reason about it and test it. This article
describes the problem.

# The problem

The generic issue is lack of clear, single, focused responsibility for a C++
class. Let's go through a few smells (indications that something is wrong) requiring
refactoring to reduce dependencies.

Large files. For me a source file above 500 lines is becoming large. One
example exception is very simple, very low complexity code (e.g. some giant
switch maping an enum to strings).

Another smell is a large number of member variables in a class, with no (or
very loose) relationship to each other.

Another smell are classes called `SomethingManager`, `SomethingAgent` or
similar that grew over time to contain all the code related to whatever
`Something` is. They are symptoms of antropomorphic design (to cover in a following
post).

Related to the above is a large number of `#include` directives required to
support the amount of functionality in the class. In general a file including
more than about half a dozen other files indicates that its content tries to
link too many things together at the same time. Examples of exceptions are:

- Some entry point of the application where many objects are just linked
  together.
- Would not count basic utilities like `<boost/noncopyable.hpp>`.
- Would count a sequence including `<vector>`, `<set>`, `<map>` and
  `<algorithm>` like one (it's using some standard containers).
- Some API header like `<windows.h>` would include lots of other headers.
  Changing that might not be feasible for backward compatibilty reasons.

Sometimes one can identify a group of member variables, that are used together
in code, that are very loosely coupled with other groups of member variables of
the same class.

I'm going to focus on the problem of a class depending/having too many member
variables.


# Sample problem code

Say we have a C++ program that deals with objects in a house. The entry point
is a function called `chillax`. It performs the actions of a person that
finishes a cup of tea, and then leaves the kitchen to go into the living room
to watch TV. Between the rooms there is a door with knobs and a hinge that
screeches. The TV is unplugged and has a remote.

Here's how a fictional `house` class might look like:

### house.h
{% highlight c++ linenos %}
#include "tea.h"
#include "cup.h"
#include "hinge.h"
#include "knob.h"
#include "display.h"
#include "remote.h"

class house
{
public:
  void chillax();

private:
  void open_door();
  void close_door();

private:
  tea tea_;
  cup cup_;
  hinge hinge_;
  knob knob1_;
  knob knob2_;
  display display_;
  remote remote_;
};
{% endhighlight %}

### house.cpp
{% highlight c++ linenos %}
#include "house.h"

void house::chillax() {
  tea_.drink();
  cup_.rinse();

  open_door();
  close_door();

  // switch TV on
  display_.plug_in();
  remote_.press_button();
}

void house::open_door() {
  knob1_.turn();
  knob1_.push();
  hinge_.screech();
  knob1_.release();
}

void house::close_door() {
  knob2_.turn();
  knob2_.push();
  hinge_.screech();
  knob2_.release();
}
{% endhighlight %}

The class above is to a certain degree contrived because and its dependencies
have already been abstracted into separate classes in order to keep the example
short. Imagine an order of magnitude more code, members and includes.


# Conclusion

The smells above are not constraint to C++. Instead of `#include` read
`require` for Ruby, or `import` for Java and the arguments are pretty much the
same.

Also one can apply the same logic outside classes e.g.: a program might perform
unrelated actions depending on its command line arguments.

