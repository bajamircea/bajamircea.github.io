---
layout: post
title: 'Dependency Injection Using Templates and Concepts'
categories: coding cpp
---

Experiment wtih adding C++17 concepts/requirements to the
dependency injection with templates example.


# Introduction

Ever since I wrote [the example of dependency injection using
templates][dependency-templates] I thought I wanted to try using C++17
concepts/requirements.

To date, when using templates, compared with using vtable interfaces, one
gives up ease of development/compiler enforcement to gain genericity and
performance. I hoped that the concepts will allow the programmer to define the
expectations on the injected classes. However this will add to the total number
of lines of code, increasing them closer to [the vtable
example][dependency-interfaces], and was wondering how the numbers will pan
out.

# What you need to try it now

I used GCC 6.0, the tip from the GCC github mirror, and build it using the
hints from [A.  Sutton's origin pages][origin-start], on a Ubuntu 15.10 virtual
machine. It needed some the trial and error. Other than the need to install
additional packages (e.g. `flex`) I've learned that you get weird messages if
the VM has only 1GB memory. 4GB is much better.

The rough steps I've followed are:

{% highlight bash linenos %}
mkdir ~/src
cd ~/src
git clone https://github.com/gcc-mirror/gcc.git
cd gcc
./contrib/download_prerequisites
mkdir -p ~/build/gcc
cd ~/build/gcc
~/src/gcc/configure --prefix=~/opt/gcc6 --disable-bootstrap --disable-multilib --disable-nls --disable-werror --enable-languages=c,c++
make
make install
~/opt/gcc6/bin/gcc --version

export PATH="$HOME/opt/gcc6/bin:$PATH"
{% endhighlight %}

To compile a test program you need to pass the `-fconcepts` argument.

{% highlight c++ linenos %}
g++ -fconcepts main.cpp
{% endhighlight %}


# Code

Here is one option to enforce the expectation of the `house` class on it's
template types. Lines 7 to 23 are the overhead of using
concept/requirements.

### house.h (injected types and references)
{% highlight c++ linenos %}
#pragma once

template<
  typename Cuppa,
  typename Door,
  typename Tv>
concept bool House()
{
  return requires(
    Cuppa c,
    Door d,
    Tv t)
  {
    {c.finish()} -> void;

    {d.open()} -> void;
    {d.close()} -> void;

    {t.switch_on()} -> void;
  };
}

House{Cuppa, Door, Tv}
class house
{
public:
  house(
    Cuppa & cuppa,
    Door & door,
    Tv & tv
    ) :
    cuppa_{ cuppa },
    door_{ door },
    tv_{ tv }
  {
  }

  void chillax()
  {
    cuppa_.finish();

    door_.open();
    door_.close();

    tv_.switch_on();
  }

private:
  Cuppa & cuppa_;
  Door & door_;
  Tv & tv_;
};
{% endhighlight %}

### main.cpp
{% highlight c++ linenos %}
#include <cuppa>
#include <door>
#include <tv>
#include <house>

int main()
{
  cuppa c;
  door d;
  tv t;
  house<cuppa, door, tv> h{ c, d, t };
  h.chillax();
}
{% endhighlight %}

Note that that there is more than one way of doing things. For example from the syntax
point of view:

{% highlight c++ linenos %}
// House{Cuppa, Door, Tv} is shorthand for
template<
  typename Cuppa,
  typename Door,
  typename Tv
  >
  requires House<Cuppa, Door, Tv>()
{% endhighlight %}

Similarly one could have defined separate concepts for `Cuppa`, `Doo`r and `Tv`,
instead of having them under `House`. In this case that would have been more
verbose, with no gain.




# Error 

If the `door` class does not have a `close` method, one would now get a message
like:

{% highlight text linenos %}
main.cpp: In function 'int main()':
main.cpp:11:24: error: template constraint failure
   house<cuppa, door, tv> h{ c, d, t };
                        ^
house.h:7:24: note:   constraints not satisfied
house.h:7:24: note:   concept 'House<cuppa, door, tv>()' was not satisfied
house.h:7:37: error: scalar object 'h' requires one element in initializer
   house<cuppa, door, tv> h{ c, d, t };
                                     ^
{% endhighlight %}

For this trivial example, the pre-concept error message would have been
shorter.

{% highlight text linenos %}
main.cpp: In instantiation of 'void house<Cuppa, Door, Tv>::chillax() [with Cuppa = cuppa; Door = door; Tv = tv]':
main.cpp:11:13:   required from here
house.h:43:11: error: 'struct door' has no member named 'close'
     door_.close();
     ~~~~~~^~~~~
{% endhighlight %}

But the advantage of concepts is that one can easily require say the `close`
method for `door` to be `noexcept` and return `int`: `{d.close()} noexcept ->
int;`.  Without concepts that would have not been possible to enforce at
compile time.


# Conclusion

The concepts syntax is reasonably compact and very powerful with regards to
what it can enforce.


# References

- http://www.stroustrup.com/sle2011-concepts.pdf
- http://www.open-std.org/jtc1/sc22/wg21/docs/papers/2012/n3351.pdf
- http://www.open-std.org/jtc1/sc22/wg21/docs/papers/2013/n3701.pdf
- http://asutton.github.io/origin/start.html


[dependency-interfaces]:    {% post_url 2015-10-31-dependency-injection-interface %}
[dependency-templates]:    {% post_url 2015-11-01-dependency-injection-templates %}
[origin-start]: http://asutton.github.io/origin/start.html
