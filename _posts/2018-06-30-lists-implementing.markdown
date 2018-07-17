---
layout: post
title: 'Linked Lists - Implementing'
categories: coding cpp
---

Commented source code of what it would mean to implement the core of a linked
list in C++.


# Introduction

I have chosen to implement a circular double linked list with the dummy node in
the header:

![Double linked dummy node in header](/assets/2018-06-28-linked-lists-examples/08-double-dummy-in-header.png)

The `dl_list` class below is a template on the sequence type for:
- a double linked list
- circular
- with dummy node in the header
- intrusive
- no custom allocator
- getting size is linear time with number of elements (but slice is constant
  time)

The short name is misleading. To be explicit about all these variations would
have made for a long name.

Another approach could have been a policy-based design. E.g. decisions such as
caching the size or not would have been a choice made via an additional
template parameter. But then still we would have to specify a lot of template
parameters, as there are many choices to be made, leading again to a long
actual name in practice.


# dl_list.h file

{% highlight c++ linenos %}
#pragma once

#include <cstddef> // for size_t and ptrdiff_t
#include <iterator> // for iterator tag and std::reverse_iterator
#include <utility> // for std::move and std::forward

template<typename T>
class dl_list {

  // Nodes consist of links and value
  struct node;

  struct links {
    node * next_;
    node * prev_;
  };

  struct node : public links {
    T value_;

    // Constructor: next, prev, then args for value construction
    template<typename ... Args>
    node(node * next, node * prev, Args && ... args) :
      links{ next, prev }, value_(std::forward<Args>(args)...)
    {}
  };

  // Dummy node only has links.
  // Design decision: the dummy node also deals with ownership, and move to
  // help implement the list.
  struct dummy_node : public links {

    // Helper to look at this as a node
    node * as_node_ptr() {
      return reinterpret_cast<node*>(this);
    }

    // or as a const node
    const node * as_node_ptr() const {
      return reinterpret_cast<const node*>(this);
    }

    // Default constructor, next_ and prev_ point at this.
    dummy_node() noexcept : links{ as_node_ptr(), as_node_ptr() }  {}

    // Free nodes in the destructor
    ~dummy_node() {
      free();
    }

    // No copy
    dummy_node(const dummy_node &) = delete;
    dummy_node & operator= (const dummy_node &) = delete;

    // Implement move constructor
    dummy_node(dummy_node && other) noexcept {
      move_impl(other.as_node_ptr());
    }

    // and move assignment.
    // It turns out they both use a helper function move_impl
    dummy_node & operator= (dummy_node && other) noexcept {
      if (this != &other) {
        free();
        move_impl(other.as_node_ptr());
      }
      return *this;
    }

  // Dummy node helper functions
  private:
    // To free nodes, walk the chain following prev_ and delete the nodes,
    // except this (the dummy_node for this list is part of the header)
    void free() noexcept {
      node * crt = this->prev_;
      while(crt != as_node_ptr()) {
        node * tmp = crt;
        crt = crt->prev_;
        delete tmp;
      }
    }

    // Move helper function. This takes the minimalistic view that the moved
    // from object (other) is in a state that it can be destroyed or assigned
    // to. That state is prev_ pointing to &other (which is also what free
    // tests for ownership).
    void move_impl(node * other) noexcept {
        if (other->prev_ == other) {
          this->next_ = as_node_ptr();
          this->prev_ = as_node_ptr();
        }
        else {
          this->next_ = other->next_;
          this->prev_ = other->prev_;
          this->next_->prev_ = as_node_ptr();
          this->prev_->next_ = as_node_ptr();
          other->prev_ = other;
        }
    }

  };

  // A dummy_node is all that the header is
  dummy_node header_;

public:

  // Iterator
  class iterator {
  public:
    // Type aliases used by algorithms (e.g. iterator_category is used for
    // algorithm selection)
    using iterator_category = std::bidirectional_iterator_tag;
    using difference_type = std::ptrdiff_t;
    using value_type = T;
    using pointer = T *;
    using reference = T &;

  private:
    // has a pointer to a node
    node * ptr_;

    // It has a constructor that the list uses to initialize the pointer to the
    // node
    explicit iterator(node * ptr) : ptr_{ ptr } {};
    // friendship required for the list to access the above constructor
    friend class dl_list;

  public:
    // Default constructor. Needs to initialize pointer to nullptr to ensure
    // equality comparison with other iterator object gives consistent result
    iterator() : ptr_{ nullptr } {};

    // Copy and move are default implemented by the compiler

    // Equality compares node pointer for equality
    friend bool operator== (const iterator & x, const iterator & y) {
      return x.ptr_ == y.ptr_;
    }

    // Difference is negation of equality
    friend bool operator!= (const iterator & x, const iterator & y) {
      return !(x == y);
    }

    // Dereferencing returns the value type
    T & operator* () {
      return ptr_->value_;
    }

    // Increment and decrement, pre and post
    iterator & operator++ () {
      ptr_ = ptr_->next_;
      return *this;
    }

    iterator operator++ (int) {
      node * tmp = ptr_;
      ptr_ = ptr_->next_;
      return iterator(tmp);
    }

    iterator & operator-- () {
      ptr_ = ptr_->prev_;
      return *this;
    }

    iterator operator-- (int) {
      node * tmp = ptr_;
      ptr_ = ptr_->prev_;
      return iterator(tmp);
    }
  };

