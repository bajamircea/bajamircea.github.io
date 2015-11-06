---
layout: post
title: 'C++ class taxonomy'
categories: coding cpp
---

Following the idea of describing and cataloguing organisms in biology, let's
have a look at various types of C++ classes. There's a whole zoo out there.


# 1 Traditional classes


## 1.1 Classic class

The classic traditional class exposes public methods that use/manipulate
private member variables which might preserve some invariants.

{% highlight c++ linenos %}
class standard_class
{
public:
  void some_method();
  ...

private:
  some_type var_;
  ...
};
{% endhighlight %}


## 1.2 RAII class

### 1.2.1 Classic RAII class

A [classic RAII class][classic-raii]  wraps a private resource handle, it's not movable or
copyable and implements the methods that use the resource handle. The
constructor initializes the handle or throws on failure. The destructor cleans
up.

{% highlight c++ linenos %}
// in header
class classic_raii :
  private non_copyable
{
public:
  classic_raii();
  ~classic_raii();

  void some_method();
  
private:
  handle * h_;
};

// in cpp
classic_raii::classic_raii() {
  h_ = ::create_handle();
  if (! h_) {
    throw std::runtime_error("create_handle failed");
  }
}

classic_raii::~classic_raii() {
  ::close_handle(h_);
}

void classic_raii::some_method() {
  if (! ::use_handle(h_)) {
    throw std::runtime_error("use_handle failed");
  }
}
{% endhighlight %}

### 1.2.2 Slim RAII class

[Slim RAII classes][slim-raii] is a thinner wrapper of a resource, allowing a
user direct, intrusive access to the wrapped handle. The role of the class is
to help ensure resources are released when it is destroyed.

{% highlight c++ linenos %}
struct slim_raii :
  private non_copyable
{
  slim_raii(handle * h) : h_{ h } {}

  ~slim_raii() {
    if (h_) {
      ::close_handle(h_);
    }
  }

  handle * h_;
};
{% endhighlight %}

### 1.2.3 Fat RAII class

As your classic RAII class gets more usage and matures, you might [end up
adding more features][fat-raii] like move operators, functions that create such
objects (e.g.  see `make_shared`), allow some access to the private member
variable(s).


## 1.3 Data struct

These focus on the data part of the class.

### 1.3.1 Grouping struct

A grouping [struct or class][struct-classes] is used to groups several pieces
of data together. It will have no or few member functions and can dispense with
constructors using member variable initialization.

{% highlight c++ linenos %}
struct some_struct
{
  std::string name{"default"};
  std::string description;
  int counter {};
  bool is_default{ true };
};
{% endhighlight %}


### 1.3.2 C-compatible struct

Sometimes `struct`s are required for interoperability with C.

{% highlight c++ linenos %}
struct some_struct
{
  int id;
  char * value;
};
{% endhighlight %}


## 1.4 Doer classes

These focus on what the class does, rather than on the data.

### 1.4.1 Processing class

A processing class is not as much focused on the data it holds, as it is on
what it does. The reason you might want a class instead of a function would be
for example to capture some information in the construction.

{% highlight c++ linenos %}
class data_access_layer :
  private non_copyable
{
public:
  data_access_layer(connection & cnx);

  void insert(int id, int value);
  bool exists(int id);
  ...

private:
  connection & cnx_;
};
{% endhighlight %}

### 1.4.2 Function object

As you refine the classes that do stuff, you reach to have generic algoritms
that traditionally use the function operator.

{% highlight c++ linenos %}
class between_inclusive
{
public:
  between_inclusive(int lower, int upper) :
    lower_{ lower }, upper_{ upper }

  bool operator()(int value) {
    return (lower_ <= value) && (value <= higher_);
  }

private:
  int lower_;
  int upper_;
};
{% endhighlight %}

the above is equivalent to a lambda

{% highlight c++ linenos %}
[=lower, =upper](int value) {
  return (lower <= value) && (value <= higher);
}
{% endhighlight %}


