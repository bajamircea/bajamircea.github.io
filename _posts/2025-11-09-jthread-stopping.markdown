---
layout: post
title: 'std::jthread stopping'
categories: coding cpp
---

Canonical way to stop a `std::jthread`, using `std::stop_token` and
`std::stop_callback`.


# Canonical example

Assuming you want to run in a child thread some `example_server` similar to the
ones provided by Python socketserver:

{% highlight c++ linenos %}
void foo() {
  std::jthread t([](std::stop_token token) {
    // ...
    auto callback = std::stop_callback(
      token,
      [&](){
        // function usually called from the parent thread
        // to make the child thread exit the processing loop
        example_server.shutdown();
      }
    );
    // child thread blocked in some processing loop
    example_server.serve_forever();
  });
}
{% endhighlight %}


# Explanation

`std::thread` (without `j`), introduced in C++11, does not join in the
destructor, i.e. it does not wait for the underlying thread to stop. If the
destructor is reached and the underlying thread is still running,
`std::terminate()` will be called. You could detach the `std::thread` object
from the underlying thread, but that's usually a bad idea: for example the
underlying thread uses objects that might go out of scope. So therefore you
need to ensure that the underlying thread stops before the `std::thread` object
is destroyed.

`std::jthread`, introduced in C++20, joins in the destructor. But what makes it
more useful than `std::thread` is that it also provides a mechanism to
communicate to the underlying thread to stop. That mechanism is based on
`std::stop_source`, `std::stop_token` and `std::stop_callback`.

`std::jthread` has a `std::stop_source`. For the canonical usage of
`std::jthread` you would use a functor that takes a `std::stop_token` as an
argument. `std::jthread` will provide the functor with a `std::stop_token`
linked to the `std::stop_source` that it owns. In the `std::jthread`
destructor, it will `request_stop()` on that `std::stop_source` before
joining. The underlying thread will thus know that it needs to stop and will
exit.


# Another option: poll

You can poll, an option if the child thread does not block longer that you're
willing to wait in the parent thread:

{% highlight c++ linenos %}
void foo() {
  std::jthread t([](std::stop_token token) {
    // ...
    while (!token.stop_requested()) {
      // do stuff
    }
  });
}
{% endhighlight %}


# Another option: condition variable

If you want to exit a blocking condition variable when a stop is requested, you
can do it with a `std::condition_variable_any`:

{% highlight c++ linenos %}
void foo() {
  std::jthread t([] (std::stop_token stoken) {
    std::mutex mutex;
    std::unique_lock lock(mutex);
    std::condition_variable_any cv;
    cv.wait(lock, stoken,
      [&stoken] { return stoken.stop_requested(); });
  });
}
{% endhighlight %}

# FAQ

**Q:** How does `std::stop_callback` handles the race case where the
`request_stop()` was already called on the `std::stop_source` in the parent
thread?<br/>
**A:** In that case the functor provided to `std::stop_callback` is called when
the `std::stop_callback` is constructed in the child thread.

**Q:** What about the case where the `std::stop_callback` functor is being
executed from the parent thread, while the `std::stop_callback` is destructed
in the child thread?<br/>
**A:** The destructor of the `std::stop_callback` will wait for the functor to
complete before continuing the destruction.

**Q:** How does `std::stop_callback` handles the race case where it is
destructed before `request_stop()`is called on the `std::stop_source` in the
parent thread?<br/>
**A:** In that case the functor provided to `std::stop_callback` is not called.

**Q:** What's `std::inplace_stop_source()`?<br/>
**A:** It was introduced in C++26 to support low level concurrency primitives
around coroutines, sender/receiver without allocating when a stop source is
constructed. `std::stop_source()` heap allocates a shared state which means:
constructing can throw, copy is `noexcept` and `stop_possible()` exists to
return `false` if it does not have a shared state (e.g. moved from object).


# How do they work?

The stop source has a `bool` that can be toggled on with `request_stop()`. It
also has a list of current stop callbacks. When `request_stop()` toggles the
`bool`, it will also traverse the list and call the currently registered stop
callbacks.

The stop token is "just" a pointer to the `stop_source`. It is passed by value.
The holder of a stop token cannot `request_stop()`, but can check
`stop_requested()`.

The stop callback uses the stop token to reach the list of current stop
callbacks and insert a node that it provides.

Implementing such types to handle multithreaded synchronization is a medium to
hard exercise.

[More info on how stop source, token and callback
work](/presentations/2025-06-03-stop.html)
