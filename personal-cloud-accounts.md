---
name: personal cloud accounts
layout: default
---

# Instructions for personal cloud accounts

## Table of Contents

* [Overview](#overview)
* [Obtaining an account](#obtain-account)
* [Accessing the Cloud](#access)

## Overview

The BonnyCI project offers personal cloud accounts to core developers. This
allows developers to utilize the same cloud environment that our production runs
on, for more closely testing changes. Developers who are granted accounts will
be provided their own project space, with a fairly limited quota set, as well as
`_member_` level rights to our production projects.

## Obtaining an account

Accounts can be requested by creating a pull request to the [Hoist
repo](https://github.com/BonnyCI/hoist/), specifically the
[create-cloud-resources.yml](https://github.com/BonnyCI/hoist/blob/master/create-cloud-resources.yml)
playbook. Simply add your details; desired username, email address for contact,
and whether or not you'll want `cloud_admin` rights. Once the pull request has
been approved, an existing developer with `cloud_admin` rights will execute the
playbook to make your account live. A temporary password will be used, which
needs to be changed immediately.

## Accessing the Cloud

Our production cloud is an OpenStack cloud provided by IBM. The `auth_url` is
`https://ibm-open-technology-sjc.openstack.blueboxgrid.com:5000` and a Horizon
web UI is also
[available](https://ibm-open-technology-sjc.openstack.blueboxgrid.com/auth/login/).
See the [documentation](https://docs.openstack.org/user-guide/dashboard.html)
for more information on using Horizon.

The OpenStack project provides great
[documentation](https://docs.openstack.org/user-guide/cli.html) on how to
install and use the OpenStack clients. We recommend using the [unified
command-line
client](https://docs.openstack.org/user-guide/common/cli-overview.html#unified-command-line-client).

The unified command-line client can make use of
[os-client-config](https://docs.openstack.org/developer/os-client-config/#os-client-config)
to read configuration for one or more clouds to interact with. For our cloud,
configuration would look like:

```yaml
clouds:
  opentech-sjc:
    profile: bluebox
    auth:
      username: <USERNAME>
      password: <PASSWORD>
      project_name: <PROJECT>
      auth_url: https://ibm-open-technology-sjc.openstack.blueboxgrid.com:5000
    identity_api_version: "3"
```