## 1.5 Builder/injector class

The purpose of the class is to [manage the lifetime][class-lifetime] of the
member variables and potentially link them together. The order of declaration
of the member variables matters: it's the order they will be created.

{% highlight c++ linenos %}
class house
{
public:
  house() :
    d_{},
    k_{ d_ },
    l_r{ d_ }
  {
  }
  ...
private:
  door d_;
  kitchen k_;
  living_room l_r_;
};
{% endhighlight %}


# 2 Interface hiding

## 2.1 Interface

A interface class defines a table of functions (vtable) to implement by a
derived class. The interface definition are all pure virtual functions. The
issue of a user deleting a pointer to a interface is solved by either a
protected destructor to disalow it:

{% highlight c++ linenos %}
struct itf
{
  virtual void some_fn() = 0;
  virtual int some_fn2() = 0;
protected:
  ~itf() {};
};
{% endhighlight %}

or by using a public virtual destructor:

{% highlight c++ linenos %}
struct itf
{
  virtual void some_fn() = 0;
  virtual int some_fn2() = 0;
  virtual ~itf() {};
};
{% endhighlight %}

you would then have a derived class implementing the interface:

{% highlight c++ linenos %}
class derived :
  public itf
{
public:
  void some_fn() override
  {
    // do stuff here
  }
  int some_fn2() override
  {
    // more stuff here
  }
};
{% endhighlight %}

## 2.2 Base class with virtual methods

That would be when a base class implements some functionality and calls into
virtual functions to give the derived class a chance to customize behaviour.
The problem with this is that it ties the base and derived class too much
together.

{% highlight c++ linenos %}
class impl
{
public:
  void some_fn()
  {
    // call some_fn2()
  }
  virtual int some_fn2() = 0;
  vritual ~itf() {};
};
{% endhighlight %}


## 2.3 Partial type erasure

Think `std::function`. The original function could have been a function object,
a lambda, a function pointer. The original type is not all lost (that would
have been a `void` pointer), `std::function` erases the original type, but
retains the arguments and return value. In practice it's implemented with
virtual tables.


## 2.4 Pimpl idiom

{% highlight c++ linenos %}
// in the header
class some_class
{
public:
  some_class();
  ~some_class();

  void some_fn();
private:
  class impl;
  std::unique_ptr<impl> pimpl_;
};

// in the cpp
class some_class::impl
{
  void some_fn()
  {
    // actual implementation;
  }
};

some_clas::ssome_class() :
  pimpl_{ std::make_unique<impl>() }
{}

some_clas::s~some_class()
{}

void some_class::some_fn()
{
  pimpl_->some_fn();
}

// in another cpp
// (does not see some_class::impl definition)
  ...
  some_class x;
  x.some_fn();
  ...
{% endhighlight %}

# 3 Surrealist creatures

## 3.1 Behaviour base class

These are base classes with no data (not even a virtual destructor/table) e.g.
`boost::noncopyable`.

    - template value calculator
      - factorial -> use constexpr
      - e.g. std::size() for arrays
    - trait
      - type trait
    - tag
    - thread
      - threads can't be implemented as a library
      - destructor terminates process if not stopped
     - mutex

## Curiously recurring template classes

This involves a derived class and a template base class, that allows the base
class to access members of the derived class.

{% highlight c++ linenos %}
template <class T>
class base
{
  // access derived from here
};

class derived :
  public base<derived>
{
};
{% endhighlight %}

# 4 Ceci n'est pas une pipe

Well, not everything has to be a class. Think the STL algorithms, think
fundamental types.

[struct-classes]:  {% post_url 2015-03-31-struct-classes %}
[classic-raii]:    {% post_url 2015-03-17-classic-raii %}
[slim-raii]:       {% post_url 2015-03-22-slim-raii %}
[fat-raii]:        {% post_url 2015-03-23-fat-raii %}
[class-lifetime]:  {% post_url 2015-04-02-class-lifetime %}
