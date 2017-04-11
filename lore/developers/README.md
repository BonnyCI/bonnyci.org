---
name: developers
layout: default
permalink: /lore/developers/
---

# Developers

## Table of Contents

* [Development Environment](#development-environment)
  * [Virtual Machines](#virtual-machines)
  * [Docker](#docker)
* [Contributing](#contributing)
* [IRC](#irc)

## Development Environment

Before hacking on BonnyCI, we'll need to set up a development environment on
our local machine.

Supported development platforms:

* [Ubuntu](dev-environment/ubuntu.md)
* [Apple's macOS](dev-environment/macOS.md)
* [Personal Cloud Accounts](dev-environment/personal-cloud-accounts.md)

### Virtual Machines

You can test changes to BonnyCI locally by exercising some tools defined in
[hoist](www.github.com/BonnyCI/hoist). Hoist is a set of ansible playbooks that
automate the deployment of a BonnyCI environment. Be sure that you have
completed the `Virtualization Tools` section of your OS's [Development
Environment](#development-environment) page before proceeding.

Clone hoist and navigate to its base directory:

```shell
$ git clone git@github.com:BonnyCI/hoist.git
$ cd hoist
```

To perform a full deploy:

```shell
$ ./tools/vagrant-deploy.sh
```

To redeploy the nodepool VM:

```shell
$ vagrant destroy nodepool
$ ./tools/vagrant-deploy.sh
```

To inspect the zuul VM:

```shell
$ vagrant ssh zuul
$ # netstat, tcpdump, tail logs, etc.
$ logout
```

To test changes to the zuul role:

```shell
$ ./tools/vagrant-deploy.sh --limit zuul
```

To tear down the entire stack when you're done:

```shell
$ vagrant destroy
```

### Docker

You can test changes to BonnyCI locally by exercising some tools defined in
[hoist](www.github.com/BonnyCI/hoist). Hoist is a set of ansible playbooks that
automate the deployment of a BonnyCI environment. Be sure that you have
completed the `Docker` section of your OS's [Development
Environment](#development-environment) page before proceeding.

Clone hoist and navigate to its base directory:

```shell
$ git clone git@github.com:BonnyCI/hoist.git
$ cd hoist
```

To perform a full deploy:

```shell
$ ./tools/docker-deploy.sh
```

To inspect the container:

```shell
$ docker exec -it allinone /bin/bash
$ # netstat, tcpdump, tail logs, etc.
$ exit
```

To test changes to the zuul role:

```shell
$ ansible-playbook -i inventory/allinone install-ci.yml -c docker -e @secrets.yml.example --limit zuul
```

To tear down the entire stack when you're done:

```shell
$ docker stop allinone
$ docker rm allinone
```

## Contributing

Please see the [contributing documentation](contributing) for more information.

A brief note on repository naming...
> The puns get made, or the plank gets walked.
>
> ~Jesse Keating

## IRC

For discussions about BonnyCI, join us on [freenode](https://freenode.net) #BonnyCI!

## Mailing List

The mailing list can be subscribed to [here](http://list.bonnyci.org/mailman/listinfo/bonnyci_list.bonnyci.org)
