---
layout: post
title: 'C++ comparison (first attempt)'
categories: coding cpp
---

The first attempt in C++ to handle equality and order: ask programmer to
explicitly implement all comparisons operators.

This article is part of a series on [the history of regular data type in
C++][regular-intro].


# Comparison operator

C++ allowed customizing comparison operators.

For example for equality you can do:

{% highlight c++ linenos %}
class foo {
  // ...
public:
  bool operator==(const foo & other) const {
    // compare *this with other
    // return true if equal
    // return false otherwise
  }

  // ...
};
{% endhighlight %}

and it will be called when you compare using `==` two variables of type `foo`:

{% highlight c++ linenos %}
  // assuming a and b are of type foo
  // operator == is called here
  // *this is a, other is b
  if (a == b) {
    // ...
  }
{% endhighlight %}


# Heterogeneous and friend

The comparison above is homogeneous, the types compared are the same type. It
compares `foo` with `foo`. Most of the time you want to compare apples with
apples and oranges with oranges.

But the case where the types are different also occurs. This is a heterogeneous
comparison. For example we want to compare `std::string` with a literal string:

{% highlight c++ linenos %}
class foo {
  // ...
public:
  bool operator==(const char * other) {
    // compare *this with other
    // return true if equal
    // return false otherwise
  }

  // ...
};
{% endhighlight %}

But the rules of the language were such that it looked for a comparison
member function only for the type on the left hand side of the operation:

{% highlight c++ linenos %}
  // assuming a is a foo
  // operator == is called here
  // *this is foo, other is a string literal
  // it works
  if (a == b) {
    // ...
  }
  // but this does not work
  if (b == a) {
    // ...
  }
{% endhighlight %}

So the language added the ability to make such comparison functions standalone
functions which can accept arguments of different types:

{% highlight c++ linenos %}
// outside the foo class
bool operator==(const foo & x, const char * y) {
  // compare x with y
}
{% endhighlight %}

But then how do you ensure that such a function can access private members of
`foo`? Ah, then you make them friend and either you continue to define them
outside the class or you define them inside the class as below (but they are
not member functions, they don't take `this` as a hidden additional argument):

{% highlight c++ linenos %}
class foo {
  // ...
public:
  friend bool operator==(const foo & x, const char * y) {
    // compare x with y
    // return true if equal
    // return false otherwise
  }

  // ...
};
{% endhighlight %}


# Unnecessary duplication

There are six such comparison operators:

- `==` for equal to
- `!=` for "not equal"
- `<` for less than
- `>` for greater than
- `<=` for less than or equal to
- `>=` for greater than or equal to

But they are not really independent.

Unfortunately the language required you to define them explicitly one by one,
so for example if `==` is defined, but `!=` is not defined, then the following
fails at compile time:

{% highlight c++ linenos %}
  // fails if == is defined, but != is not defined
  if (a != b) {
    // ...
  }
{% endhighlight %}

This can be fixed by defining `!= ` as well.

But other than syntax, the reality is that semantically comparisons are not
really independent from each other, in particular they appear in groups.

So the practice is to define one of the functions in the group, while the
others in the group are implemented in terms of the basic one.

In the equality group `!=` is implemented in terms of `==`:

{% highlight c++ linenos %}
bool operator==(const foo & x, const foo & y) {
  // actual implementation of ==
}

bool operator!=(const foo & x, const foo & y) {
  return !(x == y);
}
{% endhighlight %}

Similar for the order group, the other comparisons are implemented in terms of
`<`:

{% highlight c++ linenos %}
bool operator<(const foo & x, const foo & y) {
  // actual implementation of <
}

bool operator<=(const foo & x, const foo & y) {
  return !(y < x);
}
bool operator>(const foo & x, const foo & y) {
  return y < x;
}
bool operator>=(const foo & x, const foo & y) {
  return !(x < y);
}
{% endhighlight %}

Similar issues apply to the heterogeneous operations, shown here for equality:

{% highlight c++ linenos %}
bool operator==(const foo & x, const char * y) {
  // actual implementation of ==
}

bool operator!=(const foo & x, const char * y) {
  return !(x == y);
}

bool operator==(const char * x, const foo & y) {
  return y == x;
}

bool operator!=(const char * x, const foo & y) {
  return y != x;
}
{% endhighlight %}

To avoid such duplication, the standard attempted to help with the
`std::rel_ops` namespace, but not very successfully, it has been deprecated in
C++20, so will not explore `std::rel_ops` further.

# lhs and rhs vs x and y

In terms of variable names, traditionally `rhs` and `lhs` were used to stand
for "right hand side" and "left hand side", though here I borrow from Alex
Stepanov the more intuitive notation `x` and `y`.


[regular-intro]:   {% post_url 2022-11-16-regular-history %}
