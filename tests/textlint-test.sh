#!/bin/bash

sudo npm install -g textlint textlint-rule-alex textlint-rule-common-misspellings textlint-rule-no-dead-link textlint-rule-no-empty-section textlint-rule-rousseau textlint-rule-no-todo

if ! find . -name '*.md' -print0 | xargs -n1 -0 textlint -c .textlintrc.js -f pretty-error; then
    echo "ERROR: Text linting failed!"
    echo "SUGGESTION: See messages above for specific issues."
    exit 1
else
    echo "SUCCESS: Text linting passed!"
fi
