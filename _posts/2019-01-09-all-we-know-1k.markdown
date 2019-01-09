---
layout: post
title: 'All we know takes less than 128 bytes'
categories: coding tools
---

A surprising consequence of using SHA-1 in git.


# Introduction

Git is a source control tool. It keeps track of changes to files. You can store
any files in git: source code, text of books, pictures, movies, etc.

For a particular version of a set of files it uses a SHA-1 checksum. A SHA-1
checksum only takes 20 bytes.

The intent is to have a 1-to-1 relationship between a particular version of a
set of files and a short, fixed length identifier (the SHA-1 checksum).

For example for a particular version of the Linux source code is identified by
the checksum
[4064e47c82810586975b4304b105056389beaa06](https://github.com/torvalds/linux/commit/4064e47c82810586975b4304b105056389beaa06).
And the previous version is identified by the checksum
[a88cc8da0279f8e481b0d90e51a0a1cffac55906](https://github.com/torvalds/linux/commit/a88cc8da0279f8e481b0d90e51a0a1cffac55906).

In a sense, all the additional hard work in between did not require more bits
in order to be identified.

Longer checksums have been developed. SHA-2 takes up to 64 bytes. I'm feeling
generous today. Let's assume a future even better checksum takes 128 bytes.


# Postulate

**All we know, all we'll ever know, source code, text in books,
pictures, movies, can be identified using less than 128 bytes.**

