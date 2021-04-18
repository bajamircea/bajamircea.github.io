---
layout: post
title: "Branch stability basics"
categories: source code
---

A basic description of options for source code branch stability (with
references to git, but applies to other version control systems)


# Linear

This describes the simplest option: linear history in a single branch.

<div align="center">
{% include assets/2021-04-17-branch-stability/01-linear.svg %}
</div>

This would be the workflow of a repository with a single developer. They use a
single branch (e.g. `master`). The developer prepares files for a commit (e.g.
in the `index`/staging area for git). Usually those changes are speculative,
initially not of the same quality as the files on the main branch. Once the
tests pass, then the developer commits to the `master` branch, and optionally
pushes to a remote repository `origin`.

The advantage is that it creates an easy to understand linear history, but it
does not scale as more developers are added.


# Feature branches and merge up

One option is to create branches for work (e.g. `feature` branches), then merge
back into the main branch (e.g. `develop`).

<div align="center">
{% include assets/2021-04-17-branch-stability/02-feature.svg %}
</div>

The work branches are speculative to start with, but issues discovered during
testing of the work are fixed before merging into the main branch. The intent
is to keep the main branch more stable than a feature branch so that other
developers can pick the latest commit on the main branch as their feature
starting point.

If in the meantime the stable branch has other changes one option is to do a
merge. This is a "merge up" from the less stable branch to the more stable
branch. Some workflows create a dummy merge commit even if the stable branch
has no other changes (see `git merge --no-ff`)

After the merge the `feature` branch is abandoned. In git the branch is
deleted, which means that the label to the last commit is deleted, but the
commits are preserved.

In git there is also the issue of being able to track what commits were on the
stable line and that can be done merging in such a way that the first parent
was on the stable line (see `git log --first-parent`).

The issue with this approach is that the merge commit is different from the
both it's parents, so it does not automatically inherit the confidence that it
is a good, stable commit. E.g. at it's simplest the feature branch uses a
function that was deleted from the stable branch.

Therefore this results in one or more of the following trade-offs:
- Delay `push` to `origin` until tests pass, if the stable line changed, repeat
- `push` anyway, accept that the `develop` is not stable, handle/accept the
  impact on developer productivity
- Accept scalability issues, lower rate of commits to the stable line
- Reduce the amount/duration of tests
- Use a skilled, dedicated merger (e.g. Linus Torvalds for the Linux kernel) or
  automate merging after testing


# Merge down before merge up

One attempt to solve the merge issues into the stable line is to precede it
with a "merge down" from the stable line into the unstable line, so that the
merged changes can be tested.

<div align="center">
{% include assets/2021-04-17-branch-stability/04-merge-down.svg %}
</div>

This approach:
- Might work if there is not too much activity on the stable line, else you
  need to repeat the merged down and testing (or merge up anyway and accept
  loss of stability on the `develop` branch). You want the "merge up" to not
  have any code changes from what was tested, though in practice you'll still
  create a dummy commit for the "merge up" to be able to track changes on the
  stable line using first parent).
- Makes the history of changes harder to track. In particular if the `develop`
  line is not very stable, new issues that were introduced on the `develop`
  line get pulled into the feature (e.g. for this reason the Linux kernel
  workflow discourages "merge downs").
- Unless automated creates additional developer interruptions to check test
  results and progress with the merge steps.
- Has lower rate of commits to the stable line due to having to wait for tests
  to pass on the "merge down" commit.


# Rebase

One attempt to solve the history issues is to rebase/squash/replay the changes
in the feature branch as changes on the top of the latest change on the stable
line, test them, then merge with `--ff-only`, creating a linear history as we
had with a single branch.

<div align="center">
{% include assets/2021-04-17-branch-stability/05-rebase.svg %}
</div>

Otherwise it has about the same issues as the "merge down" approach.

# Release branch

This option accepts that the `develop` line is not stable enough for a release.

<div align="center">
{% include assets/2021-04-17-branch-stability/06-release-branch.svg %}
</div>

`release` branches are periodically taken where potential bugs are fixed, thus
creating a more stable branch. The fixes are usually merged back into the
develop line and the actual released commit is tagged instead creating a fixed
reference (branches in `git` are ever moving references to the last commit).

