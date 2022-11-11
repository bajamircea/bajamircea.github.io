---
layout: post
title: 'Unit tests: mocks, fakes and spies'
categories: coding cpp
---

Mocks, fakes and spies are techniques for isolating a subset of the component
graph for unit tests


We're going to look at a small code example, then we're going to look at a unit
test for that code using mocks, fakes and spies. From this concrete example
we're going to explain the terminology and how it generalizes.


# Code

Here is some fictional code that we would like testing:

## transfer.h
{% highlight c++ linenos %}
class transfer
{
public:
  transfer(
    contacts_db_interface & src,
    contacts_db_interface & dst);

public:
  void read(int id);
  void save();

private:
  contacts_db_interface & src_;
  contacts_db_interface & dst_;
  std::vector<contact> cache_;
};
{% endhighlight %}

## transfer.cpp
{% highlight c++ linenos %}
transfer::transfer(
    contacts_db_interface & src,
    contacts_db_interface & dst):
    src_ { src },
    dst_ { dst }
{}

void transfer::read(int id) {
  auto item = src_.find_by_id(id);
  if (item.has_value()) {
    cache_.push_back(*item);
  }
}

void transfer::save() {
  for (const auto & item : cache_) {
    dst_.insert(item);
  }
  cache_.clear();
}
{% endhighlight %}

What we see is that we have this `transfer` class that can be used to read
`contact`s by `id` from a source `contacts_db` and save the accumulated reads
to a destination `contacts_db`. Both `contacts_db`s are accessed via the
interface `contacts_db_interface` that looks like this:

## contacts_db_interface.h

{% highlight c++ linenos %}
struct contact {
  int id;
  std::string name;
  std::string email;
};

struct contacts_db_interface {
  virtual std::optional<contact> find_by_id(int id) = 0;
  virtual void insert(const contact & item) = 0;

  virtual ~contacts_db_interface() = default;
};
{% endhighlight %}


# Graph

Given the code above we can picture a subset of the program graph of
components:
- there are some users of the `transaction`
- the `transaction` presumably uses two `contacts_db` via the interface and
  also uses the `contact` and the `std::vector` `cache_`.
- the `contacts_db` each use some component for database access and also
  `contact`
- `contact` uses `std::string`
- `std::string` and `std::vector` both allocate memory on the heap

<div align="center" style="max-width: 500px">
{% include assets/2022-05-31-mock-fake-spy/01-graph.svg %}
</div>

In a well written program the graph is a DAG (directed acyclic graph):
- the edges between entities are **directed** from the one that uses to the one
  that is used
- the graph is **acyclic**: there are no directed cycles, there is a clear
  hierarchy of who is using what


# Unit test

We can now test the `transaction` class, using a unit test framework, with the
view of using mocks and fakes to reduce the area of the graph that is tested.


## transaction_test.h

We first create a mock type to replace the source `contacts_db`. For each
method that the mock implements we use in this case the macro `MOCK_METHOD`.
The macro declares the target function, and a member variable that is used to
store a state machine which drives the implementation of that function.

{% highlight c++ linenos %}
struct contacts_db_mock :
  public contacts_db_interface
{
  MOCK_METHOD(std::optional<contact>, find_by_id, (int), (override));
  MOCK_METHOD(void, insert, (const contact &), (override));
};
{% endhighlight %}

We then create a fake type to replace the destination `contacts_db`. We've
chosen a mock for the source and a fake for the destination just for the sake
of exercise, in practice we would use the same approach for both.

Instead of a real database, we store the data in memory in the member variable
`data_` and we implement the methods as manipulation of the member variable.

{% highlight c++ linenos %}
struct contacts_db_fake :
  public contacts_db_interface
{
  std::vector<contact> data_;

  std::optional<contact> find_by_id(int id) override {
    auto it = std::find_if(data_.cbegin(), data.cend(),
      [=id](const contact & c) {
        return c.id = id;
      });
    if (it == data.cend()) return {};
    return *it;
  }
  void insert(const contact & item) override {
    data_.push_back(item);
  }
};
{% endhighlight %}

I'm omitting the details on how to implement `memory_spy`, but imagine an
object which intercepts heap memory allocations and deallocations for the
purpose of keeping tallies e.g. ensure that they match and there are no
accidental memory leaks.

We are now ready to do the actual test:

{% highlight c++ linenos %}
TEST(transaction_test, simple)
{
  // instantiate spy, mock and fake
  memory_spy mem;
  StrictMock<contacts_db_mock> src;
  contacts_db_fake dst;

  // setup mock expectations
  EXPECT_CALL(src, find_by_id(42))
    .WillOnce(Return(contact{ 42, "Bob", "bob@example.com"));

  // trigger test
  transaction t{ src, dst };
  t.read(42);
  t.save();

  // check fake state
  const std::vector<contact> expected_data = {
    {42, "Bob", "bob@example.com"},
  };
  EXPECT_EQ(expected_data, dst.data);
}
{% endhighlight %}


# Terminology and observations

Notice that although called "unit test", the test covers multiple entities, a
subset of the components graph of the program, not just the entity under test.

In our case the entity under test is the `transaction`, but the test also
covers others: `contact`, `std::string` and `std::vector`.

The entities can be classes/objects, but also functions.

When the entity under test has a small or empty graph underneath it, it's easy
to test, especially for regular functions that perform some calculation as
we've seen in the previous article.

But when the entity under test has a large graph underneath it, we need ways to
cut it, to reduce it to a smaller one, so we need some replacements for the
real entities in the real components graph. The generic name for replacements
for test purposes is **doubles** (like a person substituting an actor on a film
set). Mocks and fakes are such doubles.

**Fakes** are doubles that try to simulate the real implementation. The
problem is that they require quite a lot of non-repetitive code for that
simulation.

**Mocks** are doubles that do not even try to simulate the real implementation.
Instead they have support from the unit test framework to generate state
machines that provide canned responses. That's what the combination of
`MOCK_METHOD` and `EXPECT_CALL` does in our case.

The difference between fakes and mocks usually reflects in different styles of
verification. Mocks encourage **behaviour verification** where we check how the
entity under test performs the task. In our case we set up the expectation that
`find_by_id` will be called once with value `42` for the `id` argument, and by
using the `StrictMock` that no other calls will be made.  Another style is
**state verification** where we check the end result (regardless of how we got
there). In our case this is shown in the use of the fake, where we check at the
end that the `data_` has the expected content.

I've also alluded to the **spy** technique (the `memory_spy` in our case),
which is a wrapper around the real entity with the purpose of intercepting the
calls in order to do some record keeping. This allows some introspection for
test purposes, but does not decrease the size of the component graph under
test.

