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

Linked lists are data structures that are implemented as a chain of nodes where
each node stores a value and one or more pointers to adjacent nodes.

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
to the `prev` member of the node, but that more accurate diagram would have
made for a more difficult read.


# Linear vs. Circular

There are two choices for the `next` pointer of the tail node (and for the
`prev` pointer for the head node).

It can be `nullptr`, not pointing to another node. In this case the list is
linear.

![Linear](/assets/2018-06-23-linked-lists-options/03-linear.png)

Or it can close the loop pointing to the node at the other end of the chain. In
this case the list is circular.

![Circular](/assets/2018-06-23-linked-lists-options/04-circular.png)


# Header - size

The list itself needs the means to access the chain of nodes.

A minimalistic header can have just one pointer. That's useful for large number
of lists, many of which are empty.

For a linear list the header needs to contain a pointer to the head.

![Header to head](/assets/2018-06-23-linked-lists-options/05-header-head.png)

For a single linked circular list the header should have a pointer to the tail.
This way the head can also be accessed in 2 steps (regardless of the length of
the list).

![Header to tail](/assets/2018-06-23-linked-lists-options/06-header-tail.png)

Alternatively the header can be larger than just a pointer.


# Dummy node

For circular lists there is the option to introduce a dummy node
that does not need to contain a value (e.g. it's `reinterpret_cast`ed to a
node), between the node for the front (the node of the first value) and the
back (the node for the last value).

![Dummy node](/assets/2018-06-23-linked-lists-options/07-dummy-node.png)

The dummy node for an empty list would have `next` and `prev` pointing to
itself.

# Dummy node - location

If the dummy node is allocated on the heap there are two choices:

- ensure that list always have a dummy node, which leads to a potentially
  throwing default constructor and move constructor
- or introduce a special state, when default constructed or moved from, where
  there is no dummy node

Alternatively the dummy node can be part of the header.

# List size

The list can store its size and adjust it when values get inserted or removed.

Or it can dispense with storing it and do a traversal to count the number of
values in the list.


# Intrusive vs. non-intrusive.

For non-intrusive lists the user of the list does not care about the layout of
the node. They are easier to use.

For intrusive lists the user of the list provides the layout of the node. They
are more difficult to use but have the advantage that one can get the pointer
to the node from a reference to the value, and that a value can be linked into
multiple lists.


# Ownership and allocators

A variety of options can be made for how the nodes are allocated and if the
user of the list owns the nodes directly or indirectly (through the list).


# Iterators

The iterators for a list can be simply a pointer to a node.

Or they can be larger e.g. to allow for either a minimalistic header or a back
insert operation.


# Meaning of pointers in the node

Most lists have fixed meaning for the pointers in the node (e.g. first is
`next`, second is `prev`).

Fast reverse of double linked lists can be achieved at additional cost
elsewhere e.g. if the meaning of `next` and `prev` is fixed just for the entry
point in the list (e.g. the dummy node) while for the rest of the nodes is
deduced.

![Fast reversal](/assets/2018-06-23-linked-lists-options/08-fast-reversal.png)


# References

Alexander A. Stepanov and Paul McJones:<br/>
Elements of Programming

Robert Endre Tarjan:<br/>
Data Structures and Network Algorithms

