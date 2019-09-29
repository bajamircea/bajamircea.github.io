---
layout: post
title: 'Remove a folder - standard libraries'
categories: coding cpp
---

How hard can it be to remove a folder in Windows? Part 1: Using C++ standard
libraries


# Introduction

I recently worked on a project where one of the simplest task was to remove a
folder in Windows using C++. The only catch was that it needed to be robust and
really do a good attempt to remove the folder. How hard can it be?

# Using standard libraries

The good news is that there are standard libraries for doing just that in the
`std::filesystem` namespace since C++17. These libraries are based on the
`boost::filesystem` libraries that have been available for a long time in
`boost`. And the Microsoft C++ compiler included them in the
`std::experimental::filesystem` namespace well before 2017.

The functions to remove a entry from the filesystem given a path look like:
{% highlight c++ linenos %}
bool remove(const std::filesystem::path& p);
bool remove(const std::filesystem::path& p, std::error_code& ec) noexcept;
{% endhighlight %}

There are two versions: the first one receives just the path. There are two
possible outcomes to start with. The function either succeeds, in which case it
returns, or it fails, in which case it throws an exception. The success case
also has two possible outcomes. If the entry existed and was deleted the
function returns `true`. If the file did not exist it returns `false`.

The underlying OS APIs that delete an entry sometimes provide the information
that the entry existed without the need for an additional OS API call to check
existence. E.g. on Windows `DeleteFileW` sets the error to
`ERROR_FILE_NOT_FOUND` if the file did not exist, which can be translated into
a success, but returning `false` from `remove`.

The second version receives the path and a reference to an error code. If the
function fails, instead of throwing it sets the error code. The function is
marked `noexcept`, which in this case means that it will never throw, it will
always return. When the error code was set, the return value is `false`. In
general, for this style of interface, when the error code is set the return
value is the default constructed one (`false` is the default constructed value
for `bool`).

In both cases the input path can be a file or a folder, but the folder must be
empty, otherwise the functions will fail.

It turns out that in our case we want to also be able to remove folders that
are not empty.

There is a pair of functions however that can deal with a folder that is not
empty, in a recursive fashion if necessary.
{% highlight c++ linenos %}
std::uintmax_t remove_all(const std::filesystem::path& p);
std::uintmax_t remove_all(const std::filesystem::path& p, std::error_code& ec);
{% endhighlight %}

The return value is a number the number of entries deleted, zero if the path
did not exist to start with.

The error handling for `remove_all` looks similar to the `remove` functions.
However, notice that the version that receives an error code is not marked as
`noexcept`. It turns out that the failure case has two cases. For most of the
errors it will set the error code. However it can throw `std::bad_alloc` if it
fails to allocate the memory it needs.

**But** if we use `std::filesystem::remove_all` to delete a folder with many
files, if it encounters an error with one file, it stops there without
attempting to delete the remaining ones.

In the case of our application we would like to delete as many files as
possible from the folder because it's easier to diagnose failures if the files
with errors are the only ones left behind.

The bad news is that up to this point we've spent time with functions we can't
use, we've got to write a custom function where we enumerate the contents of
the folder and continue on errors.

