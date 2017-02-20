---
layout: page
title:  "Beta"
permalink: /beta/
show_header_link: true
categories:
  - bonnyci
tags:
  - zuul
  - ci
  - testing
  - gating
---

Avast! Welcome, and thanks for your interest in BonnyCI. It's about time
we publicly explain what BonnyCI is, and why it works the way it does.

The story begins with [OpenStack][os]. Early on in [OpenStack][os]'s
history, some of the developers identified a need for robust [Continuous
Integration][ci].

This included testing multiple projects together to ensure they interact
well. Developers who set this system up chose [Jenkins][j], and also
decided to pursue a path of gated pre-merge CI, requiring every commit
to pass the defined integration tests before landing.

This proved to be a good decision, as it kept all source repositories
more or less usable by the development community, which exploded in size
rapidly. However, this presented a problem.  Gated CI meant that every
commit from every project would need to run the entire test suite.

This introduces some problems that [OpenStack][os]'s development community
did not want to accept. Landing patches would be inherently slow, and
it would discourage adding test coverage. Even running the matrix of
different tests in parallel would mean that commits can land no faster
than the longest and most comprehensive test takes.

Why bother with each commit? In addition to the benefits for developers to
be on the same page and able to confidently start from a working place,
many [OpenStack][os] users embrace [Continuous Delivery][cd]. This means
any commit from any project might be deployed into a production cloud.

[OpenStack][os]'s solution to this problem is [Zuul][z]. [Zuul][z]
was created by Jim Blair and the [OpenStack][os] infrastructure team
to allow efficient automated gating of commits. It does this by taking
advantage of the massive parallelism possible with [IaaS clouds][iaas].

Jenkins has some capability like this too. One can use the [JClouds
plugin][jc] to have Jenkins spin up fresh cloud nodes on demand. The
difference is in ordering of gated commits.

If one decides to have Jenkins use the [JClouds plugin][jc] for gating,
the scenario works fine until a project gets larger in scale.

With a team of 5 contributors, the limitations of a simple solution
like Jenkins are fine. If there is a policy that anyone except a patch
author must review and approve a patch for landing, then you have a
4:1 ratio of patch writers to approvers. There's little danger that
approved patches will outnumber incoming patches, as long as tests are
kept short enough. So even if a reviewer approves 4 patches at once,
nobody is all that bothered that this takes 4 * *testduration* to land
all 4 commits. Jenkins will spin up one node at a time, run tests,
and merge code, and then do the same again, stacking each one on top
of master. If one fails, it will naturally be skipped, and life will go
on. If the tests take an hour to run, this takes 4 hours.

However, as the team grows, a problem arises. Lets say the team grows
to 10 contributors, and sticks with the one reviewer policy. Now the
potential for a clogged gate is much higher. It's likely a reviewer will
have many more patches available to them to approve. If a reviewer now
approves a patch from each of their fellow contributors, so 9 patches,
they will be facing _9 hours_ before they know if any of these patches
interact negatively with any of the others. This compounds as failures
happen. If the second patch to land introduces an API breakage in which
its tests pass, but many other new changes that rely on the old behavior
break, suddenly you may only land 1 patch in 9 hours.

While the [JClouds plugin][jc] helps with pre-approval checking
parallelism, it can do nothing with this problem.

This is why [Zuul][z] implements speculative futures. In the 9 patch
scenario above, [Zuul][z] will spin up _9_ cloud nodes all at once. It
will try to run a job for each potential future in the master branch. So
if the patches are numbered, it will run each of these futures in
parallel:

    A 1
    B 1+2
    C 1+2+3
    D 1+2+3+4
    E 1+2+3+4+5
    F 1+2+3+4+5+6
    G 1+2+3+4+5+6+7
    H 1+2+3+4+5+6+7+8
    I 1+2+3+4+5+6+7+8+9

If patch #2 introduces an API break that breaks #3 and #9, then This
will happen:

    (A) merges #1
    (B) merges #2
    (C) fails
    (D - I) are "reset" and their results are ignored by [Zuul][z]

