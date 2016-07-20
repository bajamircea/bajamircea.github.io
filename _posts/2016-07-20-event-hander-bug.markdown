---
layout: post
title: 'Spot the Event Handler Bug'
categories: coding cpp
---

Sometimes there is a significant gap between the intent of the code and what it
actually accomplishes, as this event handler code shows. Try to spot the bug in
the example below.


# Discaimer

DO NOT USE THE CODE BELOW BECAUSE IT CONTAINS BUGS. IT IS SIMPLY AN EXERCISE
FOR FINDING THE BUGS.


# The fair-weather coder pitch

Let's try to explain the intent for the code below.

This code implements an event handler in C++. It is inspired by classes in the
.NET framework / C# where one can register multiple delegates with an event
handler and when the event handler is fired, all the delegates are called
sequentially.

The class `EventHandler` is a template that implements such an event handler, and
the delegate is simply a `std::function`. To fire the event handler, call it as if
it were a function. Use `+=` to add a delegate and `-=` to remove.

See for example how `SomeClass` can be used to have a method called when a
`on_click_handler` is called in the `main` function.


# The smells

Past the charming story above there are smells in the code, things that are not
quite right in this context:

- the macro at the beginning (this is not a context that requires a macro)
- not using a RAII class to register/unregister the delegate
- the reference counting for the delegates (why would you subscribe a delegate
  more than once?)
- the usage of pointers:`void *` in particular, but also for the
  `OnClickHandler`

In my experience questioning this kind of smells often triggers defensive
reactions of the kind 'oh well, what you're questioning is not really wrong, it
is more about your preferences'.


# The reality

The reality is that the code below practically does not work for more than one
delegate per event handler, negating the charming story it tries to tell.

Try to spot the bug.


## Full source code

{% highlight c++ linenos %}
#include <functional>
#include <iostream>
#include <map>

#define BIND_TO_MEMBER(member) std::bind(&member, this, std::placeholders::_1, std::placeholders::_2)

template<class EventArgs>
class EventHandler
{
public:
  typedef std::function<void(void * sender, EventArgs event_args)> EventDelegate;

  void operator() (void * sender, EventArgs event_args)
  {
    for (auto & subscriber : subscribers_)
    {
      for (int i = 0 ; i < subscriber.second ; ++i)
      {
        subscriber.first(sender, event_args);
      }
    }
  }

  void operator+= (const EventDelegate & delegate)
  {
    auto it = subscribers_.find(delegate);
    if (it != subscribers_.end())
    {
      it->second++;
    }
    else
    {
      subscribers_.insert(std::make_pair(delegate, 1));
    }
  }

  void operator-= (const EventDelegate & delegate)
  {
    auto it = subscribers_.find(delegate);
    if (it != subscribers_.end())
    {
      if (it->second > 1)
      {
        it->second--;
      }
      else
      {
        subscribers_.erase(it);
      }
    }
  }

private:
  struct EventDelegateComparer
  {
    bool operator() (
      const EventDelegate & lhs,
      const EventDelegate & rhs)
    {
      return lhs.template target<EventArgs>() < rhs.template target<EventArgs>();
    }
  };

  std::map<EventDelegate, int, EventDelegateComparer> subscribers_;
};

struct OnClickArgs
{
};

typedef EventHandler<OnClickArgs*> OnClickHandler;

class SomeClass
{
public:
  SomeClass(OnClickHandler & on_click_handler):
    on_click_handler_{ on_click_handler }
  {
    on_click_handler_ += BIND_TO_MEMBER(SomeClass::on_click);
  }
  ~SomeClass()
  {
    on_click_handler_ -= BIND_TO_MEMBER(SomeClass::on_click);
  }

  void on_click(void *, OnClickArgs *)
  {
    std::cout << "SomeClass::on_click was called\n";
  }

private:
  OnClickHandler & on_click_handler_;
};

int main()
{
  OnClickHandler on_click_handler;
  SomeClass some_class{ on_click_handler };

  OnClickArgs on_click_args;
  on_click_handler(nullptr, &on_click_args);
}

// Compile with:
//   g++ -std=c++11 main.cpp && ./a.out
// Prints:
//   SomeClass::on_click was called
{% endhighlight %}

