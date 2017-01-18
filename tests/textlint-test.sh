#!/bin/bash

find . -name '*.md' -print | xargs -n1 textlint -c .textlintrc.js -f pretty-error