  // Const iterator
  class const_iterator {
  public:
    // NOTE: The value_type does not have a const. Reason is one can use it
    // like:
    //   std::iterator_traits<I>::value_type x = *it;
    using iterator_category = std::bidirectional_iterator_tag;
    using difference_type = std::ptrdiff_t;
    using value_type = T;
    using pointer = const T *;
    using reference = const T &;

  private:
    // has a pointer to a const node
    const node * ptr_;

    // Same private constructor and friend
    explicit const_iterator(const node * ptr) : ptr_{ ptr } {};
    friend class dl_list;

  public:
    // Default constructor.
    const_iterator() : ptr_{ nullptr } {};

    // Copy and move are default implemented by the compiler

    // Construct from an iterator (not explicit)
    const_iterator(const iterator & x) noexcept : ptr_{ x.ptr_ } {}

    // Equality and difference
    friend bool operator== (const const_iterator & x, const const_iterator & y) {
      return x.ptr_ == y.ptr_;
    }

    friend bool operator!= (const const_iterator & x, const const_iterator & y) {
      return !(x == y);
    }

    // Dereferencing returns the value type
    const T & operator* () {
      return ptr_->value_;
    }

    // Increment and decrement, pre and post
    const_iterator & operator++ () {
      ptr_ = ptr_->next_;
      return *this;
    }

    const_iterator operator++ (int) {
      node * tmp = ptr_;
      ptr_ = ptr_->next_;
      return const_iterator(tmp);
    }

    const_iterator & operator-- () {
      ptr_ = ptr_->prev_;
      return *this;
    }

    const_iterator operator-- (int) {
      node * tmp = ptr_;
      ptr_ = ptr_->prev_;
      return const_iterator(tmp);
    }
  };

  // Type alises
  using value_type = T;
  using reference = T &;
  using const_reference = const T &;
  // using iterator alias not required, see struct iterator above
  // same for const_iterator
  using reverse_iterator = std::reverse_iterator<iterator>;
  using const_reverse_iterator = std::reverse_iterator<const_iterator>;
  using difference_type = std::ptrdiff_t;
  using size_type = std::size_t;

  // Default constructor, nothing to do the dummy_node default constructor does
  // the job
  dl_list() noexcept {
  }

  // Initialize from a sequence. Shoud push_back throw, the dummy_node
  // destructor will free nodes already allocated
  template<typename I, typename S>
  // requires I is InputIterator and S is sentinel for It
  dl_list(I first, S last) {
    while (first != last) {
      push_back(*first);
      ++first;
    }
  }

  // Copy constructor falls back on initializing from sequence
  dl_list(const dl_list & other) : dl_list(other.begin(), other.end()) {
  }

  // Copy assignment makes a copy and moves header
  dl_list & operator= (const dl_list & other) {
    dl_list tmp(other);
    header_ = std::move(tmp.header_);
    return *this;
  }

  // Move constructor and assignment delegate to header
  // defaults do the job
  dl_list(dl_list &&) noexcept = default;
  dl_list & operator= (dl_list &&) noexcept = default;

  // Begin, end, const and reverse variants
  iterator begin() noexcept {
    return iterator(sentinel()->next_);
  }

  const_iterator begin() const noexcept {
    return const_iterator(sentinel()->next_);
  }

  const_iterator cbegin() const noexcept {
    return const_iterator(sentinel()->next_);
  }

  iterator end() noexcept {
    return iterator(sentinel());
  }

  const_iterator end() const noexcept {
    return const_iterator(sentinel());
  }

  const_iterator cend() const noexcept {
    return const_iterator(sentinel());
  }

  reverse_iterator rbegin() noexcept {
    return reverse_iterator(end());
  }

  const_reverse_iterator rbegin() const noexcept {
    return reverse_iterator(end());
  }

  const_reverse_iterator crbegin() const noexcept {
    return reverse_iterator(cend());
  }

  reverse_iterator rend() noexcept {
    return reverse_iterator(begin());
  }

  const_reverse_iterator rend() const noexcept {
    return reverse_iterator(begin());
  }

  const_reverse_iterator crend() const noexcept {
    return reverse_iterator(cbegin());
  }

  // Finally some operations
  void push_back(const T & value) {
    insert_impl(sentinel(), value);
  }

  void push_back(T && value) {
    insert_impl(sentinel(), std::move(value));
  }

private:
  // helper functions
  node * sentinel() {
    return header_.as_node_ptr();
  }

  const node * sentinel() const {
    return header_.as_node_ptr();
  }

  template<typename ... Args>
  void insert_impl(node * where, Args && ... args) {
    node * x = new node(where, where->prev_, std::forward<Args>(args)...);
    where->prev_->next_ = x;
    where->prev_ = x;
  }
};
{% endhighlight %}

# Sample usage

{% highlight c++ linenos %}
#include "dl_list.h"
#include <iostream>

int main() {
  dl_list<int> list;
  list.push_back(42);
  list.push_back(53);

  dl_list<int> another(std::move(list));

  for (const auto & e: another) {
    std::cout << e << '\n';
  }

  for (auto it = another.rbegin(); it != another.rend(); ++it) {
    std::cout << *it << '\n';
  }

  std::cout << "Done!\n";
}
{% endhighlight %}
