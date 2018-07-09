---
layout: post
title: 'On coding style'
categories: coding cpp
---

Applying writing style theory to code writing

# Introduction

As a student you might have encountered advice such as the one from the
American classic "The Elements of Style" by William Strunk and E. B. White.
It's a list of dictates starting with:
> Form the possessive singular of nouns by adding 's.

There are some gems in there such as:
> Omit needless words

Contrast this with "Clear and simple as the truth: writing classic prose" by
Francis-Noël Thomas and Mark Turner:
> A style is defined by it's conceptual stand on truth, presentation, writer,
> reader, thought, language, and their relationship 

This sounds abstract, but in the book, they make the case that the above define
style, that there are many styles, and propose the classic style as a general
usage/default style.

This approach on general writing is reflected in code (i.e. programming) style.

# Samples

Let's look at a few samples.

## Problem

This is Kipper, it's a Labrador.

![Image](/assets/2018-01-29-reflection/labrador.jpg)

Should we need to transmit information about the dog, a JSON text format would
be reasonable:

```json
{
  "name": "Kipper",
  "breed": "Labrador"
}
```

# Solution 1: OOP

```cpp
class dog
{
private:
  std::shared_ptr<std::string> name_;
  std::shared_ptr<std::string> breed_;

public:
  std::shared_ptr<std::string> get_name();
  void set_name(std::shared_ptr<std::string> value);

  std::shared_ptr<std::string> get_breed();
  void set_breed(std::shared_ptr<std::string> value);

  void init(const Json & doc);
};
```

![Image](/assets/2018-07-06-on-coding-style/01-oop-layout.png)

# Better C++ solution

```cpp
struct dog
{
  std::string name;
  std::string breed;
};


dog dog_from_json(const Json & doc);
```
Physical layout:
- dog struct is defined in dog.h
- Serialization in dog_from_json.h and cpp

![Image](/assets/2018-07-06-on-coding-style/02-classic-layout.png)

# References

Francis-Noël Thomas and Mark Turner:<br/>
Clear and simple as the truth: writing classic prose<br/>
2nd edition

William Strunk and E. B. White:<br/>
The Elements of Style

Labrador picture<br/>
https://pixabay.com/en/animal-dog-puppy-pet-photography-2184791/

