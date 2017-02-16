---
name: example_bonnyci_run
layout: default
permalink: /lore/end_users/setup/examples/example_bonnyci_run
---

# Example .bonnyci/run.sh script

The following is a contrived example of a ``.bonnyci/run.sh`` entry point for executing tests within a Python project repository managed by BonnyCI.  This script will be executed from the root of the source tree for test runs in both the check and gate pipelines.  In this example, we will want to run a different set of tests for each pipeline and archive test debug logs to the BonnyCI log server for post-run inspection.

```shell
#!/bin/bash -xe

# Running bash with set -e is a good idea!

function install_required_packages() {
    # Ensure the Ubuntu VM our tests are running on has the correct package
    # requirements installed for tests.
    sudo apt-get -y install virtualenv
}


function setup_virtualenv() {
    # Creates a python virtual environment and installs any requirements
    # that may be listed in requirements files.
    venv_dir="$(mktemp -d)"
    virtualenv $venv_dir
    source $venv_dir/bin/activate
    if [ -f requirements.txt ]; then
        pip install -r requirements.txt
    fi
    if [ -f test-requirements.txt ]; then
        pip install -r test-requirements.txt
    fi
}


function run_unit_tests() {
    # Run the unit test suite with nose.  Log verbose output to the console,
    # which by default will be logged and archived by BonnyCI.
    nosetests -v ./tests/unit/
}


function run_functional_tests() {
    # Run our fictional functional test suite, specifying the log directory as
    # the output dir for its debug logs.
    python ./tests/functional/run_functional.py --log-dir=$BONNYCI_TEST_LOG_DIR
}


function run_coverage() {
    # Run a coverage report, logged to the console.
    python setup.py testr --coverage
}


function build_docs() {
    # Build our in-tree documentation and archive its output
    python setup.py build_sphinx
    mkdir $BONNYCI_LOG_DIR/docs/
    cp -r doc/build/* $BONNYCI_LOG_DIR/docs/
}


install_required_packages
setup_virtualenv

echo "Running $BONNYCI_TEST_PIPELINE tests..."

case "$BONNYCI_TEST_PIPELINE" in
    "check")
        run_unit_tests
        run_converage
    "gate")
        run_unit_tests
        run_coverage
        run_functional_tests
        build_docs
esac

exit 0
```
