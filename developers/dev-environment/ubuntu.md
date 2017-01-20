# Instructions for Ubuntu

Run the following to install most of the needed packages:

```shell
$ sudo apt-get install build-essential libssl-dev libffi-dev python-dev python-pip python-software-properties vagrant virtualbox
```

Install [vagrant-hostmanager](https://github.com/devopsgroup-io/vagrant-hostmanager), and [vagrant-triggers](https://github.com/emyl/vagrant-triggers):

```shell
$ vagrant plugin install vagrant-hostmanager vagrant-triggers
```

Add the official nodejs ppa, then install nodejs and its package manager, npm:

```shell
$ curl -sL https://deb.nodesource.com/setup_7.x | sudo -E bash -
$ sudo apt-get install nodejs
```

Install ansible, setuptools, virtualenv and virtualenvwrapper:

```shell
$ sudo pip install ansible setuptools virtualenv virtualenvwrapper
```

Add the following to your `~/.bashrc`:

```shell
export WORKON_HOME=~/.virtualenvs
. /usr/local/bin/virtualenvwrapper.sh
```

Activate virtualenvwrapper:

```shell
$ source ~/.bashrc
```
