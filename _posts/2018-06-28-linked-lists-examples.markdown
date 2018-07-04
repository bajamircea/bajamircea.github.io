---
layout: post
title: 'Linked Lists - Examples'
categories: coding cpp
---

Example of linked lists types.

# Common notes

All lists allow constant time access to the front, `push_front`, `pop_front`,
insertion and erasure after iterator.

Finding an element by traversing from head to tail takes linear time (and
unlike extent based data structure e.g.  `std::vector`, list traversal is
generally slow because it cannot take advantage of cache prefetching).

# Single linked lists

Single linked lists have a `ForwardIterator`. They might offer constant time
access to the back and `push_back`. They do not offer `pop_back` because it
requires linear list traversal.


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


## Single linked first-last

A single linked linear list with pointers in the header to the first and last
also allows constant time access to the back and `push_back`, by making
different choices: it has a simple iterator, but header is not minimalistic.

![Single linked first-last](/assets/2018-06-28-linked-lists-examples/03-single-first-last.png)


# Double linked lists

Double linked lists have a `BidirectionalIterator`.

They offer constant time access to the back, `push_back`, `pop_back`,and
insertion and erasure before iterator. The latter operations enable splicing
(efficient transfer of node ranges from a list to another).

Some offer a fixed end iterator (one past the last element) for the lifetime of
the list, which simplifies some algorithms.


## Double linked circular

A circular double linked list without a dummy node has a minimalist header, but
a (relatively) complex iterator and no fixed end iterator.

![Double linked circular](/assets/2018-06-28-linked-lists-examples/04-double-circular.png)


## Double linked with allocated dummy node

A circular double linked list with an allocated dummy node has a minimalistic
header and iterator.

![Double linked dummy node](/assets/2018-06-28-linked-lists-examples/05-double-dummy-node.png)

There are however two options with regards to the presence of the dummy node,
neither of which is particularly palatable.

![Double linked dummy node options](/assets/2018-06-28-linked-lists-examples/06-double-dummy-node.png)

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


## Double linked with dummy node in header

A circular double linked list with the dummy node in the header, does not has a
minimalistic header, but has a minimalistic iterator and a fixed end iterator.

![Double linked dummy node in header](/assets/2018-06-28-linked-lists-examples/07-double-dummy-in-header.png)

The downside is that during move operation the pointers from the head and tail
pointing back to the header need to be adjusted.

# Other variations

Variations of the above are possible for:

- intrusive vs. non-intrusive
- cached list size in the header


# References

Alexander A. Stepanov and Paul McJones:<br/>
Elements of Programming

