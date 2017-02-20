#!/bin/bash

sudo apt-get install -y shellcheck

if ! find . -name '*.sh' -print0 | xargs -n1 -0 shellcheck -s bash; then
    echo "ERROR: Shell script linting failed!"
    echo "SUGGESTION: See messages above for specific issues."
    exit 1
else
    echo "SUCCESS: Shell script linting passed!"
fi
