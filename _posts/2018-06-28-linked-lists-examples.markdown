---
layout: post
title: 'Linked Lists - Examples'
categories: coding cpp
---

Example of linked lists types.

# Single linked

## Single linked basic

A single linked basic list is linear, with a minimalistic header and iterator.
The end iterator is just a `nullptr` value.

![Single linked basic](/assets/2018-06-28-linked-lists-examples/01-single-basic.png)

It does not offer offer constant time access to the back and `push_back`.

This is a good candidate for a `std::forward_list` implementation. Also it's a
list with minimalistic memory usage (for a linked list).


## Single linked circular

A single linked circular list has a minimalistic header (pointing to the tail),
a (relatively) complex iterator (to differentiate between a past the tail and a
pointer to the head), and two step head access.

![Single linked circular](/assets/2018-06-28-linked-lists-examples/02-single-circular.png)

It allows constant time access to the back and `push_back`.

The iterator needs to know the tail so that iterating past the tail results in
reaching the end as opposed to starting again from the beginning. There are
several options with regards on how the iterator can get the value of the tail.
It can contain the pointer to the tail directly, as shown above, or it can
contain a pointer to the list header and dereference it to get the tail
(indirectly). These choices result in different behaviours when the list has
additional nodes added at the end while enumerating, and also in the number of
operations required to increment an iterator.


## Single linked first-last

A single linked linear list with pointers in the header to the first and last
also allows constant time access to the back and `push_back`, by making
different choices: it has a simple iterator, but header is not minimalistic.

![Single linked first-last](/assets/2018-06-28-linked-lists-examples/03-single-first-last.png)


## Single linked summary

<table>
  <thead>
    <tr>
      <th>Option vs. List type</th>
      <th>Single linked basic</th>
      <th>Single linked circular</th>
      <th>Single linked first-last</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>Single or Double linked</td>
      <td>Single</td>
      <td>Single</td>
      <td>Single</td>
    </tr>
    <tr>
      <td>Linear or Circular</td>
      <td>Linear</td>
      <td>Circular</td>
      <td>Linear</td>
    </tr>
    <tr>
      <td>Minimalistic header</td>
      <td>Yes</td>
      <td>Yes</td>
      <td><strong>No</strong></td>
    </tr>
    <tr>
      <td>Links to local parts</td>
      <td>No</td>
      <td>No</td>
      <td>No</td>
    </tr>
    <tr>
      <td>Dummy node</td>
      <td>No</td>
      <td>No</td>
      <td>No</td>
    </tr>
    <tr>
      <td>Minimalistic iterator</td>
      <td>Yes</td>
      <td><strong>No</strong></td>
      <td>Yes</td>
    </tr>
    <tr>
      <td>Permanent end</td>
      <td>Yes</td>
      <td>Yes</td>
      <td>Yes</td>
    </tr>
    <tr>
      <td>Iterator type</td>
      <td><strong>Forward</strong></td>
      <td><strong>Forward</strong></td>
      <td><strong>Forward</strong></td>
    </tr>
    <tr>
      <td>front, push_front, pop_front, insertion/erasure after</td>
      <td>Yes</td>
      <td>Yes</td>
      <td>Yes</td>
    </tr>
    <tr>
      <td>back, push_back</td>
      <td><strong>No</strong></td>
      <td>Yes</td>
      <td>Yes</td>
    </tr>
    <tr>
      <td>pop_back</td>
      <td><strong>No</strong></td>
      <td><strong>No</strong></td>
      <td><strong>No</strong></td>
    </tr>
    <tr>
      <td>insert/erase at/before</td>
      <td><strong>No</strong></td>
      <td><strong>No</strong></td>
      <td><strong>No</strong></td>
    </tr>
  </tbody>
</table>

Options in **bold** are not the best compared with other list types.

All single lists lack some features compared with some double linked lists.

With regards to constant time `back` and `push_back` the options for single
lists are:

- do not provide
- provide, but trade-off for either a non-minimalistic iterator or a
  non-minimalistic header

# Double linked

## Double linked linear

A double linked linear list with minimalist header and iterator.

![Double linked linear](/assets/2018-06-28-linked-lists-examples/04-double-linear.png)

This is useful for intrusive lists where you retrieve an iterator based on a
reference to the value, and then can remove the node from the list, all while
keeping the rest as simple as possible.


## Double linked first-last

Like the single list first-last the header is not minimalistic, but the
iterator is. An end iterator is a null pointer.

![Double linked first-last](/assets/2018-06-28-linked-lists-examples/09-double-first-last.png)

It allows iterating forwards and backwards, but it does not have a full
bidirectional iterator because once the end is reached we can't go back from
the single null pointer value that represents the end.


## Double linked circular

A circular double linked list without a dummy node has a minimalist header, but
a (relatively) complex iterator and no fixed end iterator.

![Double linked circular](/assets/2018-06-28-linked-lists-examples/05-double-circular.png)

Like the single linked circular, there are two option on how the iterator gets
the value of the tail: directly, as above, or indirectly, through the header.
Each of the two options has similar issues as for the single linked circular
when nodes are added or removed.


## Double linked with allocated dummy node

A circular double linked list with an allocated dummy node has a minimalistic
header and iterator.

![Double linked dummy node](/assets/2018-06-28-linked-lists-examples/06-double-dummy-node.png)

There are however two options with regards to the presence of the dummy node,
neither of which is particularly palatable.

![Double linked dummy node options](/assets/2018-06-28-linked-lists-examples/07-double-dummy-node.png)

