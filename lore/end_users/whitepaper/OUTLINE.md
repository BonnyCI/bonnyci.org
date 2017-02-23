OUTLINE

Thesis:
Continuous Integration is a key component in building a successful open source project.
  
I. Open source project success depends on community participation and widespread adoption.

II. Community participation depends on both long-term, dedicated community members and drive by contributions.
 A. Instant Gratification drives participation
  1. Contributors lose interest after a certain window of time has passed.
  2. Feedback within that window feeds social engagement TODO: clarify this, look at sales engagement data
  3. Engaged users feel part of a community.
 B. Automation is a key factor in project participation
  1. Automation provides instant gratification because computers are faster than humans.
  2. Automation provides transparency
   a. Automation is structured language instructions to a computer on how to complete a task
   b. Assuming the instructions are available to all contributors and all contributors can comprehend the structured language, then any contributor could themselves follow the steps outlined in the automation program.
  3. Transparency reduces to Single Point of Failure
   a. Contributor churn is normal
    i. volunteers may lose interest or have life changes that limit free time
    ii. paid contributors, either by company or by the project foundation, may change employers or job function due to industry trends, life changes, or other factors
   b. Computer churn is not frequent
  4. Reducing single point of failure increases overall participation
   a. As long as all participants have access to the automation, no single person is necessary for automated tasks to be completed.
   b. Therefore as project churn happens, automations are not impacted, and the project continues
 C. Continous Integration is Automation. Therefore CI is a key factor in community participation.
   1. CI provides instant gratification
    a. Instant feedback on whether a change meets requirements
    b. Contributions from novices or drivebys are more likely to be simpler and smaller in scope
     i. once change has passed tests, easy for maintainer to look over change and merge with confidence 
    c. For larger changes, reviewers can focus on big picture and software quality issues knowing that CI will provide most syntax and style feedback.
    d. Reviewers can focus on changes that have passed tests without wasting time on ones that haven't; more incentive to do reviews knowing time won't be wasted on broken code
    e. Submitters can propose changes with confidence and reviewers can approve changes with confidence that code will be vetted prior to release
     i. lower risk -> lower stress -> more endorphins!
   2. CI provides transparency
    a. The steps to install the software on target platforms and to run the tests must be clearly defined in order for the automation tool to complete these steps.
    b. The platforms supported are clearly defined.
    c. The current state of what is being tested, when it was tested, what has passed, and what has failed on target platforms is clearly defined.
    d. Historical data about ^^ is available.
   3. CI reduces single point of failure
    a. Individual knowledge of how to install the software and run the tests is not necessary once it has been automated.
    b. Testing new changes in order to review them is not dependent on individual availability; it can happen any time day or night.
    c. Because CI typically requires work in progress to be hosted remotely, anyone can access a work in progress even if it has been abandoned by the original author.

III. Widespread adoption depends on a project's reputation for stability and its ability to be resilient to technology changes, user needs, or even security issues or critical bugs.
 A. publicly visible track record
  1. guarantee that the code works on their platform and for their use case
 B. easy to add additional test coverage when an issue is disovered that indicates a gap in coverage
  1. When a security fix or other issue is merged, the scope of the fix and the requirements for it to pass CI are clearly visible
 C. Thorough
  1. Multiple platforms that developers may not have access to can be targeted.
 D. Faster than people
 1. Software can make smart decisions about how and when to run tests for multiple jobs in a fraction of the time it would take a human running the same processes on their local machine

IV. Limitations of Current CI that impact ^^
 A. Hosting your own can hurt participation
  1. Increases single point of failure risk
  2. Lower instant gratification
   a. Contributor time spent on admin/maintenance means less time for code review
   b. greater risk for outages (how is the system monitored and what is the typical response time?)
 B. TODO: other flaws in other CI systems that BonnyCI addresses
   
V. BonnyCI features that fall in line with CI criteria above to increase participation
 A. Hosted
 B. 


 



