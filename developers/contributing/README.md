# Contributing

## Table of Contents
- [BonnyCI Workflow](#bonnyci-workflow)
- [Commits](#commits)
  - [Commit Message](#commit-message)
    - [Sign-off](#sign-off)
- [Pull Requests](#pull-requests)

## BonnyCI Workflow
We use the [GitHub flow](https://guides.github.com/introduction/flow/) for code changes.

## Commits
Changes should include small commits that produce a functional tree. Doing so helps keep the repository history clear and simple to bisect.

### Commit Message
Please keep commit messages concise and informative. If the commit relates to an open issue, please include a line in the commit message such as `Fixes #XXX`. When in doubt, follow [this guide](http://chris.beams.io/posts/git-commit/) on writing commit messages.

#### Sign-off
To improve tracking of who did what, all commits must have a "sign-off". This sign-off is a line at the end of the commit message certifying that you have read and agreed to the [Developers' Agreement](DEVELOPER_AGREEMENT.md). Certify that you agree by adding a sign-off to your commit (**NOTE:** use your real name, please):

```
Signed-off-by: Random J Developer <random@developer.example.org>
```

This is doable via the `-s` flag for `git-commit`:

```shell
$ git add foo
$ git commit -s
```

## Pull Requests
Pull requests start and frame a conversation. As such, it is not necessary to ask permission (or open an issue, or write a spec/blueprint) before presenting code.


Anyone may review or comment on pull requests, but a member of the BonnyCI Captains team must approve it before merging.


If a pull request is a work in progress, please start the title with `[WIP]`. It is not necessary to include `[WIP]` in commit messages, but if you do, please remove it before it gets merged.
