---
name: personal cloud accounts
layout: default
---

# Personal Cloud Accounts

## Problem Statement

We now have our own Bluemix Private Cloud, with cloud_admin rights to it. This cloud is primarily intended to be used to run our BonnyCI control plane and to provide nodepool capacity for running tests. Additionally, we can make use of this cloud for personal development environments. In order to keep track of personal projects and to ensure they are created and managed in a sane way, we need to introduce some controls and automation around their creation.

## Overview

Each BonnyCI developer is entitled to a personal cloud account and matching project, with an appropriate role. A reasonable set of quotas will be enforced. Accounts and projects will be created via automation.

### Accounts Projects and Roles

An account is a set of credentials to log into OpenStack via keystone. An account by itself is not very useful, as it requires a role within a project. A single account may have multiple roles across multiple projects. For our cloud, each developer is entitled to an account with a matching project, and a role of _member_ within the project.

For more about roles, see [IBM Users and Projects Documentation](http://ibm-blue-box-help.github.io/help-documentation/keystone/Managing_Users_and_Projects/)

### Quotas

Quotas are an artificial limit placed on certain consumable resources within an OpenStack cloud. We will use quotas to prevent any one user from consuming all of the resources of our cloud, preventing others from working and preventing our production from having capacity to test things. The quotas stated here are just a default. If a developer has a legitimate need for additional capacity, their quota can be adjusted by a cloud admin.

For details on the default quotas, see [IBM Quota Documentation](http://ibm-blue-box-help.github.io/help-documentation/openstack/userdocs/quotas/)

### Automation

We will create and manage accounts, projects, roles, and quotas via Ansible automation. Due to these actions requiring a `cloud_admin` level role, the automation will be ran by a human with the appropriate credentials to start with.

While most developers will have access to `cloud_admin` level credentials, it is critical to not abuse those credentials to manage accounts, projects, roles, or quotas outside of the automation.
