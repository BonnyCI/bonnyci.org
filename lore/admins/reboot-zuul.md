---
name: rebooting zuul
layout: default
permalink: /lore/admins/reboot-zuul/
---

# Rebooting Zuul

## Overview

Periodically, Zuul will need to be restarted, whether to pick up new changes or even routine system maintenance.  To do so, you will first need to connect to the zuul node(s) by using the bastion as a jump host.  Currently, one would need to access the nodepool instance in the same manner in order to delete the current running images (because of <https://github.com/BonnyCI/projman/issues/102>).

## Connect to zuul nodes and restart

Restaring zuul involves restarting three services, namely zuul-server, zuul-launcher, and zuul-merger.  Currently, zuul-merger is run on a seperate host, so we will need to connect to two different machines to completely restart zuul.  From the bastion, use the shortcut to connect to these hosts.

```text
user@bastion$ zuul
```

Once connected, restart the zuul-server and zuul-launcher services.

```text
ubuntu@zuul:~$ sudo systemctl restart zuul-server.service zuul-launcher.service
```

Then connect to merger01

```text
user@bastion$ merger01
```

and restart zuul-merger

```text
ubuntu@merger01:~$ sudo systemctl restart zuul-merger.service
```

## Connect to nodepool

From the bastion, use the nodepool shortcut to connect.

```text
user@bastion$ nodepool
```

Next, become the nodepool user and load the nodepool virtualenv.

```text
ubuntu@nodepool$ sudo su nodepool
nodepool@nodepool$ source /opt/venvs/nodepool/bin/activate
```

## Delete the current instances

Use `nodepool list` to get a list of current nodes.  You will need the ID to delete the ready and hoist nodes.

```text
(nodepool) nodepool@nodepool:/home/ubuntu$ nodepool list
+-----+----------+------+---------------+--------+---------+---------------------------+---------------------------+--------------------------------------+--------------+-------+-------------+---------+
| ID  | Provider | AZ   | Label         | Target | Manager | Hostname                  | NodeName                  | Server ID                            | IP           | State | Age         | Comment |
+-----+----------+------+---------------+--------+---------+---------------------------+---------------------------+--------------------------------------+--------------+-------+-------------+---------+
| 361 | cicloud  | None | ubuntu-hoist  | zuul   | zuul    | ubuntu-hoist-cicloud-361  | ubuntu-hoist-cicloud-361  | 00ced614-3fec-4eb9-95c5-8c77d0cd32e5 | 192.168.0.66 | ready | 00:00:24:05 | None    |
| 359 | cicloud  | None | ubuntu-xenial | zuul   | zuul    | ubuntu-xenial-cicloud-359 | ubuntu-xenial-cicloud-359 | 4d3f7503-64f0-4c6b-8066-66ec64cace2b | 192.168.0.64 | ready | 00:00:25:03 | None    |
| 360 | cicloud  | None | ubuntu-xenial | zuul   | zuul    | ubuntu-xenial-cicloud-360 | ubuntu-xenial-cicloud-360 | bca6c0e6-e1a0-4894-a550-ef1fef302819 | 192.168.0.65 | ready | 00:00:25:02 | None    |
+-----+----------+------+---------------+--------+---------+---------------------------+---------------------------+--------------------------------------+--------------+-------+-------------+---------+
```

Delete the current ready nodes

```text
(nodepool) nodepool@nodepool:/home/ubuntu$ nodepool delete 359
+-----+----------+------+---------------+--------+---------+---------------------------+---------------------------+--------------------------------------+--------------+--------+-------------+---------+
| ID  | Provider | AZ   | Label         | Target | Manager | Hostname                  | NodeName                  | Server ID                            | IP           | State  | Age         | Comment |
+-----+----------+------+---------------+--------+---------+---------------------------+---------------------------+--------------------------------------+--------------+--------+-------------+---------+
| 359 | cicloud  | None | ubuntu-xenial | zuul   | zuul    | ubuntu-xenial-cicloud-359 | ubuntu-xenial-cicloud-359 | 4d3f7503-64f0-4c6b-8066-66ec64cace2b | 192.168.0.64 | delete | 00:00:00:00 | None    |
+-----+----------+------+---------------+--------+---------+---------------------------+---------------------------+--------------------------------------+--------------+--------+-------------+---------+
(nodepool) nodepool@nodepool:/home/ubuntu$ nodepool delete 360
+-----+----------+------+---------------+--------+---------+---------------------------+---------------------------+--------------------------------------+--------------+--------+-------------+---------+
| ID  | Provider | AZ   | Label         | Target | Manager | Hostname                  | NodeName                  | Server ID                            | IP           | State  | Age         | Comment |
+-----+----------+------+---------------+--------+---------+---------------------------+---------------------------+--------------------------------------+--------------+--------+-------------+---------+
| 360 | cicloud  | None | ubuntu-xenial | zuul   | zuul    | ubuntu-xenial-cicloud-360 | ubuntu-xenial-cicloud-360 | bca6c0e6-e1a0-4894-a550-ef1fef302819 | 192.168.0.65 | delete | 00:00:00:00 | None    |
+-----+----------+------+---------------+--------+---------+---------------------------+---------------------------+--------------------------------------+--------------+--------+-------------+---------+
```

And then delete the hoist node:

```text
(nodepool) nodepool@nodepool:/home/ubuntu$ nodepool delete 361
+-----+----------+------+--------------+--------+---------+--------------------------+--------------------------+--------------------------------------+--------------+--------+-------------+---------+
| ID  | Provider | AZ   | Label        | Target | Manager | Hostname                 | NodeName                 | Server ID                            | IP           | State  | Age         | Comment |
+-----+----------+------+--------------+--------+---------+--------------------------+--------------------------+--------------------------------------+--------------+--------+-------------+---------+
| 361 | cicloud  | None | ubuntu-hoist | zuul   | zuul    | ubuntu-hoist-cicloud-361 | ubuntu-hoist-cicloud-361 | 00ced614-3fec-4eb9-95c5-8c77d0cd32e5 | 192.168.0.66 | delete | 00:00:00:00 | None    |
+-----+----------+------+--------------+--------+---------+--------------------------+--------------------------+--------------------------------------+--------------+--------+-------------+---------+
```

## Epilogue

It would now be prudent to hang around on the nodepool node and watch `nodepool list` to make sure nodepool spins up new hosts to replace the deleted ones.
