---
layout: post
title: 'Remove a folder - errors'
categories: coding cpp
---

How hard can it be to remove a folder in Windows? Part 3: errors


# Handling

Now that we've established that there is no suitable standard function and we
need to roll out our own, and we figured out how to enumerate folders, we can
turn the attention to handling errors.

Even if we use `std::filesystem` functions, there are many possible errors,
some of which are unintuitive e.g. what if `operator++` fails for a
`directory_iterator`?

One reason to roll out our own is to continue in face of errors. So for example
if we fail to delete a file we would continue trying to delete the other file
in a folder.

If we encounter multiple errors which one to return? It makes sense to return
the first one because often the errors cascade for example if we fail to delete
a file with an 'access denied' error, deleting the parent folders will also fail
with a 'folder not empty' error, and the first error is more useful.

Logging will also be useful when we continue in the face of errors.


# Library quality of implementation issues

While investigating the Microsoft implementation of functions in the
`std::experimental::filesystem` namespace it became clear that it has issues.

For example the function `exists` takes a path and returns a `bool` indicating
if the path exists on the file system. There should be three possible outcomes:
- yes, path exists: function returns `true`
- no, path does not exist: function returns `false`
- error, unknown if path exists or not: depending on the overload, the function
  throws or sets `error_code`

The faulty Microsoft implementation maps the error case to the 'path does not
exist' case.

In other cases functions that are meant to set an `error_code` use functions
that might throw on errors such as the constructor of `directory_iterator`
taking a path but no `error_code`.

Also often the original error code is lost and mapped to a generic error.

In near/future versions it's likely most of these issues will be addressed by
Microsoft.


# Permissions

A common reason for failure is the lack of access permissions. In our case it
turns out it's OK to require the running user to be elevated, running as a
system administrator. The program then can check early that it meets this
condition (or fail and display a message).

Permissions can deny access even to an administrator, but an administrator can
enable privileges that can circumvent the normal permissions checks. This can
be done by manipulating the thread token.

All these checks and configurations take time to code, they require a thorough
understanding of the Windows security model entities.

The other downside is that there is no obvious code dependency between the code
that removes a folder and the code that checks and configures the thread token.
And yet the latter influences the success of removing the folder, and imposes
constraints such as one can't spun some thread and just call the code to remove
the folder. Constraints such as these are not obvious and error prone in large
code bases.


# Read only

Another common reason for failure are files marked read only. This is different
from the permissions, it refers file attributes, the `FILE_ATTRIBUTE_READONLY`
in particular. Deleting them on Windows fails with error 'access denied', which
might be confusing because I've just said that it's different from permissions.

Luckily by now we're in good position to handle this error. It turns out few
files tend to have this attribute set, so instead of pessimizing, we can
attempt to delete a file, and only if we have an error we check the attribute
and if set we unset it and retry.
