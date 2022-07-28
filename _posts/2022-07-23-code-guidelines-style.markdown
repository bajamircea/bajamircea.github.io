---
layout: post
title: 'Code guidelines style'
categories: coding cpp
---

Code guidelines are the Strunk & White for programming languages: famous,
influential, in demand, but mediocre


# The C.12 rule

Consider the [C.12 rule in the C++ Core Guidelines][c12]. Its contents says:

**_C.12: Don’t make data members const or references_**

**_Reason_**

_They are not useful, and make types difficult to use by making them either
uncopyable or partially uncopyable for subtle reasons._

**Example; bad**
{% highlight c++ %}
class bad {
    const int i;    // bad
    string& s;      // bad
    // ...
};
{% endhighlight %}

_The `const` and `&` data members make this class "only-sort-of-copyable" –
copy-constructible but not copy-assignable._

**_Note_**

_If you need a member to point to something, use a pointer (raw or smart, and
`gsl::not_null` if it should not be `null`) instead of a reference._

**_Enforcement_**

_Flag a data member that is `const`, `&`, or `&&`._

# Sample code problem

Assuming (**example, bad**):

{% highlight c++ linenos %}
struct some_interface {
  virtual int some_function() const = 0;
  // ...
  virtual ~some_interface(){};
};
{% endhighlight %}

You code review this class (**example, bad**):

{% highlight c++ linenos %}
class some_class {
  const std::string some_string_;
  const some_interface & itf_;

public:
  some_class(const std::string & some_string,
      const some_interface & itf):
    some_string_{ some_string },
    itf_{ itf }
  {}
  // ...
};
{% endhighlight %}

Based on the code guideline above, should we get rid of the `const` and
reference for the member variables, and use a `std::shared_ptr` instead, like
in the code below? (**example, bad**):

{% highlight c++ linenos %}
class some_class {
  std::string some_string_;
  std::shared_ptr<some_interface> itf_;

public:
  some_class(const std::string & some_string,
      const std::shared_ptr<some_interface> & itf):
    some_string_{ some_string },
    itf_{ itf }
  {}
  // ...
};
{% endhighlight %}

And the answer is no, what you should do is this instead:

{% highlight c++ linenos %}
class some_class {
  const std::string some_string_;
  some_interface & itf_;

public:
  some_class(const std::string & some_string,
      some_interface & itf):
    some_string_{ some_string },
    itf_{ itf }
  {}
  // ...
};
{% endhighlight %}

The suggested code apparently runs against the C.12 rule, it keeps a `const`
and the reference, while removing the `const` for the reference. It does not
store the interface as a smart pointer.

Also `some_function` in `some_interface` should not be `const`. The interface
or class or both should be made noncopyable.


# Why?

Not all the classes are the same. As a rule of thumb, if you can structure your
code as data and functions (that operate on the data), then you've got a good
chance to write efficient code because it just maps directly to the computer
machinery: data memory and CPU instructions. But there are [all kinds of types,
not just data][taxonomy]

`some_class` is not a data class, it's a **processing class**, a class focused
not on the data it holds, but on what it does, a less refined version of a
function object. A processing class usually exposes several public member
functions compared with a function object that usually exposes just
`operator()`.

One technique that allows testing the logic in such processing classes is
[dependency injection using interfaces provided in the
constructor][dependency].


# Non-const interface member functions

You would implement that interface somewhere, e.g. in `impl_interface` a
processing class itself (**example, bad**):

{% highlight c++ linenos %}
class impl_interface :
  public some_interface
{
  int some_function() const override {
    // ...
  }
  // ...
};
{% endhighlight %}

Marking `some_function` as `const` in `some_interface` is dubious. The whole
point of the interface is hiding the implementation. The implementation might
write to an external database. In that case the function is syntactical
`const`, but not semantical. Or it might fake the database with in memory data
which it changes. Then it can't be `const` (unless the normal rules are bend
further).

In particular when it's mocked, the macro will keep in memory data, as a
statemachine that is used by test expectations. That's not `const`
semantically.

Therefore it's better to not have `const` for interface member functions:

{% highlight c++ linenos %}
struct some_interface {
  virtual int some_function() = 0;
  // ...
  virtual ~some_interface(){};
};
{% endhighlight %}


Then the mock of the interface would look like this:

{% highlight c++ linenos %}
struct interface_mock :
  public some_interface
{
    MOCK_METHOD0(some_function, int());
    // ...
};
{% endhighlight %}

# Conclusion

# References

- Strunk & White: [The Elements of Style][sw]
- [C++ Core Guidelines][c12]
- [There are all kinds of types][taxonomy]
- [Dependency injection using interfaces in the constructor][dependency]

[c12]: https://isocpp.github.io/CppCoreGuidelines/CppCoreGuidelines#Rc-constref
[dependency]: {% post_url 2015-10-31-dependency-injection-interface %}
[sw]: https://en.wikipedia.org/wiki/The_Elements_of_Style
[taxonomy]: {% post_url 2015-11-05-class-taxonomy %}
