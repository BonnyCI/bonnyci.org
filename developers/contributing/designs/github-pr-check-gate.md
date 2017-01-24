# Check and Gating Pipeline Management with Zuul and GitHub

## Problem Statement

The pipelines managed by Zuul are dependent upon events occurring in GitHub. Currently the pipelines can only be triggered through manual intervention and branch management requires a manual review of the pipeline results. Communication channels should be established between these two separate systems so that GitHub events automatically trigger the Zuul pipelines and appropriate branch management tasks are completed based on those results.

## Overview

A Continuous Integration Pipeline is the series of steps a change in version control goes through as it passes through the CI system. BonnyCI uses Zuul to define and manage its CI pipelines, integrating with GitHub using Webhooks. For more information about Zuul and Github Webhooks, see the corresponding sections in this document.

BonnyCI defines two Pipelines, the Check Pipeline and the Gate Pipeline. The Check Pipeline is an Independent Pipeline that manages the testing of a single Github Pull Request. The Gating Pipeline is a Dependent Pipeline that tests a queue of changes and merges them upon successful completion.

This specification defines the state management between Github and the BonnyCI Check and Gate Pipelines. Zuul provides status updates to GitHub as the Pull Request travels through each pipeline and posts review feedback once it reaches the end of each pipeline.

### Zuul

Zuul is a project gating system that grew out of the OpenStack community. While originally built to work with Gerrit, the BonnyCI project seeks to integrate Zuul with GitHub. For more information about Zuul, see (link to Zuul docs).

### GitHub Webhooks

The repository owner configures webhooks in their repository settings to subscribe an external service to specific types of events. When that type of event is triggered, GitHub sends an HTTP POST payload to the webhook's configured URL. For more information about configuring webhooks for BonnyCI see (insert link to resource here).

## Check Pipeline

The two integration points between GitHub and Zuul for the Check Pipeline are the initiation of the Check Pipeline and the completion of the Check Pipeline.

### Triggering the Check Pipeline

The BonnyCI Zuul server is subscribed to specific repository events through the webhook defined in the GitHub repository. The Zuul server initiates the Check Pipeline when it receives a GitHub event payload for the following events:

* A new pull request is created (`pr-open`)
* An existing pull request is modified (`pr-change`)
* A closed pull request is re-opened (`pr-reopen`)
* A comment is posted to an existing pull request with the text "recheck" (`pr-comment`)

Zuul posts a new status for the commit at the tip of the Pull Request via the GitHub API using the information provided in the event payload. Zuul sets the commit's state to `pending` and labels it `check_github`.

Zuul checks if it has previously posted a review on this Pull request and makes a call to the Github API to dismiss that review.

### Check Pipeline Results

Once the jobs in the Check Pipeline have completed, Zuul posts the following using the GitHub API:

1. a new status for the commit to success or fail, depending on the outcome of the jobs
1. a new Pull Request comment with a link to the logs URL from the job(s) executions

#### Pass

On success, Zuul posts a Pull Request Review set to `approve`.

#### Fail

On failure, Zuul posts a Pull Request Review set to `request_changes`. Zuul also posts a Pull Request Comment stating the build failed, a list of links to logs from each stage of Pipeline, the status of each job in the Pipeline (FAILED or SUCCEEDED), and how long that job took to run.

Example:

`Build failed.`
`http://logs.bonnyci.com/check_github/BonnyCI/hoist/61/1484860623.13/ubuntu-hoist : FAILURE in 4m 15s`

## Gate Pipeline

The Gate Pipeline is the series of jobs that occur after a Pull Request has passed its Check Pipeline. The Gate Pipeline is a queue of Pull Requests that can be tested together. Zuul builds the Gate Pipeline queue based on when Pull Requests pass their respective Check Pipelines and what jobs they share in the pipeline[1]. When a Pull Request passes the Gate Pipeline, it is automatically merged into the master branch. Therefore, the requirements for triggering the Gate Pipeline are more stringent than they are for the Check Pipeline.

### Triggering the Gate Pipeline

The Zuul server initiates the Gate Pipeline when it receives a GitHub event payload for the following events:

* a new Pull Request Review set to approve (`pull_request_review`)
* a new Pull Request Comment with the text "recheck" (`pr-comment`)

Zuul examines the state of the Pull Request to determine if it meets the following requirements:

* One Pull Request set to `approve` from the CI user indicating the Pull Request has successfully completed the Check Pipeline
* At least one Pull Request set to `approve` from a user with write access to the repository
* Zero Pull Requests set to `request_changes` from any user with write access to the repository

Zuul posts a new status for the commit at the tip of the Pull Request via the GitHub API using the information provided in the event payload. Zuul sets the commit's state to `pending` and labels it `gate_github`.

### Gate Pipeline Results

Once the jobs in the Gate Pipeline have completed, Zuul posts the following using the GitHub API:

1. a new status for the commit set to success or fail, depending on the outcome of the jobs
1. a new Pull Request comment with a link to the logs URL from the job(s) executions

#### Passing the Gate Pipeline

1. Zuul posts a new status for the commit set to success
1. Zuul posts a new Pull Request comment indicating success, (with a link to the logs URL from the job(s) executions)??
1. Zuul merges the Pull Request by making a call to the GitHub API

#### Failing the Gate Pipeline

1. Zuul posts a new status for the commit set to failure
1. Zuul posts a new Pull Request comment indicating the merge failed, (with a link to the logs URL from the job(s) executions)??

## Footnotes

[1] When Pull Request A passes its Check Pipeline, it starts its Gate Pipeline. Pull Request B passes its Check Pipeline while Pull Request A is still travelling through the Gate Pipeline. For overlapping jobs, Zuul creates a new branch and rebases the commits in Pull Request B on top of the changes in Pull Request A. Zull then runs the overlapping jobs in the pipeline only once for both A and B together. For more information on Zuul gating, see (...)

