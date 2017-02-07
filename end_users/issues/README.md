---
name: issues
layout: default
permalink: /lore/end_users/issues/
---

# Issues

## Table of Contents

* [Bug Reports](#bug-reports)
  * [Bug Report Requirements](#bug-report-requirements)
  * [Bug Lifecycle](#bug-lifecycle)
* [Feature Requests](#feature-requests)
  * [Feature Request Requirements](#feature-request-requirements)
  * [Feature Request Lifecycle](#feature-request-lifecycle)

## Bug Reports

If you encounter an issue which you think is a bug, please submit it to the [projman issue tracker](https://github.com/BonnyCI/projman/issues). Make sure that a similar bug has not already been filed, and post on that bug's issue conversation if it has.  The bug report will be reviewed and may be forwarded to an appropriate BonnyCI subrepository.

### Bug Report Requirements

* A descriptive title. Use keywords so others can find your bug to avoid duplicates and improve its visibility.
* Limited to one bug. If you have another bug to report, please raise a separate issue.
* Links to your project's:
  * relevant BonnyCI logs
  * BonnyCI configuration file, `.bonnyci`
  * Any other miscellaneous scripts that BonnyCI might be kicking off.
* The expected result or output that BonnyCI will produce.
* The actual result or output that BonnyCI is currently producing.
* The following details about your environment:
  * BonnyCI version or latest SHA if you are running from source.
  * Any tools you may be installing that are relevant to the issue (ex: if BonnyCI is running a linter, include a link to this linter).
  * The primary language(s) of your project.
* The red `bug` label.
* Please do not add a milestone label. If deemed necessary, this will be added by the BonnyCI Admin team.

The BonnyCI admin team will be alerted after the bug report is submitted, and a team member will respond. Further clarification or details may be required depending on the situation.

### Bug Lifecycle

1. New bug is filed; awaiting review.
2. Triaged in bug review and assigned to a developer.
3. Developer begins working on it -- bug is tagged `fix_in_progress`.
4. Developer opens pull request with a fix, which must be reviewed and tested -- a link to the pull request appears in the bug's activity stream.
5. Pull request is merged, and the bug's filer is pinged to verify that it's fixed -- bug is tagged `fixed_but_not_closed`.
6. Filer agrees that it's fixed -- bug is closed, and its milestone is set to the release the fix landed in.

## Feature Requests

If you wish for a feature to be added to BonnyCI, please submit it to the [projman issue tracker](https://github.com/BonnyCI/projman/issues). Make sure that a similar feature request has not already been filed, and post on that feature request's issue conversation if it has. The feature request will be reviewed and added to a milestone if it is deemed beneficial to the project.

### Feature Request Requirements

* A descriptive title. Use keywords so others can find your feature request to avoid duplicates and improve its visibility.
* Limited to one feature. If you have another feature to request, please raise a separate issue.
* Short and precise requirements such as "BonnyCI support for Zuul v3". If the feature request has multiple moving parts, it may be transferred to an EPIC that is broken down into smaller feature additions.
* A short explanation (2-3 sentences) of why you think the feature will be beneficial to the long-term health of the project.
* The blue `enhancement` label available in the issue tracker.
* Please do not add a milestone label. If deemed necessary, this will be added by the BonnyCI Admin team.

### Feature Request Lifecycle

1. New feature request is filed; awaiting review.
2. Triaged in backlog grooming and assigned to a developer.
3. Developer begins working on it -- feature request is tagged `feature_in_progress`.
4. Developer opens pull request, which must be reviewed and tested -- a link to the pull request appears in the feature request's activity stream.
5. Pull request is merged, and the feature request's filer is pinged to verify that the desired functionality is present -- feature request is tagged `fixed_but_not_closed`.
6. Filer agrees that it's fixed -- feature request is closed, and its milestone is set to the release the fix landed in.
