---
layout: post
title: 'API Fragmentation'
categories: coding cpp
---

While writing generic code that can be reused is a great ideal, I claim that in
practice there is a need to repeatedly implement similar functionality.


# Introduction

I'm going to use the following two common tasks as examples: read the whole
binary contents of a file and find a value in your data.

APIs for such tasks would be functions with declarations like:

{% highlight c++ linenos %}
std::vector<char> read_contents(const std::string & file_name);

template<typename It, typename T>
It find(It first, It last, const T & value);
{% endhighlight %}

Ideally for each common task you would design one true API, implement it once,
and invoke the API whenever you need to achieve the corresponding task. We want
to reuse code, not implement repeatedly the same functionality. Code reuse
means reducing the size of the code that needs to be maintained, leading to
increased productivity. For very common tasks as the ones above, you might even
use implementations from [standard][find] or third-party libraries, so you
don't have to implement the API. STL is a great canonical example of the
'implement once, reuse many times' principle.

However I find that complex projects there are orthogonal low level
requirements (i.e. unrelated to each other) that each require additional APIs
for what appears as the same high level task. The relation is exponential, i.e.
the number of APIs grows exponentially with these low level requirements.

I call this the fragmentation of APIs.


# Language

The above functions are fine if your language is C++. For other languages
(Python, Java, etc.) you'll have a different API, you might duplicate
implementations per language, even if conceptually the APIs are same.


# Platform dependencies

By platform I mean OS (operating system), version of OS, bitness (32 or 64 bit).

As soon as in your implementation you use something platform dependent, even if
you maintain the same API, you might duplicate some parts of the
implementation.


# Exceptions vs. error codes

The implicit assumption in the `read_contents` function above is that if it
encounters an error, it will throw.

That is fine if you read a configuration file that is required for operation of
the program and it is the responsibility of a separate setup program to have
made it available.

However there are domains where failing to read files happens routinely (maybe
the setup program itself has to be resilient against bad configurations).

For that you need some additional strategy to [handle the
disappointment][handle-disappointment], for example add a version that does not
throw and returns an error code that needs to be checked.

{% highlight c++ linenos %}
std::vector<char> read_contents(const std::string & file_name, std::error_code & ec) noexcept;
{% endhighlight %}

You will probably delegate the implementation of the throwing version to the
non-throwing version of the API, but now there are two version of the API to
choose from.

NOTE: Allocations make it particularly difficult to have `noexcept` versions
(see the Issues section in [this article][two-functions]).

Another related situation are functions that are called from destructors (say
closing a file). You might have a version that is called as a normal function
(which can throw), and a version that is called from a destructor. The version
called from destructor (or move) does not throw. Instead of throwing it either
ignores failure, just logs or event terminates the process (depending on the
situation).


# Performance vs. easy/local reasoning

It's very convenient to return the contents of the file, but if you open a
large number of files sequentially you might want to avoid repeated
allocations. So you might then pass a buffer by reference. See for example
`std::getline` for a similar approach.

{% highlight c++ linenos %}
void read_contents(const std::string & file_name, std::vector<char> & buffer);
{% endhighlight %}

As far as `find` is concerned, if you know that the data is sorted you might
want to use something like `std::lower_bound` instead (never mind that
different containers have their own `find` method).

But even for sequential find there are faster options if you're willing to
break the default/usual/basic rules e.g. if `last` can be dereferenced and
written to. Then you can reduce the number of operations in the loop. See Knuth
for this approach.

{% highlight c++ linenos %}
template<typename It, typename T>
// requires *last is writable
It mutable_find(It first, It last, const T & value) {
  *last = value;
  while (*first != value) {
    ++first;
  }
  return first;
}
{% endhighlight %}


# Blocking vs. asynchronous

The implicit assumption in the `read_contents` function above is that it will
block the thread until the file is opened and read. If your program performs
several activities you'll want a additional version that returns as soon as the
operation is initiated and calls a callback when completed.

{% highlight c++ linenos %}
template<typename Callback>
void async_read_contents(const std::string & file_name, std::vector & buffer, Callback cb);
{% endhighlight %}


# Parallelism variations

For `find` above the assumption is that the search will be single threaded and
sequential. For some cases it might be desirable to be able to exploit
parallelism. Here is a version specifying the [type of
parallelism][exec-policy] to use.

{% highlight c++ linenos %}
template<typename ExecutionPolicy, typename It, typename T>
It find(ExecutionPolicy && policy, It first, It last, const T & value);
{% endhighlight %}

Similar versions might appear for thread related reasons e.g.: you have a
thread safe version of a data structure.


# Blob vs. chunk

The return from `read_contents` is a `vector`. That is appropriate for small
files that you trust will fit in memory. You might need a lower level API that
returns some RAII wrapper for the file and a read function that reads a buffer
at a time. `read_contents` should be implemented using the lower level API, but
this still adds additional choice to the user that wants to read the contents
of a file.


# Compile time vs. run time

The API could look different if you choose things to be done compile time. E.g.
you want a run time array: `std::vector`. To construct of a desired size you
provide the desired size as an argument to the constructor. If you want fixed
compile time size you might use `std::array`. To construct of the desired size
you provide it as a template parameter.


# What types should we accept?

For a function like `min`, do we have to have overloads with `const` arguments?

The `const` variation is just the start. How much do we constrain the types we
use in the API?

- The `file_name` does it need to be a `std::string`, how about string
  literals like "config.ini"? Can address using some `gsl::zstring_span`
- The `file_name` will probably wide (16 bits per character) on Windows. Can
  use a template, but might still need to split part of the implementation.
- `vector<char>` can be `vector<unsigned char>` or `vector<std::byte>` 
- Does it even have to be a `vector`?
- To support sentinels: do we have to have the same type for `first` and
  `last`?
- To support ranges do we have to have an overload receiving a `range` instead
  of `first` and `last`.

But this can't be generalized forever:
- likely the `file_name` has to be zero terminated so that it can be passed to
  the OS API that is typically a C function expecting a zero terminated string.
- When `file_name` is a `string`: what encoding do we accept?


# Conclusion

The article shows that there are barriers to code reuse due to independent
concerns that that have different requirements.

For some issues we can find some options so that the number of APIs for a
common task does not multiply exponentially.

But in general the consequence is a fragmentation of the APIs, that is for a
common task we need to provide multiple APIs and choose carefully which one to
use each time.

Swiss-knife approaches like [`CreateFile`][create-file] where a single function
has additional parameters or flags that fundamentally change behaviour (e.g.
see the `FILE_FLAG_OVERLAPPED` flag) are really multiple APIs under disguise.


## References

- Donald Knuth, "Structured Programming with Goto Statements"

- Lawrence Crowl: [Handling Disappointment in C++][handle-disappointment]

[handle-disappointment]: http://www.open-std.org/jtc1/sc22/wg21/docs/papers/2015/p0157r0.html
[find]: http://en.cppreference.com/w/cpp/algorithm/find
[exec-policy]: http://en.cppreference.com/w/cpp/algorithm/execution_policy_tag_t
[create-file]: https://msdn.microsoft.com/en-us/library/windows/desktop/aa363858(v=vs.85).aspx
[two-functions]: {% post_url 2018-03-15-two-functions-error-handling %}
