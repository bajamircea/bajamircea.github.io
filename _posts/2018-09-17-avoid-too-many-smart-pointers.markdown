---
layout: post
title: 'Avoid too many smart pointers'
categories: coding cpp
---

Too many smart pointers considered evil


# The scenario

You've got an entry point, say a class `program` with a `start` and a `stop`
method. Then you have a class `house`, with a `kitchen` and a `living_room`
both sharing the same `door`. The job is to instantiate the `house` and its
dependencies in `start` and delete it in `stop`. There is also a `shed`. It too
has to be instantiated in `start` and deleted in `stop`.


# The anti-pattern

Here is a version of `program`:

{% highlight c++ linenos %}
class program {
  std::unique_ptr<house> house_;
  std::unique_ptr<shed> shed_;

public:
  void start() {
    auto d = std::make_shared<door>();
    auto k = std::make_unique<kitchen>(d);
    auto lr = std::make_unique<living_room>(d);
    house_ = std::make_unique<house>(std::move(k), std::move(lr));
    shed_ = std::make_unique<shed>();
  }

  void stop() {
    house_.reset();
    shed_.reset();
  }
};
{% endhighlight %}

And here is the gist of the required support from the other classes:

{% highlight c++ linenos %}
class door {
  // door code here
};

class kitchen {
  std::shared_ptr<door> door_;

public:
  explicit kitchen(std::shared_ptr<door> d) : door_{ d } {}

  // more kitchen code here
};

class living_room {
  std::shared_ptr<door> door_;

public:
  explicit living_room(std::shared_ptr<door> d) : door_{ d } {}

  // more living_room code here
};

class house {
  std::unique_ptr<kitchen> kitchen_;
  std::unique_ptr<living_room> living_room_;

public:
  house(std::unique_ptr<kitchen> k, std::unique_ptr<living_room> l_r)
   : kitchen_{ std::move(k) }, living_room_{ std::move (l_r) }
  {}

  // more living_room code here
};

class shed {
  // shed code here
};
{% endhighlight %}

The anti-pattern overuses smart pointers.

We use `unique_ptr`, but not for the `door`. For it we use `shared_ptr` because
it's shared. As the code changes and an object becomes shared there is ripple
of changes. E.g. the `kitchen` has to care that the `living_room` uses the same
`door`.

The objects have additional responsibilities: e.g. `house` is also responsible
with managing the `living_room` instance lifetime, in addition to its core
responsibility.

The claimed usage of smart pointers in the anti-pattern is to address lifetime
issues. However notice how if constructing `shed_` fails by throwing an
exception, `house_` stays created after exiting `start`. Also notice that the
order in which the `house_` and the `shed_` get destroyed depends on whether
`stop` is called or not before the `program` is destroyed. **These subtle
lifetime issues become a problem in a large program**.

# Better option

Here is a version of `program`:

{% highlight c++ linenos %}
class program {
  std::unique_ptr<buildings> buildings_;

public:
  void start() {
    buildings_ = std::make_unique<buildings>();
  }

  void stop() {
    buildings_.reset();
  }
};
{% endhighlight %}

And here is the gist of the required support from the other classes:

{% highlight c++ linenos %}
class door {
  // door code here
};

class kitchen {
  door & door_;

public:
  explicit kitchen(door & d) : door_{ d } {}

  // more kitchen code here
};

class living_room {
  door & door_;

public:
  explicit living_room(door & d) : door_{ d } {}

  // more living_room code here
};

class house {
  kitchen & kitchen_;
  living_room & living_room_;

public:
  house(kitchen & k, living_room & l_r)
   : kitchen_{ k }, living_room_{ l_r }
  {}

  // more living_room code here
};

class shed {
  // shed code here
};

// and putting them together in a builder/injector class

class buildings {
  door door_;
  kitched kitchen_;
  living_room living_room_;
  house house_;
  shed shed_;

public:
  buildings()
    : door_{},
      kitchen_{ door_},
      living_room_{ door },
      house_{ kitchen_, living_room_ },
      shed_{}
  {}
};
{% endhighlight %}


The `start`/`stop` pattern is bad, you might leave it as such if you need to
treat it as a legacy boundary (e.g. can't re-write all the code in an
application).

The better option uses smart pointers just once only to deal with the legacy
boundary. It will allocate just once.

It makes each component have a clearer defined purpose.

For example the `buildings` class is a [builder/injector][taxonomy] with the
only purpose to manage the [lifetime of the aggregated objects][lifetime].


# References

- [C++ Class Lifetime][lifetime]
- [C++ Class Taxonomy][taxonomy] for the builder/injector class
- [Article on dependencies][dependencies]


[lifetime]:      {% post_url 2015-04-02-class-lifetime %}
[taxonomy]:      {% post_url 2015-11-05-class-taxonomy %}
[dependencies]:  {% post_url 2015-10-29-dependency-problem %}
