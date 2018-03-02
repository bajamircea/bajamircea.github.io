---
layout: post
title: 'File layout in a large project'
categories: coding cpp
---

File layout in a large project benefits from regularity. Here are some sample
rules for a C++ project.

## Convention vs configuration

I've first encountered the convention approach systematically used in the Ruby
community as opposed to the configuration approach.

Say for example you have a database with tables and columns and classes with
members that map to the data in the database.

If you have the configuration approach then names of classes and members do not
have a regular mapping to the tables and column. Additional configuration, in
the form of attributes, configuration files or code, is required to perform the
mapping.

If you have the convention approach then the classes have the same name as (or
derived from) the names of the tables, and the members have the same name as
(or derived from) the names of the columns.


## Project scales

By large project I mean a project that generates a few executables, that a
small team of programmers produces over timescales of a few months, to a few
years. I believe such a project benefits from a set of rules on how to organise
the code in a regular way.

For a small project (e.g. a programmer for a couple of days) such regularity is
not required, but still beneficial.

For a huge project (e.g. large teams over many years) more rules than what I
describe here are beneficial (as it would be splitting it into several large
projects).


## Regular conventions

The file layout for a large project benefits from regularity, i.e. lack of
surprises in terms of location, naming convention and structure. The
regularity derives from using convention instead of configuration approach.

It means that if you see `auto src = cstdio::file::open(src_file_name, "rb");`
you know that we're talking about a function called `open` that you find in
`../cstdio_lib/file.(h|cpp)`

Otherwise additional time is regularly wasted on:

- Finding where a function or class is implemented
- Where are members of a class defined inside a class
- Ensuring the right header are included

As another example: if all your test executables have names ending in
`_test.exe` then the code to run them at the end of the build can be written
generically to run all executables ending in `_test.exe`. If there is no
regular naming convention then you need to store the list of test executables
to run at the end of the build and update it every time a new test executable
is added to the project, this can be error prone.


## Top level folders

Have a `src` folder for the source code. Create binaries such as executables
into a `bin` folder, use a `int` folder for intermediate binaries such as
object files.

See [fit RAII][fit-raii] as example contents of the `src` folder.


## Component folders

In `src` use a folder for each component (Visual Studio project). A component
can be: an executable, a static or dynamic library.

The folder name is the same as the component name. E.g. source for the
executable `foo.exe` are in a folder `foo`, source for a static library
`bar_lib` are in a folder `bar_lib`.

Executables are of two types: output executable and test executables for a
static library.

Keep output executables and dynamic libraries thin. E.g. the source for a
output executable consists of a small `main.cpp` using code from static
libraries. Most of the related code should be put into a static library e.g.
`foo_lib`.

Test executable for a `bar_lib` should be called `bar_lib_test`, and it's files
have derived names e.g.: `bar_lib\foo.(h|cpp)` is tested in
`bar_lib_test\foo_test.cpp`.


## Source files: .h and .cpp

Code in libraries is wrapped in a namespace derived from the name of the
library. E.g. `namespace bar` for code for a library `bar_lib`

Source files relate to a unit. You need to define what is a unit based on
selecting for single responsibility. A unit can be a class or a set of related
functions. The name of the files is the name of the unit (plus the extension).
E.g. a `foo.h` would contain a class `foo` or a namespace `foo` with functions.

You would separate a `struct` from it's related JSON
serialization/deserialization functions in different units (there are usually
plenty of contexts to use a struct without caring about serialization).

But separation is not religious: it is recommended to have in the same file
things that are intimately related.  See for example [fit RAII][fit-raii]
`file_raii.h` containing the class defining the unit, but also the
`file_raii_traits` that is closely related.


## Headers inclusion

A .cpp file first includes it's .h file (if any).

After this headers are grouped:

- headers from the same component
- headers form other components
- platform headers
- headers of external libraries (e.g. boost)
- standard library headers

Within each group headers are sorted alphabetically.

Include all (and only) the headers that a file depends on directly.


## Class members order

Inside a class prefer a consistent order e.g.:

- first types
- then constants
- then member variables
- then constructor and destructor
- then copy related
- then move related
- other public functions
- other private functions

## References

See John Lakos' talks on the subject of project layout.

[fit-raii]:  {% post_url 2018-02-28-fit-raii %}

