---
layout: post
title: 'Idiom: C API wrapper'
categories: coding cpp
---

Wrapping C APIs in C++.


This article is part of a series of [articles on programming
idioms][idioms-intro].

# C APIs

I provided an overview of the typical C APIs using handles in a [previous
article][c-api]. A good way of wrapping it is a combination of the [FIT
RAII][fit-raii] techniques and techniques employed by `std::filesystem`.


# From the FIT RAII techniques

You need the `raii_with_invalid_value` template written once. It's similar to
`std::unique_ptr`, but provides functionality that makes sense for handles, not
pointers e.g. it allows for a `invalid_value` that is not `nullptr` (as some C
APIs do).

Then you create a wrapper once for every handle type:
{% highlight c++ linenos %}
struct registry_handle_traits {
  using handle = HKEY;
  static constexpr auto invalid_value = nullptr;
  static void close_handle(handle h) noexcept {
    static_cast<void>(::RegCloseKey(h));
  }
};

using registry_handle = raii_with_invalid_value<registry_handle_traits>;
{% endhighlight %}

This handle is as regular as it can be, but:
- it cannot be copied (only moved)
- it does not implement equality (does not make sense, can't be copied)
- it does not implement order (no equality)

The traits are usually hidden in a `details` namespace (or using an underscore
prefix). Note I've left out such details like namespaces for brevity.

Then you'll have functions that return such a handle

{% highlight c++ linenos %}
registry_handle create_registry_key(...);

registry_handle open_registry_key(...);
{% endhighlight %}

Then you might want to have a type that can be used as a function argument
taking either a `const &` to the RAII handle or a raw handle (e.g. like
`HKEY_LOCAL_MACHINE` in the case of registry). This is based on `handle_arg`
that only has to be written once.

{% highlight c++ linenos %}
using registry_handle_arg = handle_arg<registry_handle>;
{% endhighlight %}

Then you have functions that use the handle:

{% highlight c++ linenos %}
std::wstring read_registry_string(
  registry_handle_arg key,
  const std::wstring & value_name);

std::vector<std::wstring> read_registry_multistring(
  registry_handle_arg key,
  const std::wstring & value_name);
{% endhighlight %}

Then you might have the situation where closing the handle could fail. That's
common for cases where writes are buffered and closing the handle flushes the
content and might detect write failures. Throwing from the destructor is not a
good option. You create a function that takes over the handle ownership and
closes the handle, throwing for errors. The user has to remember to call this
function to detect failures.

{% highlight c++ linenos %}
void close(file_raii & x) {
  int result = std::fclose(x.release());
  if (result != 0) {
    error::throw_failed("fclose");
  }
}
{% endhighlight %}

There are also common scenarios where there are soft failures due to the entry
not being present.

At it's simplest deleting a key might detect that the key does not exist. A
boolean is used to communicate if the key was actually present. This can be
used to issue a large number of delete key operations and only log for the ones
that return true.

{% highlight c++ linenos %}
bool delete_registry_key(...);

void foo() {
  if (delete_registry_key(...)) {
    LOG << "Deleted key.";
  }
}
{% endhighlight %}

While we are here, it's worth mentioning that the C API wrapper themselves
usually don't log, letting the user do the logging as seen above.

Another case is trying to open a registry key that might or might not exist.
That would be similar to `open_registry_key`, but the caller then has to check
if the handle is valid. An invalid handle indicates that the key was missing
and hence not opened.

{% highlight c++ linenos %}
registry_handle open_registry_key_if_exists(...);

void foo() {
  auto key = open_registry_key_if_exists(...);
  if (!key) {
    LOG << "Key is missing.";
  }
  else {
    // use key
  }
}
{% endhighlight %}

A third situation is trying to read a registry string value that might or might
not exist. That would be similar to `read_registry_string`, but we need to
return an `std::optional<std::wstring>` to distinguish between registry value
not present (an `nullopt`) and a registry value present, but an empty string.

{% highlight c++ linenos %}
std::optional<std::wstring> read_registry_string_if_exists(...);

void foo() {
  auto value = read_registry_string_if_exists(...);
  if (!value) {
    LOG << "Value is missing.";
  }
  else {
    // use *value string
  }
}
{% endhighlight %}


# Error handling std::filesystem style

The approach is to have two overloads: one that throws for all errors another
one that takes `std::error_code & ec` as the last parameter. The one taking the
error code might throw `std::bad_alloc` to indicate a out of memory error,
setting the error code for all other errors:

{% highlight c++ linenos %}
std::wstring read_registry_string(
  registry_handle_arg key,
  const std::wstring & value_name,
  std::error_code & ec);

std::wstring read_registry_string(
  registry_handle_arg key,
  const std::wstring & value_name);
{% endhighlight %}

When functions have defaulted parameters, the error code should be the last
function parameter that is not defaulted.

The error code contains an error number and an error category that is
eventually an object used to interpret the error number. To keep the error code
small, the error category is ultimately an object with a long scope (`static`
inside non-member function) and the error code keeps just a reference to such a
long lived object, rather than the object itself. You might need to invest into
understanding this mechanism to:
- provide custom error categories (e.g. for registry string blob size is not
  multiple of `wchar_t`
- improve upon `std::system_category` error string formatting (e.g. to ensure
  the language is the one you desire)

Implementation-wise you'll want to actually implement the error code taking
function, then implement the exception throwing one in terms of the first,
throwing `std::system_error`.

{% highlight c++ linenos %}
foo bar(..., std::error_code & ec) {
  ec = std::error_code{};
  // implement functionality here
  // on error set
  // ec = std::error(code, my_error_category())
}

foo bar(...) {
  std::error_code ec;
  auto return_value = bar(..., ec);
  if (ec) {
    throw std::system_error(ec, "bar failed");
  }
  return return_value;
}
{% endhighlight %}

When an error code is set, the returned value is usually the default
constructed one. This is not a contract for the caller. The caller should
always check the error code first, before even checking the returned value.


# Why this idiom works?

It practically solves the problem of resource leaks.

It has enough flexibility to cover a variety of C APIs.

It avoids repeatedly implementing low level error handling.

It presents a common, well understood way to wrap them so that generally a user
can reason on the behaviour of the C++ wrapper based on the rules above and the
documentation of the C APIs.

Sure we could have used a slight variation in the error handling, the
duplication of exception throwing vs. error code yielding is annoying, but the
experience of `std::filesystem` was that once it was available codebases often
made a quick transition to it instead of calling the OS APIs directly.


# What are it's limits?

For most C APIs such implementation would be largely mechanical where the C++
wrapping function calls the C API and check for the error.

But for some it's better to go for a slightly higher level.  Behind a single C
API function, many higher level scenarios might be hidden: e.g. we've seen
`read_registry_string` and `read_registry_multistring` that are both build on
top of the single C API function `::RegQueryValueEx`. The advantage is that
`read_registry_string` can do more than just call `::RegQueryValueEx` twice
(one to get the size followed by one to get the content), but also handle a
small value optimisation (a lot of values are short, meaning that a C API call
can be elided) and handle the case where the value size changes between the C
API calls.

Equally it's easy to fall into the trap of creating a wrapper that's too
specific to the current usage in an application, too high level, and lacks
generality and ability to reuse.

Choosing the right level can be tricky, requiring human judgement
and experience.

For some cases you might need a RAII class different from
`raii_with_invalid_value` to return from a function wrapping
`CoInitializeEx(NULL, COINIT_MULTITHREADED)` for example. I recommend you
ensure such a class is default constructible to allow the error code overload
to return the same type.


# Testing

Pure unit testing in the style we've seen for the regular idiom is not possible
for the C API wrappers in the current form.

Just changing the form is not justified if it results in much more complex code
and all is achieved is doing calls against mock C APIs that don't actually test
real functionality, just call expectations. Often the programmer's expectations
are made clear by checking the code.

**Experience shows that most of the testing gains are from testing against the
actual C APIs**. That exposes unexpected behaviour of the C API such as
`::RegQueryValueEx` not returning the written data size for incorrectly sized
data, which is important when using the small value optimisation.

Testing against the actual C APIs might require tests to run as admin on a
separate machine/platform from the build machine and also requires that a
critical number of functions are wrapped, e.g. to test `read_registry_string`
you also have to implement `write_registry_string`, `create_registry_key` and
`delete_registry_key`.

And to see what we can do to ensure that this testing difficulty does not
extend to the whole application we're going to [look to another
idiom][interfacesidiom].


[idioms-intro]:    {% post_url 2022-10-17-idioms %}
[c-api]:    {% post_url 2015-03-06-c-api-objects %}
[fit-raii]: {% post_url 2022-06-29-fit-raii %}
[interfacesidiom]: {% post_url 2022-10-26-mockable-interfaces-idiom %}
