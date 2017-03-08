# Deploying

## Table of Contents

* [Requirements](#requirements)
* [Provisioning](#provisioning)
* [Hoist Deployment](#deployment)

## Requirements

The BonnyCI system is designed to run in a cloud environment.  While it is possible to deploy and run it on any cloud platform, some components of its deployment tooling are designed specifically to be run on top of [OpenStack](https://www.openstack.org).

The vast majority of the automation is written in [Ansible](https://www.ansible.org), so ensure you have a functional Ansible installation and a basic understanding of its concepts and workflows.

You will also need access to a public DNS server and a registered domain name.

## Provisioning

The initial provisioning automation is designed to be run against an OpenStack cloud.  Ensure you have functioning credentials on an OpenStack project. To deploy the default topology, you will require admin privileges on this project so that you may create new projects, accounts and shared network resources.

### Initial Bootstrapping

This step will consists of several operations:

* Creating the accounts and projects for the production services
* Provisioning network resources
* Setting up SSH keypairs
* Booting all hosts with required public IPs

The task is modular such that steps may be run individually or all at once  A number of deployment variables may be tweaked but the defaults should work for most.  There are, however, several that need to be updated per environment:

* cloud - The name of the cloud you will be accessing, as configured in your OpenStack [clouds.yaml](https://docs.openstack.org/developer/python-openstackclient/configuration.html]).

* dns_subdomain - This is the domain name to be associated with service hosts.  Hosts will be named according to this domain name and these names are expected to resolve to an address that is reachable between service hosts.
* default_ssh_key - This is a public ssh key that will be used for initial access to the system, via bastion, from the outside world.
* external_network_name - This should be set to the name of the external network on your cloud.
* image_uuid - The UUID of the Ubuntu image in Glance image that will be used for hosts. We currently support Ubuntu Xenial 16.04 and this image should have Python 2.7 installed.

For a full list of provisioning variables, see [here](https://github.com/BonnyCI/hoist/blob/master/roles/cloud-bootstrap/defaults/main.yml).

To begin provisioning, create a top-level playbook to bootstrap the cloud, for example:

```yaml
# provision.yml
---
- name: Create cloud resources and accounts
  hosts: localhost
  roles:
    - role: cloud-bootstrap
      cloud: mycloud
      dns_subdomain: internal.myorg.org
      default_ssh_key: ssh-rsa AAA<....snip....>AeEw== cideploy@bonnyci
      image_uuid: f4611a28-112d-4383-ad3c-b8792572c5f0
```

Then run the automation:

```shell
$ ansible-playbook provision.yml
```

### Updating DNS

#### Private addresses

All instances are booted with an internal IP address on the ``bonnyci`` network and are named after the FQDN that should be associated with this address.  This address is created using the ``dns_subdomain`` setting mentioned above.  At this point you should update your DNS to match.  For example, the provisioning above will result in instances named similar to ``zuul.internal.myorg.org`` and ``nodepool.internal.myorg.org``, each with an address on the 192.168.20.0/24 network (by default).  Create records in your DNS server accordingly.  These hostnames will be used later to configure where services reach one another.

#### Public addresses

Additionally, some of the hosts will be associated with an address from the external network.  By default, these will be automatically allocated from the specified external network.  Alternatively, they may be pre-allocated and explicitly attached, see [here](https://github.com/BonnyCI/hoist/blob/master/create-cloud-resources.yml#L26) for an example.  These addresses are the public endpoints for various services and should receive a DNS entry as well according to the associated service, for example ``zuul.myorg.org`` and ``bastion.myorg.org``.  These hostnames will be used later to create your host inventory.

### Create inventories

We will need 2 host inventories to be created in your local hoist checkout.  One for the bastion host and another for the service hosts.

The bastion inventory references the hostnames associated with your bastion instance's public address and will be referenced when running Ansible manually from *outside* the system.

```text
# inventory/mycloud-bastion
[bastion]
bastion.myorg.org ansible_ssh_user=ubuntu
```

The ci inventory references the hostnames associated with the private addresses of your instances and will be referenced when Ansible is run automatically from *within* the system.

```text
# inventory/mycloud-ci

[nodepool]
nodepool.internal.myorg.org

[zuul]
zuul.internal.myorg.org

[mergers]
merger01.internal.myorg.org

[mysql]
zuul.internal.myorg.org

[zookeeper]
nodepool.internal.myorg.org

[log]
logs.internal.myorg.org

[monitoring]
elk.internal.myorg.org

[production]
nodepool.internal.myorg.org
zuul.internal.myorg.org
merger01.internal.myorg.org
logs.internal.myorg.org
elk.internal.myorg.org

[mycloud]
nodepool.internal.myorg.org
zuul.internal.myorg.org
merger01.internal.myorg.org
logs.internal.myorg.org
elk.internal.myorg.org
```

### Post-provisioning

#### Ready playbook

To ensure all hosts can be reached via SSH from the bastion, create a playbook that runs the cloud-ready role:

```yaml
# ready-cloud.yml
---
- name: Ready mycloud
  hosts: all
  roles:
    - role: cloud-ready
      cloud: mycloud
```

Run this playbook using the bastion inventory you created above:

```shell
$ ansible-playbook -i inventory/mycloud-bastion ready-cloud.yml
```

#### Push your changes to a fork

The bastion host relies on a source checkout of hoist to automate and orchestrate the infrastructure.  It is expected that this checkout contain the inventories that were created above. For your deployment, create a fork of [hoist](https://github.com/BonnyCI/hoist) that contains the new inventory files and any other changes specific to your environment.  Note the URL of this repository as it will be used during bastion deployment.

## Deployment

The bastion host will serve as the main orchestrator of the infrastructure. Once deployed, automation becomes a hands-off operation.

### Bastion deployment

Coming soon...
