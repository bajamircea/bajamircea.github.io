---
layout: post
title: 'Remove a folder - twice'
categories: coding cpp
---

How hard can it be to remove a folder in Windows? Part 4: random errors on
empty folder


# Random errors on empty folder

So it's all good, we wrote our function to enumerate and recursively delete
sub-folders and files, handled errors such as permission denied and read-only
files and still: from time to time there are random errors with the error
`ERROR_DIR_NOT_EMPTY`. Investigation shows that after the error occurred the
directory **is empty** actually and can be deleted manually. What's happening?


# Stackoverflow

One of the most relevant searches leads to a Stackoverflow question titled
[Batch - Getting “The directory is not empty” on rmdir command][so]:

![Question](/assets/2019-09-28-remove-folder-part-4-twice/so_question.png)

And the answer is ... **do it twice**:

![Answer 1](/assets/2019-09-28-remove-folder-part-4-twice/so_answer.png)

And the even better answer (with more votes) is ... **do it twice, but ignore
errors and don't log the first time**:

![Answer 2](/assets/2019-09-28-remove-folder-part-4-twice/so_answer2.png)

That can't be true, can it?


# What's happening

Windows has background services like the search indexer.

The purpose of this service is to allow a user to quickly find documents. A
user can do a search in Windows Explorer and a list of documents containing
those words can quickly be retrieved. This is achieved by the search indexer
monitoring the filesystem for changes. When a change is detected, it waits a
bit, to allow documents to be saved, then it tries to open the files where
change was detected, tries to extract text content and update an index that is
used for fast retrieval of search results. To minimize interactions with
applications the search indexer opens files with flags that maximize sharing
including `FILE_SHARE_DELETE`.

When we delete a file, if the file is also opened by another process with
`FILE_SHARE_DELETE`, the function `DeleteFileW` reports success, but in reality
the file is not yet deleted, it will be deleted when all the handles get
closed. If that does not happen by the time we try to delete the parent folder,
we get the error `ERROR_DIR_NOT_EMPTY` from `RemoveDirectoryW`.

What we see here is a consistency problem typical for distributed systems,
except that we're inside a single physical system with multiple threads. One
way to look at it is that with regards to the question 'does a file exist?'
there are multiple answers:
- There is the actual, deep, origin, answer checked by functions such as
  `RemoveDirectoryW` and `CreateFileW` (which fails with `ERROR_ACCESS_DENIED`
  when creating a file on top of anther not deleted yet)
- There is the shortcut, shallow answer checked by functions like
  `GetFileAttributesExW` (used by `std::filesystem::exists`) and `Find...`
  functions (used by `std::filesystem::directory_iterator`) which will not see
  a file that is marked for delete, but not yet really deleted.


# Solution

The solution looks silly: recursively delete, on errors wait a bit and retry
once more. The reason it works is that like many other consistency problems is
solved by eventual consistency.

You're more likely to see this problem when deleting folders with many files
and sub-folders. When deleting a small folder with a few files, by the time the
search indexer wakes up the deletion completed.

It is important to continue on errors and try to delete as many files as
possible. Otherwise if we stop on the first error, many files are left behind,
and the at second attempt there is time again for the search indexer to wake up
and catch up. And it has a good chance to catch up because it's a bit like
driving behind a snow plough: while we slowly delete files (the snow plough),
the search indexer moves from one file to the next remaining file (driving
behind the snow plough).

The same issue can happen with other applications, it's not limited to the
search indexer.

[so]: https://stackoverflow.com/questions/22948189/batch-getting-the-directory-is-not-empty-on-rmdir-command

