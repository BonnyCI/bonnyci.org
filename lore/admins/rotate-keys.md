---
name: Rotating Keys
layout: default
permalink: /lore/admins/rotate-keys/
---

# Rotating Keys

## Table of Contents

* [Overview](#overview)
* [Rotating CIDeploy Key](#rotating-cideploy-key)

## Overview

There will be times that key rotation is necessary. Doing so requires
some planning to ensure admins retain access to servers.

## Rotating the CIDeploy Key

As an admin, you should have a user account on the bastion host. Once
connected, become the cideploy user and generate a new SSH key. It is
very important that you not overwrite the current key until you have
sent this new one out.

```text
user@bastion$ sudo -i -u cideploy
cideploy@bastion$ ssh-keygen -t rsa -b 2048 -f ~/.ssh/id_rsa_new
```

### Update Secrets

Edit `/etc/secrets.yml`, and make these changes to `secrets.ssh_keys.cideploy`

* Rename the key `public` to `old_public`. Delete any existing `old_public`
  * Note that an existing `old_public` is likely a security violation,
    as it means a previously rotated key was kept on servers.
* update the `private` to the contents of `~cideploy/.ssh/id_rsa_new`
* add a new `public` key with the contents of `~cideploy/.ssh/id_rsa_new.pub`

### Run playbook to distribute new key into `authorized_keys`

Either let cron run the cideploy env, or manually run its
playbooks. Verify that it completed with no errors.

### Test both old and new key access

The simplest way to do this is with ansible. The existing key like this:

```text
cideploy@bastion$ ansible -u ubuntu -i /opt/source/cideploy/inventory/ci -m ping
```

And the new key like this:

```text
cideploy@bastion$ ansible -u ubuntu -i /opt/source/cideploy/inventory/ci -m ping -e ansible_ssh_private_key_file=/home/cideploy/.ssh/id_rsa_new
```

At this stage, both should work.

### Rotate new key in as current key

If an `id_rsa_old` already exists, you will need to move it out of the way.

```text
cideploy@bastion$ cd .ssh
cideploy@bastion:~/.ssh$ mv id_rsa id_rsa_old && mv id_rsa.pub id_rsa_old.pub && mv id_rsa_new id_rsa && mv id_rsa_new.pub id_rsa.pub
```

### Wait for playbook to run again

Wait for the playbook to run again with the new key in place so we can
verify that everything is working with the new key.

### Remove `old_public` key from `/etc/secrets.yml`

Edit `/etc/secrets.yml` again, and this time remove the `old_public`
key from `secrets.ssh_keys.cideploy`.

### Verify playbook runs one more time

The next playbook run will remove the old key from all systems, completing
key rotation. Verify this with ansible. This should fail. If it does not,
your SSH key has not been removed and is not fully rotated:

```text
cideploy@bastion$ ansible -u ubuntu -i /opt/source/cideploy/inventory/ci -m ping -e ansible_ssh_private_key_file=/home/cideploy/.ssh/id_rsa_old
```
