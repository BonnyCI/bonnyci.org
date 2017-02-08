---
name: macOS
layout: default
---

# Instructions for macOS

## Table of Contents

* [Basic Tools](#basic-tools)
* [Python Tools](#python-tools)
* [Virtualization Tools](#virtualization-tools)

## Basic Tools

Install [Homebrew](http://brew.sh/) to get a package manager.

Install some basic command line tools:

```shell
$ brew install coreutils
```

You can get by with coreutils with prefixing commands you want with a `g`. For instance, `rm` would be `grm`. If you don't want to think about that too much, add the following to your `~/.bash_profile`:

```shell
export PATH=/usr/local/opt/coreutils/libexec/gnubin:/usr/local/sbin:$PATH
export MANPATH=/usr/local/opt/coreutils/libexec/gnuman:$MANPATH
```

## Python Tools

Install the python package manager pip:

```shell
$ curl https://bootstrap.pypa.io/get-pip.py | python
```

Install ansible, setuptools, virtualenv and virtualenvwrapper:

```shell
$ sudo pip install ansible setuptools virtualenv virtualenvwrapper
```

Add the following to your `~/.bash_profile`:

```shell
export WORKON_HOME=~/.virtualenvs
source /usr/local/bin/virtualenvwrapper.sh
```

Enable virtualenvwrapper:

```shell
$ source ~/.bash_profile
```

## Virtualization Tools

Install [VirtualBox](https://www.virtualbox.org/wiki/Downloads) and [Vagrant](https://www.vagrantup.com/downloads.html) for running local virtual machines.

Install [vagrant-hostmanager](https://github.com/devopsgroup-io/vagrant-hostmanager), and [vagrant-triggers](https://github.com/emyl/vagrant-triggers):

```shell
$ vagrant plugin install vagrant-hostmanager vagrant-triggers
```
