#!/bin/bash

find . -name '*.md' -print0 | xargs -n1 -0 textlint -c .textlintrc.js -f pretty-error
