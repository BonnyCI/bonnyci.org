# Setup

## Table of Contents

* [Merge Options](#merge-options)
  * [Setting the Correct Merge Option](#setting-the-correct-merge-option)

## Merge Options

Repositories that use BonnyCI should not use any merge strategy which changes the SHA of the commit. This is because [zuul](https://github.com/openstack-infra/zuul), the scheduler used in BonnyCI, will be thrown off by the change in SHA if multiple changes are running in the gate. BonnyCI tests the changes in the pull requests without altering them. To ensure that which is tested is what is merged, do not enable a merge strategy that would alter the pull request content upon merging it.

GitHub presents repository owners with 3 choices for what happens when merging a pull request:

* Create a merge commit
* Squash and merge
* Rebase and merge

For more on these options and what they mean, read the [documentation on merge methods](https://help.github.com/articles/about-merge-methods-on-github/) provided by GitHub.

### Setting the Correct Merge Option

In order for BonnyCI to function correctly, please only allow merge commits. From your repository's home page, navigate to the `Settings` tab. Scroll down to the section labeled `Merge button`, and ensure that it matches the following:

![Correct Merge Button Configuration](../../misc/images/mergebutton.png)
