---
layout: post
title: 'Starter C++ Project makefile'
categories: coding cpp
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
# Delete the default sufixes (otherwise visible in 'make -d')
.SUFFIXES:

# Cancel source control implicit rules (otherwise visible in 'make -d')
%: %,v
%: RCS/%,v
%: RCS/%
%: s.%
%: SCCS/s.%

# Folders used
## contains executables we build
BIN_DIR = bin
## source files expected here
SRC_DIR = src
## temp folder
TMP_DIR = tmp
## build folder e.g. for object files and dependency files
BUILD_DIR = $(TMP_DIR)/build
## Output folders to 'mkdir -p'
OUT_DIRS = $(BIN_DIR) $(BUILD_DIR)

# Create output directories
## Compromise to allow 'make clean all' to work
$(shell mkdir -p $(OUT_DIRS))

# Executable name
TARGET = prog

# Compiler flags
CXX = g++
## -MMD creates dependency list, but ignores system includes
## -MF specifies the dependency file name
## -MP includes the dependency file as a target
## -MT specifies the target (to get path qualified obj file name)
DEP_FLAGS = -MT $@ -MMD -MP -MF $(BUILD_DIR)/$*.d
STD_FLAGS = --std=c++14 -pthread
WARN_FLAGS = -Wall -Werror
CXXFLAGS = $(STD_FLAGS) $(DEP_FLAGS) $(WARN_FLAGS)
LDFLAGS = $(STD_FLAGS)

# Things to build
BIN_TARGET = $(BIN_DIR)/$(TARGET)
CPP_FILES := $(shell find $(SRC_DIR) -name '*.cpp')
OBJ_FILES := $(CPP_FILES:$(SRC_DIR)/%.cpp=$(BUILD_DIR)/%.o)
DEP_FILES := $(CPP_FILES:$(SRC_DIR)/%.cpp=$(BUILD_DIR)/%.d)

# Rules on how to build

.DEFAULT: all

.PHONY: all, clean, run

all: $(BIN_TARGET)

$(OBJ_FILES): $(BUILD_DIR)/%.o: $(SRC_DIR)/%.cpp $(BUILD_DIR)/%.d
	$(CXX) $(CXXFLAGS) -c -o $@ $<

$(BIN_TARGET): $(OBJ_FILES)
	$(CXX) $(LDFLAGS) -o $@ $^

## 'mkdir -p' in clean is compromise to allow 'make clean all' to work
clean:
	rm -rf $(OUT_DIRS)
	mkdir -p $(OUT_DIRS)

run: all
	$(BIN_TARGET)

# Handle better the case when dependency file depends on deleted file
$(DEP_FILES): $(BUILD_DIR)/%.d: ;

# Include dependency files
## ignore them if missing
-include $(DEP_FILES)
{% endhighlight %}


# References

- [http://make.mad-scientist.net/papers/advanced-auto-dependency-generation/][auto-dep]


[auto-dep]: http://make.mad-scientist.net/papers/advanced-auto-dependency-generation/
