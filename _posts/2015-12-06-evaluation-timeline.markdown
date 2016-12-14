---
layout: post
title: 'Evaluation Timeline'
categories: coding cpp
---

A expression as simple as `severity > 2` can mean different things with respect
to when the intended expression is evaluated.

# Introduction

Say we have log entries with severity and message, and we want to only log
the entries with a severity greater than 2. The expression `severity > 2` for
the log entry can be evaluated at different moments in time:

- runtime
  - immediate
  - deferred
- compile time


# Runtime immediate

This is the straightforward example (only the warning and error messages are
logged):

- `severity > 2` is a `bool` evaluated at runtime
- `severity` is an `int`

### runtime_immediate.cpp
{% highlight c++ linenos %}
#include <iostream>

void log(int severity, const char * message)
{
  if (severity > 2)
  {
    std::cout << message << std::endl;
  }
}

int main()
{
  log(1, "debug message");
  log(2, "verbose message");
  log(3, "warning message");
  log(4, "error message");
}
{% endhighlight %}


# Runtime deferred

In this example things are not what they look at first glance. In the main
function below the code looks straightforward: it creates a logger, it states
the condition for the messages to be logger in the logger construction and then
later only warning and error messages are logged.

### runtime_deferred.cpp
{% highlight c++ linenos %}
#include "logger.ipp"

int main()
{
  logger log{ severity > 2 };

  log(1, "debug message");
  log(2, "verbose message");
  log(3, "warning message");
  log(4, "error message");
}
{% endhighlight %}

However if `severity > 2` would evaluate immediately to a `bool`, then how
could a logger constructed with say `true` would know later which messages to
log?

The intended condition evaluation must be somehow deferred to when the message is
logged. So then:

- `severity > 2` is a function that returns a `bool`
- `severity` is a function that returns the severity of the log entry

A possible implementation might look like:

### logger.ipp
{% highlight c++ linenos %}
#include <functional>
#include <iostream>

std::function<int(int, const char *)> severity =
[](int s, const char *)
{
  return s;
};

std::function<bool(int, const char*)> operator > (
  std::function<int(int, const char *)> fn,
  int level)
{
  return [=](int s, const char * message) -> bool
  {
    return fn(s, message) > level;
  };
};

class logger
{
public:
  explicit logger(
    std::function<bool(int, const char *)> filter) :
    filter_{ filter }
  {
  }

  void operator()(int s, const char * message)
  {
    if(filter_(s, message))
    {
      std::cout << message << std::endl;
    }
  }
private:
  std::function<bool(int, const char *)> filter_;
};
{% endhighlight %}


# Compile time

In this example the expression `severity > 2` is evaluated at compile time.

### compile_time.cpp
{% highlight c++ linenos %}
#include <iostream>
#include <type_traits>

template<int severity, class Enable = void>
struct logger
{
  void operator()(const char *)
  {
  }
};

template<int severity>
struct logger< severity, typename std::enable_if_t<
  (severity > 2)
  >>
{
  void operator()(const char * message)
  {
    std::cout << message << std::endl;
  }
};

template<int severity>
void log(const char * message)
{
  logger<severity>()(message);
}

int main()
{
  log<1>("debug messsage");
  log<2>("verbose message");
  log<3>("warning message");
  log<4>("error message");
}
{% endhighlight %}

