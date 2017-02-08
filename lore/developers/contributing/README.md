---
name: contributing
layout: default
permalink: /lore/developers/contributing/
---

# Contributing

## Table of Contents

* [BonnyCI Workflow](#bonnyci-workflow)
* [Commits](#commits)
  * [Commit Message](#commit-message)
    * [Sign-off](#sign-off)
* [Pull Requests](#pull-requests)
* [Design Documents](#design-documents)
* [Adding Projects](#adding-bonnyci-projects)

## BonnyCI Workflow

We use the [GitHub flow](https://guides.github.com/introduction/flow/) for code changes.

## Commits

Changes should include small commits that produce a functional tree. Doing so helps keep the repository history clear and simple to bisect.

### Commit Message

Please keep commit messages concise and informative. If the commit relates to an open issue, please include a line in the commit message such as `Fixes #XXX`. When in doubt, follow [this guide](http://chris.beams.io/posts/git-commit/) on writing commit messages.

#### Sign-off

To improve tracking of who did what, all commits must have a "sign-off". This sign-off is a line at the end of the commit message certifying that you have read and agreed to the [Developers' Agreement](DEVELOPER_AGREEMENT.txt). Certify that you agree by adding a sign-off to your commit (**NOTE:** use your real name, please):

```text
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

## Design Documents

Changes to BonnyCI should follow a design document. To propose a design document, open a pull requests to the [lore repository](https://github.com/BonnyCI/lore). BonnyCI contributors will review and debate the proposed document via pull request comments until the document is accepted. When the pull request is merged, development can begin.

Design documents exist in the [design documentation](designs/README.md) directory.

## Adding BonnyCI Projects

Adding a project to BonnyCI requires consensus from the BonnyCI admin team. The fastest way to reach out is to via [IRC](../README.md#irc). If a response is not given in a reasonable amount of time, feel free to raise a request at the [projman issue tracker](https://github.com/BonnyCI/projman) and the admin team will address it as soon as possible.

Requirements for new projects:

* A README containing some basic information. Instructions and complex information should be added to BonnyCI's documentation repo, [lore](https://github.com/BonnyCI/projman/issues).

* Basic automated testing:
  * A [signed-off-by test](https://github.com/BonnyCI/lore/blob/master/tests/signed-off-by-test.sh) is a requirement for all projects in BonnyCI. This can be easily implemented using [TravisCI](https://travis-ci.org/) via a [single configuration file](https://github.com/BonnyCI/lore/blob/master/.travis.yml). For more information, check out the [TravisCI documentation](https://docs.travis-ci.com/).
  * Syntax linters are highly recommended.
  * Unit tests and functional tests are highly recommended where applicable.

* If a repository uses TravisCI for any testing, a [TravisCI badge](https://docs.travis-ci.com/user/status-images/) should be embedded at the top of its README.

* At least a basic set of working content. BonnyCI will not add projects that are empty or barebones (e.g. only contain a README).
