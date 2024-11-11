---
layout: post
title: 'Remove a folder - registry enumeration digression'
categories: coding cpp
---

How hard can it be to remove a folder in Windows? Part 2 supplement: registry
enumeration digression


For example, the function to enumerate the values of a registry key on Windows
looks like:
{% highlight c++ linenos %}
// dwIndex should be 0 (zero) for the first call of the enumeration,
// incremented for the following calls
// (assuming the previous call returned ERROR_SUCCESS).
// ERROR_NO_MORE_ITEMS is returned when the enumeration completed.
LSTATUS RegEnumValueW(..., DWORD dwIndex, ...);
{% endhighlight %}

One can infer several things by just reasoning about the `RegEnumValueW`
function declaration. Because it does not use a handle to capture results, it
must be that the implementation stores the registry values ordered in a data
structure accessed using the index provided AND the order of registry values in
that data structure does not change if data for a registry value is read or
written between calls to `RegEnumValuesW`.

Deleting a registry value as we enumerate could be risky however because it can
change the order. E.g. if we delete the entry at index `0`, then another entry
will be moved at index `0`, we can't increment the index to `1` and assume that
the old (deleted) entry is still at index `0`. There is the valid case though
where to delete all values we could enumerate at index `0` only and delete it,
repeating until the enumeration for index `0` (without incrementing it to `1`)
returns `ERROR_NO_MORE_ITEMS`.

But notice that using 'capture' with `RegEnumValueW` (where we enumerate and
the use/manipulate) is not entirely without issues either (on top of using
additional memory). This is because if another process/thread creates or
deletes registry values as the enumeration progresses, then entries will be
skipped, duplicates can occur, enumerated values can disappear before being
handled.

For a concrete example let's assume that there are 10 values, which an
enumeration should retrieve using an index 0 to 9. Let's assume that the
enumeration reaches the value at index 5 and is about to move to the one at
index 6. If another process removes the value that used to be at index 3, the
entries will be reordered. Let's assume the less problem causing reordering
strategy: for entries greater than 3 the index becomes one smaller. When the
enumeration reaches for value at index 6, it will get what used to be at index
7, and the enumeration will stop at index 8.  In this case we **missed the
value** that originally was at index 6, **which had nothing to do with the
value deleted**.

Do the `Find...` API suffer of the same problem? Probably not, the fact that
they return a handle allows them to capture the progress of the enumeration in
the handle.
