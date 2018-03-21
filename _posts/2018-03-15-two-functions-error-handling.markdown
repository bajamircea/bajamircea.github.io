---
layout: post
title: 'Error handling: provide two functions'
categories: coding cpp
---

One approach of dealing with the fact that sometimes exceptions are
appropriate, sometimes error codes are better is to provide two related
functions: one that throws, the other that returns an error code.

# Introduction

There are a [variety of approaches][handling-disappointment] to providing
library APIs that might have errors.

This article provides for reference an example of the approach to provide two
related functions: one that throws, the other that return an error code.

# Code

## error_code.h

{% highlight c++ linenos %}
#pragma once

#include <cstdint>
#include <system_error>

namespace xyz
{
  enum class error_code : int
  {
    some_error = 1,
    another_error = 2
  };

  const std::error_category & error_category();
}

namespace std
{
  template <> struct is_error_code_enum<xyz::error_code> : public std::true_type { };
}

namespace xyz
{
  std::error_code make_error_code(xyz::error_code e);
}
{% endhighlight %}


## error_code.cpp

{% highlight c++ linenos %}
#include "error_code.h"

#include <sstream>

namespace
{
  class error_category_impl : public std::error_category
  {
    public:
      const char * name() const noexcept override
      {
        return "xyz::error_category";
      }

      std::string message(int value) const override
      {
        switch (static_cast<xyz::error_code>(value))
        {
          case xyz::error_code::some_error:
            return "Some error";
          case xyz::error_code::another_error:
            return "Another error";
          default:
            std::stringstream ss;
            ss << "XYZ error: " << value;
            return ss.str();
        }
      }
  };
}

namespace xyz
{
  const std::error_category & error_category()
  {
    static error_category_impl instance;
    return instance;
  }

  std::error_code make_error_code(xyz::error_code e)
  {
    return std::error_code(static_cast<int>(e), xyz::error_category());
  }
}
{% endhighlight %}


## error.h

{% highlight c++ linenos %}
#pragma once

#include <system_error>

namespace xyz::error
{
  inline void throw_if_error(std::error_code ec, const char * exception_message)
  {
    if (ec)
    {
      throw std::system_error(ec, exception_message);
    }
  }
}
{% endhighlight %}


## api.h

{% highlight c++ linenos %}
#pragma once

#include "error_code.h"

namespace xyz::api
{
  int some_fn(int arg1, int arg2, std::error_code & ec) noexcept;
  int some_fn(int arg1, int arg2);
}
{% endhighlight %}


## api.cpp

{% highlight c++ linenos %}
#include "api.h"

#include "error.h"

namespace xyz::api
{
  int some_fn(int arg1, int arg2, std::error_code & ec) noexcept
  {
    ec = std::error_code();
    if (arg1 < 0)
    {
      ec = xyz::error_code::some_error;
      return 0;
    }
    if (arg2 < 0)
    {
      ec = xyz::error_code::another_error;
      return 0;
    }
    return (arg1 + arg2);
  }

  int some_fn(int arg1, int arg2)
  {
    std::error_code ec;
    int result = some_fn(arg1, arg2, ec);
    error::throw_if_error(ec, "some_fn");
    return result;
  }
}
{% endhighlight %}


## main.cpp

{% highlight c++ linenos %}
#include "api.h"

#include <iostream>

int main()
{
  try
  {
    int result = xyz::api::some_fn(42, 43);
    std::cout << "Result: " << result << '\n';
    result = xyz::api::some_fn(-1, 43);
    std::cout << "Result: " << result << '\n';
  }
  catch (const std::exception & e)
  {
    std::cout << "Exception: " << e.what() << '\n';
  }
}

/* Outputs:
Result: 85
Exception: some_fn: Some error
*/
{% endhighlight %}

# Issues

One issue with this style of API is that one would expect that the version that
has an error code as argument is `noexcept`. However it's not so easy in
practice as a lot of containers throw `std::bad_alloc` when running out of
memory. So then the options are either:

- you're happy to terminate when out of memory
- you try catch for `std::bad_alloc` inside the version with error code
- you use custom containers that provide error codes as arguments instead of
  throwing (dealing with challenges around copying)

# References

Lawrence Crowl: Handling Disappointment in C++<br/>
[http://www.open-std.org/jtc1/sc22/wg21/docs/papers/2015/p0157r0.html#both][handling-disappointment]

Chris Kohlhoff: System error support in C++0x - part 1 to 5<br/>
[http://blog.think-async.com/2010/04/system-error-support-in-c0x-part-1.html][ch]

[handling-disappointment]: http://www.open-std.org/jtc1/sc22/wg21/docs/papers/2015/p0157r0.html#both
[ch]: http://blog.think-async.com/2010/04/system-error-support-in-c0x-part-1.html
