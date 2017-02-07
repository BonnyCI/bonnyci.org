---
name: architecture
layout: default
---

# Architecture

## Table of Contents

* [Components](#components)
* [Connection Diagrams](#connection-diagrams)

## Components

The BonnyCI system is made up of the following components:

* [Bastion](#bastion)
* [Zuul](#zuul)
  * [Server](#zuul-server)
  * [Launcher](#zuul-launcher)
  * [Merger](#zuul-merger)
  * [Web App](#zuul-web-app)
* [Nodepool](#nodepool)
  * [Server](#nodepool-server)
  * [Builder](#nodepool-builder)
  * [Launcher](#nodepool-launcher)
  * [Deleter](#nodepool-deleter)
* [Logs host](#logs-host)

### Bastion

The bastion host has access to all other hosts. Admins can use it as a jump host to log in to other hosts, and it also runs ansible in cron.

### Zuul

Zuul is the central component. It determines what jobs to run and when to run them, it constructs the specific git object(s) to test, and it reports the results back to the client. For more information, refer to [zuul's documentation](http://docs.openstack.org/infra/zuul/).

#### Zuul Server

The zuul server process runs on the zuul host and is responsible for the list of jobs, list of projects, and job pipelines. The pipelines manage job ordering and scheduling. They are configured with source connections for incoming events, triggers to determine which events start pipeline processing, requirements to determine which changes are eligible to enter the pipeline, and reporters to describe the actions to take once a job completes.

The zuul server communicates with the other zuul components using gearman. It communicates with nodepool using gearman, zookeeper, and zeromq.

#### Zuul Merger

The zuul merger is a gearman client that constructs the specific git refs to run tests against.

We currently run a single zuul merger on the zuul host, but this component is horizontally-scalable and new instances should be run on separate small hosts. Once a zuul merger connects to the zuul server via gearman, it will immediately begin handling requests.

Since the zuul server does not control which merger performs a given merge, all test slaves must have access to all mergers to fetch the constructed git refs.

#### Zuul Launcher

The zuul launcher is a gearman client that uses ansible to run the specified test job on the specified type of test slave. It populates several environment variables in the test environment so that the test can know what git ref to fetch and what url to fetch it from. The zuul-cloner tool can be used to checkout the correct version of multiple projects based on these environment variables.

We currently run a single zuul launcher on the zuul host, but this component is horizontally-scalable and new instances should be run on separate small hosts. Once a zuul launcher connects to the zuul server via gearman, it will immediately begin handling requests.

Since the zuul server does not control which launcher will run a specific job, all launchers must have access to all test slaves.

#### Zuul Web App

The zuul web app is a very basic web server that serves /status.json, a json object that describes the current state of all pipelines. You can use the script zuul-changes.py from zuul's tools/ directory to translate the json object into shell commands that will restore the current state of the zuul pipelines -- useful for restarting the zuul server, which loses pipeline state.

### Nodepool

Nodepool manages a dynamic pool of Openstack VMs. It can be configured with multiple image types, label types, and VM providers. The images are built using diskimage-builder. A label may contain more than one image (referred to as subnodes), and a separate resource pool is maintained for each label. A provider is an Openstack cloud capable of booting the specified label(s). For more information, refer to [nodepool's documentation](http://docs.openstack.org/infra/nodepool/).

#### Nodepool Server

By default the nodepool server handles all aspects of managing the resources; but the builder, launcher, and deleter can be run in separate processes rather than separate threads for scaling and performance. Regardless, the nodepool server will determine node demand, and will control when to boot nodes, delete nodes, and build images. The demand is determined by connecting to zuul via gearman.

Nodepool receives job-completion messages via zeromq -- a relic left over from using Jenkins with a zeromq plugin. Not all jobs send the zeromq event to trigger node deletion, and zuul's default is to not send the message, but we have enabled it globally in the parametr-function python script.

#### Nodepool Builder

The builder uses diskimage-builder to create images and upload them to glance.

#### Nodepool Launcher

The launcher boots VMs and registers them as available test slaves.

#### Nodepool Deleter

The deleter deletes VMs after they have finished running their assigned job.

### Logs Host

A public web server serving log files as static content. All jobs should be configured to use a publisher to scp test output to this host. After test completion zuul will set the GitHub status url to the parent directory for all jobs for the test run, and on test failure zuul will also comment with a link to the log path for the failing job(s). Anyone on the internet can access the logs after they are published.

We have not yet determined a retention policy.

## Connection Diagrams

### Zuul Connections

```text
+--------------+                                 +------------------+
|              |         web browser             |                  |
|     User     +-------------------------------->|    Logs Host     |
|              |                                 |                  |
+------+-------+                                 +------------------+
       |                                                        ^
       |web browser                                             |
       |                                                        |scp
       v                                                        |
+--------------+   query     +----------------+         +-------+-----------+
|              |<------------+                |   gear  |                   |
|   GitHub     |             |  Zuul Server   |<--------+  Zuul Launcher    |
|              +------------>|                |         |                   |
+--------------+  webhook    +----------------+         +----------------+--+
                              ^  ^          ^                            |
                              |  |          |                            |ansible
                              |  |          |gear                        |
                              |  |          |                            v
                        zeromq|  |gear    +-+-------------+        +----------------+
                              |  |        |               |   git  |                |
                      +-------+--+-+      |  Zuul Merger  |<-------+  Openstack VM  |
                      |            |      |               |        |                |
                      |  Nodepool  |      +---------------+        +----------------+
                      |            |
                      +------------+

```

### Nodepool Connections

```text
                                                         +------------+          +-----------------+
                                                         |            |          |                 |
                                                         |  Nodepool  |  http    |    Openstack    |
                                                    +----+  Builder   +--------->|    Glance       |
                                                    |    |            |          |                 |
                                                    |    |            |          |                 |
                                                    |    +------------+          +-----------------+
                                                    |
                                                    |
                                                    |
+---------+             +------------+              |    +------------+
|         |   gearman   |            |              |    |            |
|         |<------------+  Nodepool  |   zookeeper  |    |  Nodepool  |
|  Zuul   |             |   Server   |<-------------+----+  Launcher  |
|         |<------------+            |              |    |            |  http    +-----------------+
|         |   zeromq    |            |              |    |            +--------->|                 |
+---------+             +------------+              |    +------------+          |                 |
                                                    |                            |    Openstack    |
                                                    |                            |    Nova         |
                                                    |                            |                 |
                                                    |    +------------+  http    |                 |
                                                    |    |            +--------->|                 |
                                                    |    |  Nodepool  |          +-----------------+
                                                    +----+  Deleter   |
                                                         |            |
                                                         |            |
                                                         +------------+

```

## Sequence Diagrams

Coming soon...
