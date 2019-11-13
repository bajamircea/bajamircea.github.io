---
layout: post
title: 'The thread sandwich pattern'
categories: coding cpp
---

A common code structure pattern for multi-threading is the sandwich pattern


# Introduction

**TODO: this is work in progress**

![Thread sandwich](/assets/2019-11-12-thread-sandwich/sandwich.png)

# Code

{% highlight c++ linenos %}
#include <chrono>
#include <condition_variable>
#include <deque>
#include <iostream>
#include <mutex>
#include <thread>

template<typename DataType>
class thread_control
{
  std::deque<DataType> q_;
  bool stop_{ false };
  std::mutex m_;
  std::condition_variable cv_;
public:
  void post_data(const DataType & x)
  {
    {
      std::scoped_lock lock(m_);
      q_.push_back(x);
    }
    cv_.notify_one();
  }

  template<typename Fn>
  void serve(Fn fn)
  {
    while (true)
    {
      DataType x;
      {
        std::unique_lock<std::mutex> lock(m_);
        cv_.wait(lock, [&]{ return !q_.empty() || stop_; });
        if (stop_) return;
        x = std::move(q_.front());
        q_.pop_front();
      }
      fn(x);
    }
  }

  void stop_serving()
  {
    {
      std::scoped_lock lock(m_);
      stop_ = true;
    }
    cv_.notify_one();
  }

  std::deque<DataType> & raw_data()
  {
    return q_;
  }
};

template<typename DataType>
class stoppable_thread
{
  thread_control<DataType> & tc_;
  std::thread td_;
public:
  template<typename Fn>
  stoppable_thread(thread_control<DataType> & tc, Fn fn) :
    tc_{ tc },
    td_{ [&]{ tc_.serve(fn); } }
  {}

  ~stoppable_thread()
  {
    tc_.stop_serving();
    td_.join();
  }
};


int main()
{
  thread_control<int> juggler_control_1;
  thread_control<int> juggler_control_2;

  juggler_control_1.raw_data().push_back(1);
  juggler_control_2.raw_data().push_back(2);

  auto juggler_fn_1 = [&tc = juggler_control_2](int x) { tc.post_data(x); };
  auto juggler_fn_2 = [&tc = juggler_control_1](int x) { tc.post_data(x); };

  {
    stoppable_thread<int> juggler_thread_1(juggler_control_1, juggler_fn_1);
    stoppable_thread<int> juggler_thread_2(juggler_control_2, juggler_fn_2);

    juggler_control_1.post_data(3);

    std::this_thread::sleep_for(
      std::chrono::seconds(2));
  }

  for (int x : juggler_control_1.raw_data())
  {
    std::cout << "Juggler 1 has ball " << x << '\n';
  }
  for (int x : juggler_control_2.raw_data())
  {
    std::cout << "Juggler 2 has ball " << x << '\n';
  }
}
// Prints:
//Juggler 2 has ball 1
//Juggler 2 has ball 3
//Juggler 2 has ball 2
{% endhighlight %}



# TODO marker

# No inheritance for the stoppable thread

# Exceptions

# Flow control and data loss

