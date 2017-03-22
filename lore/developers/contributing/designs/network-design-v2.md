---
name: network design v2
layout: default
---

# BonnyCI Cloud Network Design Changes

## Problem Statement

The original network topology was designed to be a 2 tier setup where the
control-plane network hosted all service hosts and the head bastion, and the
nodepool network hosted all nodepool slaves.  The two networks were able to
communicate via a router that had interfaces on both.  This works well to
isolate the nodepool slaves from the main production systems, but is
relatively flat with regards to the bastion and prevents us from bringing up
other isolated Zuul environments that are managed by a single bastion.  We need
to rethink this a bit so that the bastion can be decoupled from the
control-plane, as we want to have multiple environments running at once, each
with their own control-plane.  Additionally, we need to think about conserving
resources and moving things that can be shared among different environments to
a network that can be reached by all, while preserving network isolation
between them.  This includes things like the logs server and the IRC Bot.

## Proposed Changes

The current bastion will be removed from the current `control-plane` network
and put on its own common network (`common-network`), with its own CIDR. The
existing router (`bonnyci-router`) will receive a network interface on
this network. This will allow traffic from the bastion to be routed to all
current service hosts on the `control-plane` network.  A new security group
`sg-common` will be created to classify traffic from the common network.  The
existing `sg-control-plane` security group will be extended to allow SSH
traffic from `sg-common`, so that ansible and humans may reach those service
hosts via SSH.  The bastion host will retain its current security groups to
allow required traffic from the outside world (sg-http-https, sg-http) as well
as from the control-plane hosts (ie, for pushing logs into ELK, publishing test
nodes to logs., etc.)

Nodepool only uses the `default` security group to boot slaves within its
project.  Currently, this group allows all traffic and the instances running
here are only accessible from the `control-plane` network via the
`bonnyci-router`.  In this new setup, multiple control plane and nodepool
networks will be connected to this router. To prevent accidental spillover, the
default nodepool security group will be limited to allow traffic from the
`sg-control-plane` (or the secgroup relative to the instances running in its
respective control-plane).

The hosts that provide other services that can be shared among environments
will also be moved to this new common network.  DNS will need to be updated to
point to the correct address on the new common-network.  This includes:

* logs.internal.bonnyci.org - Multiple Zuuls should be able to publish logs to
  a common log server
* elk.internal.bonnyci.org - Systems from every env should be pushing theikr
  logs into a single ELK.
* bot.internal.bonnyci.org - We only need one IRC bot

## Adding additional environments

Adding an additional Zuul environment will require:

* Creating additional control-plane network, nodepool network, and
  control-plane security group.
* Provisioning control-plane hosts on the new control-plane network, with the
  new control-plane security group.
* Creating an additional nodepool project for the new nodepool to use.
* Within the new nodepool project, add a rule allowing all traffic from the
  control-plane security group created for the new environment.
* Adding additional interfaces to the bonnyci router for the new control-plane
  and nodepool networks.
* Adding new ansible inventory for the new environment, updating the bastion
  playbook to deploy a new ansible-runner task for the new environment.
