---
layout: post
title: 'Remove a folder - enumerate'
categories: coding cpp
---

How hard can it be to remove a folder in Windows? Part 2: enumerate while
deleting


We've decided that we can't use `std::filesystem::remove_all` and we'll write a
custom function. That requires to enumerate entries recursively and delete
files and empty folders.


# Folder enumeration APIs

`std::filesystem::recursive_directory_iterator` does not specify the order in
which it will enumerate the entries. We can't use it because for our purpose we
need to enumerate children before their parents.

`std::filesystem::directory_iterator` can be used to iterate through the
entries in a folder:
- Constructing with a path gives a begin iterator. This probably maps to
  `FindFirstFileExW` on Windows. `FindFirstFileW` returns a `HANDLE` which is
  probably stored by `std::filesystem::directory_iterator`
- Incrementing advances the iterator. This probably maps to `FindNextFileW` on
  Windows. `FindNextFileW` receives the handle value and it uses it to store
  information on how far the iteration progressed.
- A default constructed `std::filesystem::directory_iterator` serves as an end
  iterator
- The destructor of `std::filesystem::directory_iterator` probably calls
  `FindClose`. This frees the memory used to store how far the iteration
  progressed.


First of all an error handling digression. The underlying Windows functions,
`FindFirstFileExW` and `FindNextFileW`, can fail. That leads to two variations
for constructing and incrementing.

These versions throw on error:
{% highlight c++ linenos %}
// declarations
explicit directory_iterator(const std::filesystem::path& p);
directory_iterator& operator++();

// sample usage
for (auto it = std::directory_iterator(folder);
     it != std::directory_iterator();
     ++it)
{
  // handle value
}
{% endhighlight %}

There are versions that take and `error_code` as an argument. Note that in
these versions, when an error happens, the constructor still constructs an
object (probably the same as the default constructor). Also notice that the
`operator++` can't be used, we have an `increment` function instead which
impacts the way the loop, which is used to enumerate, needs to be written:
{% highlight c++ linenos %}
// declarations
directory_iterator(const std::filesystem::path& p, std::error_code& ec);
directory_iterator& increment(std::error_code& ec);

// sample usage
auto it = std::directory_iterator(folder, ec);
if (ec)
{
  // handle error e.g. log, return early
}
while (it != std::directory_iterator())
{
  // handle value

  it.increment(ec);
  if (ec)
  {
    // handle error e.g. log, return early
  }
}
{% endhighlight %}


# Enumerating and deleting

Deleting entries as we enumerate through a collection is a common source of
errors because we need to consider how deleting entries impacts the enumeration.
E.g. if we delete an entry does it somehow invalidate the enumeration or are
there unintuitive behaviours?

In this article we'll look at the enumeration problem in a more general manner.

There are several approaches when enumerating. We'll discuss the following:

1. Sometimes there are guarantees that deleting does not impact enumeration.
2. Enumerate to capture the entries, then iterate through the captured entries
and delete.
3. Use enumeration to get the first entry, delete that one, repeat until there
is no more entries.


## Rely on guarantees

Some data structures or APIs provide guarantees. The guarantees might have
limitations.

By 'rely on guarantees' I mean 'rely on guarantees that are provided', not
'blindly assume that such guarantees exist'.

For example when traversing a double list it's safe to delete an entry
preceding the current iterator, but not the entry pointed by the current
iterator.

Another example is the erase-remove idiom, e.g. applied to a `std::vector`. The
user does not explicitly enumerates, but the point is that the idiom carefully
works with the guarantees of the data structure to delete entries while
avoiding unnecessary copying of data.

So the question is: are we guaranteed by the filesystem APIs that we can
enumerate and delete the returned entry before continuing the enumeration?
{% highlight c++ linenos %}
for (auto it = std::directory_iterator(folder);
     it != std::directory_iterator();
     ++it)
{
  // delete file (or folder) at it->path()
}
{% endhighlight %}

Neither the `std::filesystem` documentation, nor MSDN with regards to the
`Find...` APIs, are absolutely clear on what the guarantees are. An educated
guess is that **probably** it is an acceptable usage scenario in this case.
Most of the time I'd like clearer guarantees documented. The fact that the
`Find...` APIs use a handle to store enumeration progress is **necessary, but
not sufficient** for the assumption we're making here.

Note that if another process/thread deletes a file in the meantime, it's
possible that the enumeration will return the name of a file that's already
deleted. Similarly if another process/thread creates a file in the meantime,
it's possible that the folder is not empty despite removing all the files
returned by the enumeration.


## Capture entry names, then delete

This approach will use more memory to store data before deletion. The amount
of memory used depends on the number of files in a folder. Not detailed here is
the issue of recursion which uses stack memory proportional with the depth of
sub-folders.
{% highlight c++ linenos %}
std::vector<std::path> paths;

for (auto it = std::directory_iterator(folder);
     it != std::directory_iterator();
     ++it)
{
  paths.push_back(it->path());
}

for (const auto & path : paths)
{
  // delete file (or folder) at path
}
{% endhighlight %}


For some enumeration APIs this 'capture then delete' approach might be required
because of lack of guarantees from the API.


## Enumerate just one, delete, repeat

This approach uses the enumeration to retrieve just the first entry, delete it,
then repeat.

{% highlight c++ linenos %}
while (true)
{
  auto it = std::directory_iterator(folder);
  if (it == std::directory_iterator())
  {
    break;
  }
  // delete file (or folder) at it->path()
}
{% endhighlight %}

It has the advantage to eliminate the questions about the available guarantees
and memory usage. For reference the current Microsoft implementation of
`remove_all` uses this approach, it's not a terribly bad idea.

The disadvantage is that it has to stop at the first error.

Therefore it's clear we can't use it in our case where we would like to delete
as much as possible so that files left behind are only the ones with errors,
making troubleshooting easier (note that in this case the troubleshooting is
usually not performed by the code writer, but by the user of the program).
