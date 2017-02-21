An open source project's lifespan depends upon community participation and widespread adoption. Community participation depends on both long-term, dedicated community members and drive by contributions. Widespread adoption depends on a project's reputation for stability and its ability to evolve quickly in response to technology changes, user needs, or even security issues or critical bugs. Continous integration is a key component for this.

[ examples/use cases of projects that failed due to these factors ]

Frequency of community contribution depends on the ability to provide instant gratification. Drive-by's are more likely to drop an issue after a certain period of time, but quick engagement can get a one-off contributor more deeply involved. Contributors come and go so systems should be in place to prevent dependencies on individuals with the magical commit bit. Continous Integration provides a safety net for contributors and transparent code style expectations. A responsive CI pipeline provides immediate feedback on success or failure. Maintainers can focus on larger design and code quality issues when doing reviews. Small scope changes can be quickly approved and merged with confidence. The faster the CI pipeline, the faster the feedback loop resulting in greater community engagement.

To build a reputation for stability, a project needs a publicly visible track record. Potential users want a guarantee that the code works on their platform and for their use case. Continuous Integration that shows a record of build status and documented test cases provide this transparency. It should be easy to add additional test coverage when an issue is disovered that indicates a gap in coverage. When a security fix or other issue is merged, the scope of the fix and the requirements for it to pass CI are clearly visible, thus it is straightforward to assess if it is sufficient and therefore easy to guarantee. Changes can be tested via automation and results communicated at a rate that exceeds the abilities of individual developers. Multiple platforms that developers may not have access to can be targeted. Software can make smart decisions about how and when to run tests for multiple jobs in a fraction of the time it would take a human running the same processes on their local machine.

The advantages to using a hosted CI service for your project versus hosting your own are the same as hosting your own webserver or git server. If you're project is just starting out, at a minimum the CI service should provide [...]. Current CI services include [...]

[table of what the most popular CI services provide]

Unfortunately, the majority of CI services available today make a broad set of assumptions about the nature of your project. What if you're a special snowflake? Projects that require more resources or specialized functionality may end up hosting their own Jenkins farm or implementing a hybrid approach where a baseline of tests go through the hosted CI pipeline but additional tests are needed on a custom pipeline, probably maintained by the person who wrote it and you're screwed if they get hit by a bus.

[ example here ]

Why should you consider BonnyCI?

* Do you have concerns about the ability of current CI service tools to meet the current or projected demands of your community?
* Are you currently running automation through a mish-mash hybrid of CI services and self-hosted servers?
* Is your current CI service slowing your roll?

BonnyCI is a hosted Continuous Integration service for projects hosted on Github. As a continuous integration service, BonnyCI runs automated tests on target platforms per the configuration specified in a given project. Once complete, BonnyCI provides feedback on the tests result and performs branch management tasks, including merges, depending on the results of the tests run in the pipeline.

BonnyCI handles high demand, complex pipelines. Built on the infrastructure used to manage the OpenStack project pipeline, BonnyCI's core technology had to solve serious scaling problems in a huge Open Source community dealing with hundreds of commits per day. The BonnyCI team grew out of the OpenStack Infrastructure community, fueled by our passion for quality CI and the desire to fill the need for a high capacity CI solution for projects beyond Openstack.