Now (C) will be reported as a failure, and [Zuul][z] will try a new
scenario:

    AA 4
    BB 4+5
    CC 4+5+6
    DD 4+5+6+7
    EE 4+5+6+7+8
    FF 4+5+6+7+8+9

And this happens:

    (AA) merges #4
    (BB) merges #5
    (CC) merges #6
    (DD) merges #7
    (EE) merges #8
    (FF) fails

So, in the time span of _two_ test runs, we have found the two
bad interactions, and merged 7 patches that do work well all
together. Suddenly having hour long tests isn't such a huge problem.

Meanwhile in those two test runs, new patches have only been created from
known good working master branches, thus reinforcing good interactions
with approved code, allowing development to progress faster and reducing
accidental breakage. Even at the busiest time, usually just before
releases, [OpenStack][os] sees a very long gate, and exhaustion of its
100's of available VM capacity across many clouds. But it still doesn't
usually get worse than about 8 or 9 test runs to land many patches.

This becomes especially important when you want to start co-gating
projects.  In [OpenStack][os], we don't want to merge code to
[Keystone][k], the [OpenStack][os] Identity and Auth service, that
obviously breaks [Nova][n], the [OpenStack][os] Compute Service, and we
also don't want to land code in Nova that breaks [Cinder][c], the Block
Storage service.

By gating them together with a single integration test, we ensure that
a change to one service that might pass on its own functional test
suite does end up breaking due to deep issues only exposed by the way
another service uses it. This seems overbearing without [Zuul][z],
but once the time for the happy path is reduced due to parallelism,
cooperation between teams should increase, since now they have a single
shared space to test their relationship. There's no more finger pointing
and speculation, those project teams can read the code, read the logs,
and find the problems together.

These services are all developed by separate teams to cut down on
communication overhead and build on areas of expertise. As such, they
have well defined API's and they are able to be tested comprehensively
in isolation. However, while having good API boundaries is extremely
important, there are devils in the details that only show up when actual
tests are run and code is fully integrated with dependencies.

And that brings us to why we think BonnyCI is needed. More and more,
small, Open Source, well defined projects are created and shared
between various communities of developers. So while each project team
may be small, the relationships between them create a large aggregate
relationship.

The current method for testing like this is to create a massive matrix
of test combinations on both sides of dependencies. A nodeJS library
that wants to make sure they don't break a nodeJS app ends up having to
own tests for that app.

But we want to free your project from that. We want to allow you to
build integration pipelines that make sense for both sides of a project
dependency.  We want your community to be able to grow independently
without sacrificing quality and without wasting your time. And we don't
want you to have to learn all the things we've had to learn about running
an infrastructure for [Zuul][z].

So what's next? Well we're in the very early stages of creating BonnyCI,
a service to allow Github projects to harness the power of [Zuul][z].

Right now we are inviting project teams that are interested in trying
BonnyCI to have a chat with us about whether it makes sense to be an
early beta user.

So, if you are interested, please stay in contact with us. Watch this
space for future updates. If you want to join our closed beta, you can
email me personally (see below) or join us on Freenode IRC in #BonnyCI.

*Clint Byrum is a Cloud Architect at IBM, you can contact him
via Twitter: @SpamapS, or email [clint at fewbar dot com](mailto:clint at fewbar dot com)*

[os]: http://www.openstack.org/
[j]: http://www.jenkins.io/
[ci]: https://en.wikipedia.org/wiki/Continuous_integration
[cd]: https://en.wikipedia.org/wiki/Continuous_delivery
[k]: https://docs.openstack.org/developer/keystone/
[n]: https://docs.openstack.org/developer/nova/
[c]: https://docs.openstack.org/developer/cinder/
[jc]: https://wiki.jenkins-ci.org/display/JENKINS/JClouds+Plugin
[z]: http://docs.openstack.org/infra/zuul/
[iaas]: https://en.wikipedia.org/wiki/Cloud_computing#Infrastructure_as_a_service_.28IaaS.29