- One option (1) is to always ensure the dummy node is present. This means that
  it provides a fixed end iterator, but it leads to a throwing default
  destructor and move constructor. In particular the `std::list` in Visual
  Studio 2017 uses this option, which can be confirmed:

{% highlight c++ linenos %}
#include <list>
#include <type_traits>

static_assert(std::is_nothrow_default_constructible_v<std::list<int>>,
  "Default constructor may throw");
static_assert(std::is_nothrow_move_constructible_v<std::list<int>>,
  "Move constructor may throw");

// The above fails to compile for Option 1 with messages similar to:
// source.cpp: error C2338: Default constructor may throw
// source.cpp: error C2338: Move constructor may throw
{% endhighlight %}

- Another option (2) is to ensure the default destructor and move constructor
  do not throw, but lose a fixed end iterator and a (relatively) more complex
  logic to deal with a potentially missing dummy node.

I find option (1) particularly troubling and not a choice to take with ease:
throwing default and move constructors are highly irregular.

## Double linked with dummy node in header

A circular double linked list with the dummy node in the header, does not has a
minimalistic header, but has a minimalistic iterator and a fixed end iterator.

![Double linked dummy node in header](/assets/2018-06-28-linked-lists-examples/08-double-dummy-in-header.png)

The downside is that during move operation the pointers from the head and tail
pointing back to the header need to be adjusted.


## Double linked summary

<table>
  <thead>
    <tr>
      <th>Option vs. List type</th>
      <th>Double linked linear</th>
      <th>Double linked first-last</th>
      <th>Double linked circular</th>
      <th>Double linked allocated dummy node</th>
      <th>Double linked dummy node in header</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>Single or Double linked</td>
      <td><strong>Double</strong></td>
      <td><strong>Double</strong></td>
      <td><strong>Double</strong></td>
      <td><strong>Double</strong></td>
      <td><strong>Double</strong></td>
    </tr>
    <tr>
      <td>Linear or Circular</td>
      <td>Linear</td>
      <td>Linear</td>
      <td>Circular</td>
      <td>Circular</td>
      <td>Circular</td>
    </tr>
    <tr>
      <td>Minimalistic header</td>
      <td>Yes</td>
      <td><strong>No</strong></td>
      <td>Yes</td>
      <td>Yes</td>
      <td><strong>No</strong></td>
    </tr>
    <tr>
      <td>Links to local parts</td>
      <td>No</td>
      <td>No</td>
      <td>No</td>
      <td>No</td>
      <td><strong>Yes</strong></td>
    </tr>
    <tr>
      <td>Dummy node</td>
      <td>No</td>
      <td>No</td>
      <td>No</td>
      <td><strong>Yes</strong></td>
      <td>in header</td>
    </tr>
    <tr>
      <td>Minimalistic iterator</td>
      <td>Yes</td>
      <td>Yes</td>
      <td><strong>No</strong></td>
      <td>Yes</td>
      <td>Yes</td>
    </tr>
    <tr>
      <td>Permanent end</td>
      <td>Yes</td>
      <td>Yes</td>
      <td><strong>No</strong> / Yes (2)</td>
      <td><strong>No</strong> / Yes (3)</td>
      <td>Yes</td>
    </tr>
    <tr>
      <td>Iterator type</td>
      <td><strong>Forward</strong></td>
      <td><strong>Forward and Backward</strong> (1)</td>
      <td>Bidirectional</td>
      <td>Bidirectional</td>
      <td>Bidirectional</td>
    </tr>
    <tr>
      <td>front, push_front, pop_front, insertion/erasure after</td>
      <td>Yes</td>
      <td>Yes</td>
      <td>Yes</td>
      <td>Yes</td>
      <td>Yes</td>
    </tr>
    <tr>
      <td>back, push_back</td>
      <td><strong>No</strong></td>
      <td>Yes</td>
      <td>Yes</td>
      <td>Yes</td>
      <td>Yes</td>
    </tr>
    <tr>
      <td>pop_back</td>
      <td><strong>No</strong></td>
      <td>Yes</td>
      <td>Yes</td>
      <td>Yes</td>
      <td>Yes</td>
    </tr>
    <tr>
      <td>insert/erase at/before</td>
      <td>Yes</td>
      <td>Yes</td>
      <td>Yes</td>
      <td>Yes</td>
      <td>Yes</td>
    </tr>
    <tr>
      <td>Throwing default/move</td>
      <td>No</td>
      <td>No</td>
      <td>No</td>
      <td>No / <strong>Yes</strong> (3)</td>
      <td>No</td>
    </tr>
  </tbody>
</table>

Options in **bold** are not the best compared with other list types.

(1) For double linked first-last once the end is reached we can’t go back from
the single null pointer value that represents the end, therefore not
bidirectional.

(2) Double linked circular can make a choice on the iterator storing:

- a direct pointer to the tail (end not permanent)
- a pointer to the header, access the tail via the header (end permanent)

(3) Double linked with allocated dummy node need to make choose between:

- No permanent end
- Or throwing default and move constructors

Double linked nodes are larger by one pointer size to the single linked ones,
but they provide insert and erase before iterator.

Double linked with dummy node in header is a good choice overall. Note that
although it uses additional space for the dummy node, we already counted this
as a downside for the non-minimalistic header.


# Other variations

Variations of the above are possible for:

- cached list size in the header
- allocator/ownership
- intrusive vs. non-intrusive


# References

Alexander A. Stepanov and Paul McJones:<br/>
Elements of Programming

