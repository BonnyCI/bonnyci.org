---
name: network design
layout: default
---

# BonnyCI Cloud Network Design

## Problem Statement

Before we redeploy BonnyCI to our new cloud environment, we need to rethink our network design choices.  On our existing cloud, we are running all services and hosts on a single flat internal network.  This allows all hosts to communicate with one another, which is less than ideal considering some hosts (the nodepool slaves) will be executing arbitrary code from third party repositories and patches.  We need to design our network topology in a way that provides the bare minimum required connectivity both internally between hosts and from the outside world in.

## Overview

We will utilize two separate internal networks to isolate our production services from slave nodes that will be executing tests.  The two networks will be connected by a L3 router which will provide connectivity between internal networks as well outbound connectivity to the internet.  Security groups will be used to limit connectivity from the outside world, allow connectivity between hosts on the same network, and prohibit connectivity from slave nodes to the rest of the infrastructure.  This network topology will be configured in Neutron via Ansible automation and will be scoped to production project.  It should be trivial for developers to recreate this topology within their own tenant and project.

### Projects

Network resources will be created within a `control-plane` project.  We will be utilizing shared networks, which must be created by a user with the `cloud_admin` role on that project. Compute resources for control plane services will be created within the `control-plane` project.  Nodepool itself will be configured to use a specific `nodepool` project for creating its instances with interfaces attached to a shared network that was created on the `control-plane` project.

### Networks

We will create two separate internal networks and hosts will be given interfaces on them depending on the role of said host.

* `control-plane 192.168.10.0/24` - This network will be used for communication between all of our production services, as well as automation between the bastion host and our producion servers.  As per our current infrastructure, the following static hosts will have interfaces on this network and internal DNS updated accordingly:
  * bastion.bonnyci*internal.portbleu.com
  * logs.bonnyci*internal.portbleu.com
  * merger01.bonnyci*internal.portbleu.com
  * nodepool.bonnyci*internal.portbleu.com
  * zuul.bonnyci*internal.portbleu.com
* `nodepool 10.0.0.0/8` - This is an shared network that will be used by nodepool slaves. None of the static service hosts within the control plane will receive an interface on this network.

Our cloud is also configured with an external network named `external` that provides us currently with 30 floating IPs.  These will be assigned to hosts depending on their need, see [Floating IPs](#floating-ips).

### Routers

To allow connectivity between the two isolated networks, a single L3 router will be created.  The router will have a router interface attached for both the `control-plane` and `nodepool` networks.  These router interfaces become the default gateway for nodes booted on each respective network, allowing connectivity between the two isolated networks. Additionally, the router will have its router gateway set to provide outbound connectivity through the external network and allow for floating IP association.

### Floating IPs

Some of the hosts running on the control plane will need to be accessed from the outside world for various reasons.  Public addresses for floating IPs will be allocated from the `external` network that is available to our cloud, currently providing addresses from the 169.44.171.64/27 and 169.44.161.32/27 ranges, though our quota currently allows for 50. Each of the following hosts will also be assigned a floating IP from the external network that will be publically accessible on specific ports (see [Security Groups](#security-groups)). Public DNS hostnames will be updated accordingly:

* bastion.bonnyci-internal.portbleu.com <- contrasjc-bastion.portbleu.com - Provides an ssh entry point from the outside world to the rest of our infrastructure and serves automation logs via http.
* logs.bonnyci-internal.portbleu.com <- logs.bonnyci.com - Serves test log output and other test archives via http.
* zuul.bonnyci-internal.portbleu.com <- zuul.bonnyci.org - Provides a https endpoint for receiving Github webhook notifications, and the serves Zuul status JSON and web site.

### Security Groups

Security groups will be used to limit the connectivity from the outside world to only specific ports for the services described above.  They will also be used to classify and limit internal connectivity between internal networks.  Traffic on any port not explicitly allowed will be denied.

The following security groups will be created on the `control-plane` project:

* `sg-control-plane` - This group will allow all traffic from the other hosts that are part of the same `sg-control-plane` security group.
  * Ports open: All ports from security group `sg-control-plane`.
* `sg-zuul-merger` - This group will allow git to be served to nodepool slaves.
  * Ports open:  8858 from network 10.0.0.0/8
* `sg-ssh` - A generic group that allows unrestricted inbound ssh access.
  * Ports open: 22 (ssh) from 0.0.0.0/0
* `sg-http-https` - A generic group that allows unrestricted inbound http and https access.
  * Ports open: 80 (http) from 0.0.0.0/0, 443 (https) from 0.0.0.0/0

The following hosts will have the corresponding security groups assigned:

* bastion.bonnyci-internal.portbleu.com: sg-ssh, sg-http-https, sg-control-plane
* logs.bonnyci-internal.portbleu.com: sg-control-plane, sg-http-https
* merger01.bonnyci-internal.portbleu.com: sg-control-plane, sg-zuul-merger
* nodepool.bonnyci-internal.portbleu.com: sg-control-plane
* zuul.bonnyci-internal.portbleu.com: sg-control-plane, sg-http-https

SSH access to the entire infrastructure will need to happen via the bastion host as it is the only one capable of accepting SSH connections from the outside world.

The `nodepool` project will boot all of its nodes on the default security group.  This group will need to be updated to allow SSH access from the `192.168.10.0/24` network so that nodepool and zuul may reach it for orchestrating setup and test runs.
