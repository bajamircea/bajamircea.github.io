---
layout: post
title: 'Linked Lists - Implementation Options'
categories: coding cpp
---

Catalogue of variations and implementation choices for linked lists.


# Introduction

Alex Stepanov mentions at some point that `std::vector` is just a kind of
vector, there are many kinds of vector. It turns out that `std::list` is also
just a kind of linked list, the are many kinds of linked lists.

Linked lists are dynamic-size data structures that are implemented as a chain
of nodes. Each node stores a value and one or two pointers to adjacent nodes.

A list has a header (consisting of the local parts, at fixed offsets from the
list object address) and the chain of nodes (the remote parts). The chain is
accessed through at least one pointer in the header.

Like extent based data structures e.g. `std::vector`, linked lists expose a
sequence of values. The differences are in terms of trade-offs for the cost of
operations. Linked lists take advantage of the fixed locations of the nodes and
the option to re-link pointers of existing nodes. Extent based data structures
take advantage of processor/hardware pre-caching for sequential access. That's
why `std::vector` out-performs lists for most common scenarios.

Most of the list logic does not depend on the value, that's why the
implementation is usually generic e.g. a template parametrised by the type of
the value.

There are several design choices that lead to different kinds of linked lists.


# Single linked vs. Double linked

Single linked lists have a pointer to the next node.

![Single linked](/assets/2018-06-23-linked-lists-options/01-single-linked.png)

Double linked lists have an additional pointer to the previous node.

![Double linked](/assets/2018-06-23-linked-lists-options/02-double-linked.png)

NOTE: In the diagram above the `prev` pointers would really point to node, not
to the `prev` member of the node, but that more precise diagram would have
made for a more difficult read.


# Linear vs. Circular

There are two choices for the `next` pointer of the tail node.

It can be `nullptr`, not pointing to another node. In this case the list is
linear.

![Linear](/assets/2018-06-23-linked-lists-options/03-linear.png)

Or it can close the loop pointing to the node at the other end of the chain. In
this case the list is circular.

![Circular](/assets/2018-06-23-linked-lists-options/04-circular.png)

Double linked lists have the same choice for the `prev` pointer for the head
node. A double linked list is either linear for both chains or circular for
both chains.


# Header - minimalistic

A minimalistic header can have just one pointer. That's useful for large number
of lists, many of which are empty.

The minimalistic header can have a pointer to the head (e.g. a linear single
linked list).

![Header to head](/assets/2018-06-23-linked-lists-options/05-header-head.png)

Or the minimalistic header can have a pointer to the tail, This can work for
circular lists, by providing access to the head as well in a constant number of
steps regardless of the length of the list.

![Header to tail](/assets/2018-06-23-linked-lists-options/06-header-tail.png)

Alternatively the header can be larger than just a pointer.


# List size

The list can store its size in the header and adjust it when values get
inserted or removed.

Or it can dispense with storing it and do a traversal to count the number of
values in the list.


# Links from remote parts to local parts

One option is to only have links from the header (the local parts) to the nodes
(the remote parts), but no links from the nodes (the remote parts) back to the
header.

The other option is to allow links from the nodes (the remote parts) back to
the header (the local parts). This makes some operations a bit more complex
(e.g.  move constructor and assignment need to also adjust the relevant
pointers to point to the new header).


# Dummy node

For circular lists there is the option to introduce a dummy node that does not
need to contain a value (e.g. it's `reinterpret_cast`ed to a node), between the
node for the front (the node of the first value) and the back (the node for the
last value).

![Dummy node](/assets/2018-06-23-linked-lists-options/07-dummy-node.png)

The dummy node for an empty list would have `next` and `prev` pointing to
itself.


# Dummy node - location

If the dummy node is allocated on the heap there are two choices:

- ensure that list always have a dummy node, which leads to a potentially
  throwing default constructor and move constructor
- or introduce a special state, when default constructed or moved from, where
  there is no dummy node

Alternatively the dummy node can be part of the header. This creates links from
remote parts to local parts.


# Iterators - minimalistic

A minimalistic list iterator can be simply a pointer to a node with simple
logic to advance by one position by following `next` (or `prev`).

Or they can be larger (for advantages elsewhere).


# Permanent end iterator

The end iterator is one past the back. A permanent end iterator does not get
invalidated as nodes get inserted or removed.

NOTE: Examples of permanent end iterator:
- a pointer to a dummy node
- a `nullptr` in a minimalistic iterator
- a non-minimalistic iterator containing a pointer to the header


# ForwardIterator vs BidirectionalIterator

All list iterators are at least `ForwardIterator`.

Double linked lists iterators can be `BidirectionalIterator`. That is trivial
to achieve when the iterator points to a node, but might require trade-offs
elsewhere to reverse from the end iterator (e.g. an end iterator that is just a
`nullptr` pointer is not reversible rendering the whole iterator type
`ForwardIterator`).


# Allocators

A variety of options can be made for how the nodes are allocated.


# Intrusive vs. non-intrusive.

For non-intrusive lists the user of the list does not care about the layout of
the node. They are easier to use.

For intrusive lists the user of the list provides the layout of the node. They
are more difficult to use but have the advantage a value can be linked into
multiple lists (or even other data structures).


# Getting an iterator from a reference to a value

One possible facility is to provide a mean to get an iterator from a reference
to a value. This is usually the case for intrusive lists, but can be provided
for non-intrusive lists as well.

# Node ownership

If the list owns the nodes, they get deleted when the list gets destroyed.

The other option is that the list does not own the nodes. This is usually the
case with intrusive lists, in particular when a node is part of more than a
list, at most one list can own the nodes.


# Operations available

All lists provide:
- constant time access to the front (the first value)
- constant time `push_front`
- constant time `pop_front`
- constant time insertion and erasure after iterator (i.e. other than the end iterator)

Typical optional operations are:
- constant time access to the back (the last value)
- constant time `push_back`
- constant time `pop_back`
- constant time insertion and erasure before (and at) iterator
- some form of constant time transfer of nodes to another list (splicing)

NOTE: splicing a range (transfer a range of nodes to another list) is constant
time if the size is not cached in the header, but linear time with the number
of nodes transferred (to calculate the count of nodes transferred in order to
update the cached size).


# Meaning of pointers in the node

Most lists have fixed meaning for the pointers in the node (e.g. first is
`next`, second is `prev`).

Fast reverse of double linked lists can be achieved if the meaning of `next`
and `prev` is fixed just for the entry point in the list (e.g. the dummy node)
while for the rest of the nodes it is deduced. This obviously has additional cost
for other operations.

![Fast reversal](/assets/2018-06-23-linked-lists-options/08-fast-reversal.png)


# Conclusion

The linked lists are one of the simplest data structures, and yet there is a
large number of design options; some are totally independent, some are
trade-offs.


# References

Alexander A. Stepanov and Paul McJones:<br/>
Elements of Programming

Robert Endre Tarjan:<br/>
Data Structures and Network Algorithms

