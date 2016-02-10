---
layout: post
title: 'Spot the Multi-Threading Bug'
categories: coding cpp
---

Multi-threading is difficult to get right even for the seasoned developer, a
common source of "mostly works" type of program. Try to spot the bug in the
example below.


# The fair-weather coder pitch

Let's try to explain the intent for the code below.

`std::thread` is a weird beast. Most classes perform cleanup on destructor.
However `std::thread` requires you to perform cleanup, in this case to ensure
that the thread is told to end before the destructor of `std::thread` , or else
it [teminates the process][terminate-on-destruct].

`peridic_thread_base` is intended as a reusable class that wraps a
`std::thread` to address the issue above for the case where some action needs
to be performed periodically. Using a carefully balanced combination of
`std::mutex` and `std::condition_variable`, it calls periodically a virtual
function `on_fire` and orchestrates the thread startup (in constructor) and
shutdown (and destructor).

`peridic_thread` is an example of using `periodic_thread_base`. It derives from
it and configures the interval to be every 2 seconds. It also implements `on_fire`.

`main` instantiates a `periodic_thread` and then it waits a bit (5 seconds).
That's just enough time for the `on_fire` function to be called twice.

# The reality

The reality is that the code below has a bug that leads to undefined behaviour
which weirdly in this case means that in practice it almost always works as
expected. Unlike the bugs that are easy to reproduce and one can use a
debugger to step through, this kind of bug usually requires careful code review
to identify.

Try to spot the bug.

## Full source code

{% highlight c++ linenos %}
#include <chrono>
#include <condition_variable>
#include <functional>
#include <iostream>
#include <mutex>
#include <thread>

namespace
{
  class periodic_thread_base
  {
    int interval_seconds_;
    bool must_stop_;
    std::mutex mutex_;
    std::condition_variable condition_variable_;
    std::thread thread_;

  public:
    periodic_thread_base(int interval_seconds) :
      interval_seconds_(interval_seconds),
      must_stop_(false),
      thread_(std::ref(*this))
    {
    }

    ~periodic_thread_base()
    {
      {
        std::lock_guard<std::mutex> lock(mutex_);
        must_stop_ = true;
        condition_variable_.notify_one();
      }
      thread_.join();
    }

    void operator() ()
    {
      std::unique_lock<std::mutex> lock(mutex_);

      while ( ! must_stop_)
      {
        condition_variable_.wait_for(lock,
          std::chrono::seconds(interval_seconds_));
        if (must_stop_)
        {
          return;
        }

        on_fire();
      }
    }

    virtual void on_fire() = 0;
  };

  class periodic_thread :
    private periodic_thread_base
  {
  public:
    periodic_thread() :
      periodic_thread_base(2)
    {
    }

  private:
    void on_fire() override
    {
      std::cout << "Fire" << std::endl;
    }

  };

  void wait_a_bit()
  {
    std::this_thread::sleep_for(
      std::chrono::seconds(5));
  }
} // anonymous namespace

int main()
{
  {
    periodic_thread p;
    wait_a_bit();
  }
  std::cout << "Done" << std::endl;
}

// Compile with:
//   g++ -std=c++11 -pthread main.cpp && ./a.out
// Prints:
//   Fire
//   Fire
//   Done
{% endhighlight %}


[terminate-on-destruct]:   http://www.open-std.org/jtc1/sc22/wg21/docs/papers/2008/n2802.html

