---
name: holding a node
layout: default
---

# Holding a Node

## Table of Contents

* [Overview](#overview)
* [Using the Bastion as a Jump Host](#using-the-bastion-as-a-jump-host)
* [Running Nodepool Commands](#running-nodepool-commands)
* [Holding a Nodepool Node](#holding-a-nodepool-node)

## Overview

In some cases it is useful to log in to a nodepool node to debug a problem. You can either target a specific node currently running a job, or you can target a node that has not yet been assigned a job to inspect the base image. In either case, you will need to first access nodepool by using the bastion as a jump host. Then you will need to source the nodepool virtualenv to access the nodepool command. Finally, you will need to hold the chosen node and log into it.

## Using the Bastion as a Jump Host

As an admin, you should have a user account on the bastion host. Once connected, become the cideploy user to connect to other hosts. In this case, we will connect to nodepool.

```text
user@bastion$ sudo -i -u cideploy
cideploy@bastion$ ssh ubuntu@nodepool
```

## Running Nodepool Commands

Once on the nodepool host, become the nodepool user and load the nodepool virtualenv. Run `nodepool list` to get a list of current nodes.

```text
ubuntu@nodepool$ sudo -i -u nodepool
nodepool@nodepool$ source /opt/venvs/nodepool/bin/activate
(nodepool) nodepool@nodepool$ nodepool list
+-----+----------+------+---------------+--------+---------+---------------------------+---------------------------+--------------------------------------+---------------+-------+-------------+---------+
| ID  | Provider | AZ   | Label         | Target | Manager | Hostname                  | NodeName                  | Server ID                            | IP            | State | Age         | Comment |
+-----+----------+------+---------------+--------+---------+---------------------------+---------------------------+--------------------------------------+---------------+-------+-------------+---------+
| 248 | cicloud  | None | ubuntu-xenial | zuul   | zuul    | ubuntu-xenial-cicloud-248 | ubuntu-xenial-cicloud-248 | a7a18e16-0284-4122-930e-81e3af03af82 | 192.168.3.241 | ready | 00:00:21:21 | None    |
+-----+----------+------+---------------+--------+---------+---------------------------+---------------------------+--------------------------------------+---------------+-------+-------------+---------+
```

## Holding a Nodepool Node

If you are targeting a specific node currently running a test, lookup the ID based on the hostname provided at the begginning of the test output. You will need to be quick in order to hold the node before the test completes and the node is subsequently deleted.

If you are targeting a generic node, choose any ID for a node in the `ready` state.

Once you hold the node you can ssh to the bonnyci user. Make sure to not save any known host info because these IPs are constantly recycled.

```text
(nodepool) nodepool@nodepool$ nodepool hold 248
+-----+----------+------+---------------+--------+---------+---------------------------+---------------------------+--------------------------------------+---------------+-------+-------------+---------+
| ID  | Provider | AZ   | Label         | Target | Manager | Hostname                  | NodeName                  | Server ID                            | IP            | State | Age         | Comment |
+-----+----------+------+---------------+--------+---------+---------------------------+---------------------------+--------------------------------------+---------------+-------+-------------+---------+
| 248 | cicloud  | None | ubuntu-xenial | zuul   | zuul    | ubuntu-xenial-cicloud-248 | ubuntu-xenial-cicloud-248 | a7a18e16-0284-4122-930e-81e3af03af82 | 192.168.3.241 | hold  | 00:00:00:00 | None    |
+-----+----------+------+---------------+--------+---------+---------------------------+---------------------------+--------------------------------------+---------------+-------+-------------+---------+
(nodepool) nodepool@nodepool$ ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null bonnyci@192.168.3.241
bonnyci@ubuntu$  # inspect the node
```

After you are done make sure to delete the held node, it will not be automatically deleted.

```text
(nodepool) nodepool@nodepool$ nodepool delete 248
+-----+----------+------+---------------+--------+---------+---------------------------+---------------------------+--------------------------------------+---------------+--------+-------------+---------+
| ID  | Provider | AZ   | Label         | Target | Manager | Hostname                  | NodeName                  | Server ID                            | IP            | State  | Age         | Comment |
+-----+----------+------+---------------+--------+---------+---------------------------+---------------------------+--------------------------------------+---------------+--------+-------------+---------+
| 248 | cicloud  | None | ubuntu-xenial | zuul   | zuul    | ubuntu-xenial-cicloud-248 | ubuntu-xenial-cicloud-248 | a7a18e16-0284-4122-930e-81e3af03af82 | 192.168.3.241 | delete | 00:00:00:00 | None    |
+-----+----------+------+---------------+--------+---------+---------------------------+---------------------------+--------------------------------------+---------------+--------+-------------+---------+
```
