---
layout: post
title: 'Starter C++ Project makefile'
categories: coding tools
---

Example of initial makefile for a simple C++ toy project


# Introduction

This is a sample `makefile` I'm using when I create a C++ toy project that only
uses the standard library.

- It builds a single executable into a `bin` folder.
- It assumes the source code are all the `cpp` files in the `src` folder.
- It uses a separate `tmp/build` folder for the build artefacts like object files.
- It handles incremental builds (using compiler generated dependency files).

# Sample

{% highlight make %}
# Delete the default suffixes (otherwise visible in 'make -d')
.SUFFIXES:

# Cancel source control implicit rules (otherwise visible in 'make -d')
%: %,v
%: RCS/%,v
%: RCS/%
%: s.%
%: SCCS/s.%

# Folders used
## source files expected here
SRC_DIR = src
## contains executables we build
BIN_DIR = bin
## intermediate build folder e.g. for object files and dependency files
INT_DIR = int
## temp folder
TMP_DIR = tmp

# TODO: Change executable name
TARGET = prog

# Compiler flags
CXX = g++
## -MMD creates dependency list, but ignores system includes
## -MF specifies where to create the dependency file name
## -MP creates phony targets for headers (deals with deleted headers after
##  obj file has been compiled)
## -MT specifies the dependency target (path qualified obj file name)
DEP_FLAGS = -MT $@ -MMD -MP -MF $(@:.o=.d)
STD_FLAGS = --std=c++14 -pthread -fno-rtti
WARN_FLAGS = -Wall -Werror
CXXFLAGS = $(STD_FLAGS) $(DEP_FLAGS) $(WARN_FLAGS)
LDFLAGS = $(STD_FLAGS) $(WARN_FLAGS)

# Things to build
BIN_TARGET = $(BIN_DIR)/$(TARGET)
CPP_FILES := $(wildcard $(SRC_DIR)/*.cpp)
OBJ_FILES := $(CPP_FILES:$(SRC_DIR)/%.cpp=$(INT_DIR)/%.o)
DEP_FILES := $(CPP_FILES:$(SRC_DIR)/%.cpp=$(INT_DIR)/%.d)

# Rules on how to build

## To build all 'make'
.DEFAULT: all

.PHONY: all clean run

all: $(BIN_TARGET)

## Compilation rule (dependency on .d file ensures that if the .d file
## is deleted, the obj file is created again in case a header is changed)
$(OBJ_FILES): $(INT_DIR)/%.o: $(SRC_DIR)/%.cpp $(INT_DIR)/%.d | $(INT_DIR)
	$(CXX) $(CXXFLAGS) -c -o $@ $<

## Linkage rule
$(BIN_TARGET): $(OBJ_FILES) | $(BIN_DIR)
	$(CXX) $(LDFLAGS) -o $@ $^

## Folders creation
$(BIN_DIR) $(INT_DIR):
	mkdir -p $@

## To clean and build run 'make clean && make'
clean:
	rm -rf $(BIN_DIR) $(INT_DIR) $(TMP_DIR)

## To build and run the program 'make run'
run: all
	$(BIN_TARGET)

## Do not fail when dependency file is deleted (it is required by the compile
## rule)
$(DEP_FILES): $(INT_DIR)/%.d: ;

# Include dependency files (ignore them if missing)
-include $(DEP_FILES)
{% endhighlight %}


# References

- [http://make.mad-scientist.net/papers/advanced-auto-dependency-generation/][auto-dep]

Also see a ['one exe per source file' makefile][starter-makefile].

[auto-dep]: http://make.mad-scientist.net/papers/advanced-auto-dependency-generation/
[starter-makefile]:    {% post_url 2016-06-10-one-to-one-makefile %}
