# Instructions for macOS

Install required software:
- [Homebrew](http://brew.sh/)
- [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
- [Vagrant](https://www.vagrantup.com/downloads.html)

Install some basic command line tools and nodejs:

```shell
$ brew install coreutils
$ brew install node
```

You can get by with coreutils with prefixing commands you want with a `g`. For instance, `rm` would be `grm`. If you don't want to think about that too much, add the following to your `~/.bash_profile`:

```shell
export PATH=/usr/local/opt/coreutils/libexec/gnubin:/usr/local/sbin:$PATH
export MANPATH=/usr/local/opt/coreutils/libexec/gnuman:$MANPATH
```

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

Install [vagrant-hostmanager](https://github.com/devopsgroup-io/vagrant-hostmanager), and [vagrant-triggers](https://github.com/emyl/vagrant-triggers):

```shell
$ vagrant plugin install vagrant-hostmanager vagrant-triggers
```
