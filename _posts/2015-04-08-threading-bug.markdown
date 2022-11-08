---
layout: post
title: 'Spot the Multi-Threading Bug'
categories: coding cpp
---

Multi-threading is difficult to get right even for the seasoned developer, a
common source of "mostly works" type of program. Try to spot the bug in the
example below.


# Disclaimer

DO NOT USE THE CODE BELOW BECAUSE IT CONTAINS BUGS. IT IS SIMPLY AN EXERCISE
FOR FINDING THE BUGS.

# The fair-weather coder pitch

Let's try to explain the intent for the code below.

`std::thread` is a weird beast. Most classes perform cleanup on destructor.
However `std::thread` requires you to perform cleanup, in this case to ensure
that the thread is told to end before the destructor of `std::thread` , or else
it [terminates the process][terminate-on-destruct].

`peridic_thread` is intended as a reusable class that wraps a `std::thread` to
address the issue above for the case where some action needs to be performed
periodically. Using a carefully balanced combination of `std::mutex` and
`std::condition_variable`, it calls periodically a virtual function `on_fire`
and orchestrates the thread startup (in constructor) and shutdown (and
destructor).

`some_peridic_thread` is an example of using `periodic_thread`. It derives from
it and configures the interval to be every 2 seconds. It also implements
`on_fire`.

`main` instantiates a `some_periodic_thread` and then it waits a bit (5
seconds).  That's just enough time for the `on_fire` function to be called
twice.

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
  class periodic_thread
  {
    std::chrono::seconds sleep_duration_;
    bool must_stop_;
    std::mutex mutex_;
    std::condition_variable condition_variable_;
    std::thread thread_;

  public:
    explicit periodic_thread(
      const std::chrono::seconds & sleep_duration
      ) :
      sleep_duration_{ sleep_duration },
      must_stop_{ false },
      thread_{ [this](){ this->run(); } }
    {
    }

    virtual ~periodic_thread()
    {
      {
        std::scoped_lock lock(mutex_);
        must_stop_ = true;
      }
      condition_variable_.notify_one();
      thread_.join();
    }

    virtual void on_fire() = 0;

  private:
    void run() noexcept
    {
      std::unique_lock lock(mutex_);

      while ( ! must_stop_)
      {
        condition_variable_.wait_for(lock, sleep_duration_);
        if (must_stop_)
        {
          return;
        }

        on_fire();
      }
    }
  };

  class some_periodic_thread :
    private periodic_thread
  {
  public:
    some_periodic_thread() :
      periodic_thread(std::chrono::seconds(2))
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
    some_periodic_thread p;
    wait_a_bit();
  }
  std::cout << "Done" << std::endl;
}

// Compile with:
//   g++ -std=c++17 -pthread main.cpp && ./a.out
// Prints:
//   Fire
//   Fire
//   Done
{% endhighlight %}


[terminate-on-destruct]:   http://www.open-std.org/jtc1/sc22/wg21/docs/papers/2008/n2802.html

