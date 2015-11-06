---
layout: post
title: 'C++ class taxonomy'
categories: coding cpp
---

WORK IN PROGRESS.
Following the idea if descibing and cataloguing organisms in biology, let's
have a look at various types of C++ classes.


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


## 1.2 Data struct


### 1.2.1 Grouping struct

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


### 1.2.2 C-compatible struct

Sometimes `struct`s are required for interoperability with C.

{% highlight c++ linenos %}
struct some_struct
{
  int id;
  char * value;
};
{% endhighlight %}


## 1.3 RAII class

### 1.3.1 Classic RAII class

A [classic RAII class][classic-raii]  wraps a private resource handle, it's not movable or
copyable and implements the methods that use the resource handle. The
constructor initializes the handle or throws on failure. The destructor cleans
up.

{% highlight c++ linenos %}
// in header
class classic_raii :
  private non_copyable
{
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

### 1.3.2 Slim RAII class

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

### 1.3.3 Fat RAII class

As your classic RAII class gets more usage and matures, you might [end up
adding more features][fat-raii] like move operators, functions that create such
objects (e.g.  see `make_shared`), allow some access to the private member
variable(s).

## 1.4 Doer classes

### 1.4.1 Processing class

A processing class is not as much focused on the data it holds, as it is on
what it does. The reason you might want a class instead of a function would be
for example to capture some information in the construction.

{% highlight c++ linenos %}
class data_access_layer :
  private non_copyable
{
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

    - class factory
      - it's point is to create instances of a class
      - template
      - function
    - base class

# 2 Interface hiding
    - pimpl class
    - interface class
      - declaration
      - implementation
    - partial type erasure
      - e.g. think std::function or std::shared_ptr
    - base class with virtual methods

# 3 Surrealist creatures
    - behaviour base class
      - e.g. boost/non_copyable (no member variables)
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

    - not a class :)
      - function: think the algorithm library
      - fundamental type: e.g. const char *

[struct-classes]:  {% post_url 2015-03-31-struct-classes %}
[classic-raii]:    {% post_url 2015-03-17-classic-raii %}
[slim-raii]:       {% post_url 2015-03-22-slim-raii %}
[fat-raii]:        {% post_url 2015-03-23-fat-raii %}

