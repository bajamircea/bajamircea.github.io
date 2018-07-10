---
layout: post
title: 'On coding style'
categories: coding cpp
---

Applying writing style theory to code writing.

This article is also available as [presentation
slides](/presentations/2018-07-06-on-coding-style.html)

# Introduction

As a student you might have encountered advice such as the one from the
American classic "The Elements of Style" by William Strunk and E. B. White.
It's a list of rules starting with:

> Form the possessive singular of nouns by adding 's.

There are some gems in there such as:

> Omit needless words

Overall they do not offer an insight into how those rules define style. They
appear as an almost random selection.

Contrast this with "Clear and simple as the truth: writing classic prose" by
Francis-Noël Thomas and Mark Turner:
> A style is defined by it's conceptual stand on truth, presentation, writer,
> reader, thought, language, and their relationship 

This sounds abstract, but in the book, they make the case that the above define
style, that there are many styles, and propose the classic style as a general
usage/default style.

This approach on general writing can be used with regards to code (i.e.
programming) style.


# Sample

Let's look at a few samples.

## Problem

This is Kipper, it's a Labrador.

![Image](/assets/2018-01-29-reflection/labrador.jpg)

Should we need to transmit information about the dog, a JSON text format would
be reasonable:

{% highlight json linenos %}
{
  "name": "Kipper",
  "breed": "Labrador"
}
{% endhighlight %}

# OOP style

{% highlight c++ linenos %}
class dog
{
private:
  std::shared_ptr<std::string> name_;
  std::shared_ptr<std::string> breed_;

public:
  std::shared_ptr<std::string> get_name()
  {
    return name_;
  }
  void set_name(std::shared_ptr<std::string> value)
  {
    name_ = value;
  }

  std::shared_ptr<std::string> get_breed()
  {
    return breed_;
  }
  void set_breed(std::shared_ptr<std::string> value)
  {
    breed_ = value;
  }

  void init(const Json & doc)
  {
    name_ = doc.get_string("name");
    breed_ = doc.get_string("breed");
  }
};
{% endhighlight %}

This solution takes the dogmatic view that problems should be represented as
objects, and a particular kind of object: with getters and setters, reference
semantics, initialization after construction.

This naive view has many undesirable consequences, including a complex memory
layout.

![Image](/assets/2018-07-06-on-coding-style/01-oop-layout.png)


## Lambda style

{% highlight c++ linenos %}
void dog_from_json(
  std::function<std::string(const char * key)> property,
  std::function<const std::string & name, const std::string & breed> callback)
{
  callback(property("name"), property("breed"));
}

[&doc]() {
  std::string name;
  std::string breed;
  dog_from_json([&doc](const char * key) {
    return doc.get_string(key);
  }, [&] (const std::string & name_, const std::string & breed_) {
    name = name_;
    breed = breed_;
  });
  // use name and breed here ...
} ();

{% endhighlight %}

This solution takes the dogmatic view that problems should be represented as
functions.

This naive view comes with it's own undesirable consequences.


## Classic style

{% highlight c++ linenos %}
struct dog
{
  std::string name;
  std::string breed;
};

dog dog_from_json(const Json & doc)
{
  return { doc.get_string("name"), doc.get_string("breed") };
}
{% endhighlight %}

This solution takes the equally dogmatic view that there are many ways
representing reality and that a `struct` is the right way to group a number of
fields, and that functions are the right way to transform a type to another
type.

This solution has it's own problems, such as the lack of compiler defined
comparisons for user defined types, but it does address the memory layout.

![Image](/assets/2018-07-06-on-coding-style/02-classic-layout.png)


## Performance style

{% highlight c++ linenos %}
void dog_from_json(char * json_buffer, char ** name, char ** breed)
{
  // gets a non-const buffer of characters and will point name and breed
  // to values in the buffer
}
{% endhighlight %}

This solution takes the view that it can obtain better performance by using
risky techniques such as a non-const input that it will mutate in order to
avoid allocating the output strings. It also avoids abstractions such as
`std::string`.


# On styles

There are a multitude of coding styles.

They are defined by attitudes to truth, representation, abstraction usage,
generality, and relation between the writer and reader.

Programmers should use the classic style. It takes the view that there are
multiple ways to represent reality, and that there is an appropriate
representation that needs to be identified. It assumes that there is a one true
representation and that it can be identified through careful reasoning,
avoiding pitfalls such as object only or lambda only narrow views. It's a
style that does not shy away from using abstractions. It aims for a certain
generality. Behind it's simplicity lies the writer's effort to aim for that
simplicity and a certain elegance. The writer assumes the reader understands
that there is no single way to represent reality as objects only or lambdas
only.

That is not the only valid style, we've seen for example a performance style.
It does not aim for generality, it's supposed to be aimed to the specific
situations where the riskier to use, lower level interface gives performance
benefits (based on measurement).


# On superficial elements of style

Indentation and tab wars are superficial. While some choices are marginally
better, a variety of choices are valid and do not impede reading the code, as
long as there is local consistency. Indentation is less important than the
choices of how to represent the world in computer language entities.

Often code guidelines often take the approach of a random collection of advice.

Notice the similarity between the first rule in "The Elements of Style":

> Form the possessive singular of nouns by adding 's. [...] Exceptions are the
> possessive of ancient proper names ending in -es and is, [...]

and the first rule in the "Google C++ Style Guide":

> In general, every .cc file should have an associated .h file. There are some
> common exceptions, such as unittests and small .cc files containing just a
> main() function.


# References

Francis-Noël Thomas and Mark Turner:<br/>
Clear and simple as the truth: writing classic prose<br/>
2nd edition

William Strunk and E. B. White:<br/>
The Elements of Style

Labrador picture<br/>
https://pixabay.com/en/animal-dog-puppy-pet-photography-2184791/

Google C++ Style Guide<br/>
https://google.github.io/styleguide/cppguide.html

