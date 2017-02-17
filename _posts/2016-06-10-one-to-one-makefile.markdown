---
layout: post
title: 'One to one makefile'
categories: coding tools
---

Example of makefile building one executable for each C++ file in a folder.


# Introduction

I'm using this makefile to do small compiler or standard library
experiments. It builds multiple executables, one for each cpp file.

# Sample

{% highlight make %}
CPP_FILES := $(shell find . -name '*.cpp')
EXE_FILES := $(CPP_FILES:%.cpp=bin/%)

all: $(EXE_FILES)

bin/%: %.cpp | bin
	g++ --std=c++14 -Wall -Werror -fno-rtti -o $@ $<

bin:
	mkdir bin

.PHONY: clean

clean:
	rm -rf bin
{% endhighlight %}

Also see a [more realistic sample][starter-makefile].

[starter-makefile]:    {% post_url 2016-06-09-starter-cpp-program-makefile %}

