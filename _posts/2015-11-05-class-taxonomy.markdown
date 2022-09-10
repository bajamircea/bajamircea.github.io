---
layout: post
title: 'C++ Class Taxonomy'
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
  slim_raii(handle * h) noexcept : h_{ h } {}

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


### 1.2.4 Fit RAII class

For an industrial approach to wrapping C API handles, usable in a wide range of
scenarios, using a template, similar to `std::unique_ptr`, but allowing direct
access to the underlying handle see [the fit RAII approach][fit-raii].


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

As you refine the classes that do stuff, there are some that do only one very
specific thing. You use the function operator for that thing rather than a
named function. The syntax is a bit weirder compared with a plain doer class
function, but you might use such classes as arguments in generic algoritms.

{% highlight c++ linenos %}
class between_inclusive
{
public:
  between_inclusive(int lower, int upper) :
    lower_{ lower }, upper_{ upper }
  {
  }

  bool operator()(int value) {
    return (lower_ <= value) && (value <= upper_);
  }

private:
  int lower_;
  int upper_;
};
{% endhighlight %}

the above is equivalent to a lambda

{% highlight c++ linenos %}
[=lower, =upper](int value) {
  return (lower <= value) && (value <= upper);
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
    l_r_{ d_ }
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
*Usually an anti-pattern.* The problem with this is that it ties the base and
derived class too much together.

{% highlight c++ linenos %}
class base_with_impl
{
public:
  void method_impl_in_base_class()
  {
    // some implementation that also
    // calls method_impl_in_derived_class()
  }
  virtual int method_impl_in_derived_class() = 0;
  vritual ~itf() {};
};

class derived:
  public base_with_impl
{
public:
  int method_impl_in_derived_class() override
  {
    // some implementation
  }
};
{% endhighlight %}


## 2.3 Partial type erasure

Think `std::function`. The original function could have been a function object,
a lambda, a function pointer. The original type is not all lost (that would
have been a `void` pointer), `std::function` erases the original type, but
retains the arguments and return value. In practice it's implemented with
virtual tables.


## 2.4 Pimpl idiom

Pimpl is used to hide implementation details from the user of a class at
compile time. A class stores a pointer to the class that actually implements
the functionality. E.g. this is useful if the implementation includes a
large/complex header: the user of the class avoids also including that
large/complex header. This comes with some runtime costs, e.g.  additional heap
allocation.

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

some_class::some_class() :
  pimpl_{ std::make_unique<impl>() }
{}

some_class::~some_class()
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

Note that Pimpl is one of the cases where forward declaration (of the
implementation class in this case) makes sense.

Also empty destructors are not needed in general, but in this case ensures that
the user does not try to generate the code for the destructor (it cannot
because it does not have visibility of the layout and destructor of the
implementation class) and it resolves it at the linking stage instead.

# 3 Modern creatures


## 3.1 Behaviour base class

These are base classes with no data (not even a virtual destructor/table) e.g.
`boost::noncopyable`.


## 3.2 Compile time value calculator

See the factorial calculator below. Over time `constexpr` will reduce this type
of usage.

{% highlight c++ linenos %}
template <unsigned int n>
struct factorial :
  std::integral_constant<
    unsigned int,
    n * factorial<n-1>::value
  >
{
};

template <>
struct factorial<0> :
  std::integral_constant<unsigned int,1>
{
};

...
  std::cout << factorial<3>::value << std::endl;
...
{% endhighlight %}


## 3.3 Traits


### 3.3.1 Plain trait

Traits are classes that associate information to a type.

{% highlight c++ linenos %}
template<class Path>
struct path_trait { };

template<>
struct path_trait<unix_path>
{
  using path_type = unix_path;
  using char_type = char;
  static constexpr char_type separator = '/';
  bool is_absolute_path(const path_type & x) {
    ...
  }
};

template<>
struct path_trait<windows_path>
{
  using path_type = windows_path;
  using char_type = wchar_t;
  static constexpr char_type separator = L'\\';
  bool is_absolute_path(const path_type & x) {
    ...
  }
};

// sample usage
template<class Path>
Path combine(const Path & base, const Path & last) {
  return base + path_trait<Path>::separator + last;
}
{% endhighlight %}


### 3.3.2 Type trait

Is a trait reduced to a boolean that says if a type has a certain
characteristic. See the `is_...` functions in the standard `<type_traits>`
header.


### 3.3.3 Tag

Is a trait component reduced to the simple fact that it is a certain type. Used
to dispatch implementation depending on the tag class, to get around the issues
with function specialization not overloading.

{% highlight c++ linenos %}
struct unix_tag { };

template<class Path>
struct path_trait { };

template<>
struct path_trait<unix_path> {
  using tag = unix_tag;
};

template<class Path>
Path combine_impl(const Path & base, const Path & last, unix_tag) {
  return base + '/' + last;
}

template<class Path>
Path combine(const Path & base, const Path & last) {
  typename path_trait<Path>::tag dummy;
  return combine_impl(base, last, dummy);
}
{% endhighlight %}


## 3.4 Thread support

Thread support is special because it cannot be implemented solely as a library,
it requires support from the compiler. A concrete example of the previous
phrase is that a static member variable in a function needs to be implemented
differently in a multithreaded environment as compared to a single threaded
one.

`std::thread` has a different from usual destructor. Normally a destructor
cleans after some resource. `std::thread` terminates the process if it's
`joinable` (i.e. if the thead did not finish by the time we hit the
destructor). It makes sense when you go into the details.


## 3.5 Curiously recurring template classes

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


## 3.6 Scope guard

This are classes that [call functionality on scope exit][scope-guard], usually
with facilities to do so either when exceptions are thrown, or when exceptions
are not thrown, or all the time. This cleanup is implemented in destructors,
but unlike RAII, scope guard classes can throw from their destructors (using
`noexcept(false)` and using `std::uncaught_exceptions()` to ensure they don't
throw during stack unwinding (i.e. if an exception is already in flight). They
do not scale past the simplest examples.


# 4 Ceci n'est pas une pipe

Well, not everything has to be a class. Think the STL algorithms, think
fundamental types.

[struct-classes]:  {% post_url 2015-03-31-struct-classes %}
[classic-raii]:    {% post_url 2015-03-17-classic-raii %}
[slim-raii]:       {% post_url 2015-03-22-slim-raii %}
[fat-raii]:        {% post_url 2015-03-23-fat-raii %}
[fit-raii]:        {% post_url 2018-02-28-fit-raii %}
[class-lifetime]:  {% post_url 2015-04-02-class-lifetime %}
[scope-guard]:     {% post_url 2018-04-12-scope-guard %}
