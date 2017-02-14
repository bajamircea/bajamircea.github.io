---
layout: post
title: 'Protected constructor'
categories: coding cpp
---

Almost the opposite of a regular type is a class that cannot be constructed
(except through a factory function that creates instances of such a class).


# Justification

There are situations where you want to control precisely the way instances
of a class are created. This is the case when a instance of the class is
shared between concurrent users and the instance deletes itself when the last
user releases it.

One way to achieve this is using `shared_ptr` and `enable_shared_from_this`:

{% highlight c++ linenos %}
class chat_room :
  public std::enable_shared_from_this<chat_room>
{
public:
  explicit chat_room(const std::string & name){}

  void pass_to_user()
  {
    std::shared_ptr<chat_room> ptr = shared_from_this();
    // pass ptr to users, when the last user quits
    // the chat room gets destroyed
  }
};
{% endhighlight %}

And it should be used like:

{% highlight c++ linenos %}
void good_usage()
{
  std::shared_ptr<chat_room> x =
    std::make_shared<chat_room>("lobby");
  // and later
  x->pass_to_user();
}
{% endhighlight %}

However code like below throws `bad_weak_ptr` (in C++17) because `x` is not a
shared pointer, but it compiles.

{% highlight c++ linenos %}
void bad_usage()
{
  chat_room x{ "lobby" };
  // and later
  x.pass_to_user();
}
{% endhighlight %}

I'd like the accidental misuse called at compile time, and some generic
solution for other similar classes.

# Possible solution

Create a common base class. Derive your class from this base class. Add an
additional argument to your constructor of a specific type.

The job of the base class is to:

- declare the type of the additional argument for your constructor, and make it
  protected, so that it cannot be accidentally accessed from outside your class.
- provide the `enable_shared_from_this` as a further base class
- provide a factory static method called `create` which forwards all the
  arguments to your constructor.


{% highlight c++ linenos %}
template<typename Derived>
class reference_counted :
  public std::enable_shared_from_this<Derived>
{
protected:
  struct protected_constructor_tag{};

public:
  template <typename ...T>
  static std::shared_ptr<Derived> create(T && ... all)
  {
    return std::make_shared<Derived>(
      protected_constructor_tag(),
      std::forward<T>(all) ...
      );
  }
};

class chat_room :
  public reference_counted<chat_room>
{
public:
  chat_room(
    const protected_constructor_tag &,
    const std::string & name){};

  void pass_to_user()
  {
    std::shared_ptr<chat_room> ptr = shared_from_this();
  }
};

void good_usage()
{
  std::shared_ptr<chat_room> x =
    chat_room::create("lobby");
  x->pass_to_user();
}
{% endhighlight %}
