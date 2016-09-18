---
layout: post
title: 'Special class operations. Declarative nature'
categories: coding cpp
---

A look at the dual imperative and declarative nature for the copy and move
behaviour in the light of compiler optimisations.


## Introduction

Imperative coding style is explicit about the actions to execute and their
sequence. If we call several C++ functions in sequence, we expect the compiler
and CPU to generate code that would execute "as if" they are executed in
sequence.  The "as if" means that we're happy if the compiler and the CPU
re-order low level operations and speed up execution, as long as the observable
side effects (e.g.  messages printed in the console, operations to a database,
network traffic) do not get reordered.

Declarative coding style is when we state the expected results, and something
else takes care of the actions happening. For example in a `makefile` we
specify the targets, the dependencies and the actions to build targets from
dependencies, but we expect `make` to generate a dependency graph, and execute
only the required actions in a sequence of it's choosing.

In the examples below we'll use a heavily instrumented class

{% highlight c++ linenos %}

#include <iostream>

struct X
{
  X() { std::cout << "Constructor\n"; }
  ~X() { std::cout << "Destructor\n"; }
  X(const X &) { std::cout << "Copy constructor\n"; }
  X& operator=(const X &) { std::cout << "Copy assignment\n"; return *this; }
  X(X &&) { std::cout << "Move constructor\n"; }
  X& operator=(X &&) { std::cout << "Move assignment\n"; return *this; }
};

int main()
{
  X a;
}
{% endhighlight %}

In the example above we declare a variable of type `X`. The imperative aspect
is that we say "construct a instance" and the compiler calls the constructor.
However the destructor is called automatically, and it has a declarative nature
here: we declare a destructor, and it's up to the compiler to call it when
required.

So for the example above we expect:

{% highlight text linenos %}
Constructor
Destructor
{% endhighlight %}


## Copy elision

If we use the class `X` as below to create a temporary instance of `X` and
assign it to `b`.

{% highlight c++ linenos %}
int main()
{
  X b = X();
}
{% endhighlight %}

One naive expectation would be that we would get (with my added comments after
`:`):

{% highlight text linenos %}
Constructor : construct b
Constructor : construct temporary
Copy assignment : copy asign from temporary to b
Destructor : destruct temporary
Destructor : destruct b
{% endhighlight %}

But, even if the syntax looks like an assignment, what's the point to construct
an object and then copy assign to it, when the compiler could do it in one go,
using the copy constructor:

{% highlight text linenos %}
Constructor : construct temporary
Copy constructor : copy construct b from temporary
Destructor : destruct temporary
Destructor : destruct b
{% endhighlight %}

And then you might notice that we're talking about a temporary, and we have
move constructor, so since C++11 the compiler could use that so that `b` takes
over the content of the temporary (which is not used after that other than to
call it's destructor), in which case we would have:

{% highlight text linenos %}
Constructor : construct temporary
Copy constructor : move construct b from temporary
Destructor : destruct temporary
Destructor : destruct b
{% endhighlight %}

What we actually get from most compilers is:

{% highlight text linenos %}
Constructor
Destructor
{% endhighlight %}

Then one could say: thanks, but how about side effects? The printed text is
different from the choices above.

Enter copy elision. Even before C++11 the compiler was allowed to optimize the
code even if it would have side effects and remove the copy, on the idea that
copy is supposed to copy, not to have side effects. C++17 [guarantees copy
elision][cpp17-copy-elision] in some cases.

So in addition to the destructor, the copy and move (constructor and
assignment) have a declarative nature: they declare how to copy and move, and
the compiler is allowed to optimise as it pleases, regardless of side effects
in this case.


## Other copy/move optimisations

Another optimisation situation is the return value optimisation for:

{% highlight c++ linenos %}
X fn()
{
  return X();
}

int main()
{
  X c = fn();
}
{% endhighlight %}

That does not generate additional temporary objects (e.g. for the return value)
and instead it prints:

{% highlight text linenos %}
Constructor
Destructor
{% endhighlight %}

And the same happens for the named return value optimisation (when there is a
named variable `tmp` in this case).

{% highlight c++ linenos %}
X fn()
{
  X tmp;
  return tmp;
}

int main()
{
  X d = fn();
}
{% endhighlight %}


## Not all temporaries are optimised

In the code below at line 4, one could expect that at least `tmp` could be
moved into `input` because it's no longer used past the assignment, it is
semantically a temporary. However that does not happen, and copy is called
instead.

{% highlight c++ linenos %}
void fn(X & input)
{
  X tmp;
  input = tmp;
}

int main()
{
  X e;
  fn(e);
}
{% endhighlight %}

Prints:

{% highlight text linenos %}
Constructor : construct e
Constructor : construct tmp
Copy assignment : copy asign from tmp to e
Destructor : destruct tmp
Destructor : destruct e
{% endhighlight %}

However the programmer knows that the `tmp` variable is not used past the
assignment, so we could move it into the `input` instead (by being imperative):

{% highlight c++ linenos %}
  input = std::move(tmp);
{% endhighlight %}

Which then prints:

{% highlight text linenos %}
Move assignment : copy asign from tmp to e
{% endhighlight %}


## Conclusion

Unlike normal functions, the destructor, copy and move (constructor and
assignment) have a declarative nature. You declare what should happen if the
compiler destructs, copies or moves an instance, and the compiler calls them as
it needs to, on the assumption that they define how to destruct, copy or move,
ignoring side effects.

However we've also seen that the compiler does not indentify all the cases when
a variable is no longer used, and we had to use `std::move` to communicate this
intent.

[cpp17-copy-elision]: http://www.open-std.org/jtc1/sc22/wg21/docs/papers/2015/p0135r0.html
