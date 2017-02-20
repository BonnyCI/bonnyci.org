---
name: production cloud accounts
layout: default
---

# Production Cloud Accounts

## Problem Statement

We need to divide up certain parts of the BonnyCI infrastructure across a set of projects and users to allow fine grained access control to administrative capababilites in the cloud.

## Overview

Our automation requires admin-level API access to the cloud for the initial provisioning of cloud resources and the continued management of users+projects.  Once provisioned, hoist automation only requires SSH access between production hosts. Beyond that, the only cloud API access we require is for nodepool.

### Accounts Projects and Roles

An account is a set of credentials to log into OpenStack via keystone. An account by itself is not very useful, as it requires a role within a project. A single account may have multiple roles across multiple projects.

We will require the following projects be created:

* `bonnyci` - This project will contain cloud resources for running the production systems and provide API access to humans running automation to do initial provisioning of networks, instances and accounts.
* `nodepool` - This is a separate project that will be configured as a Nodepool provider.  All Nodepool slaves will be booted on here.

All BonnyCI developers will have a project and matching account on the cloud (see [Personal Cloud Accounts](#personal-cloud-accounts)).  Each account will also be granted a role of `_member_` on the `bonnyci` project so they may get visibility into our running systems.  This will happen en masse via a new `bonnyci` keystone group that contains all current BonnyCI developers. A subset of these users will also be assigned to a `bonnyci-admin` group and granted `cloud_admin` role on the `bonnyci` project so they may manually run automation to provision resources and manage accounts and projects.

The `nodepool` project will have a single account created and granted the `_member_` role.  This account and project will make up the nodepool provider configuration for this cloud.  Additionally, the `bonnyci` group will receive a `_member_` grant on this project.
