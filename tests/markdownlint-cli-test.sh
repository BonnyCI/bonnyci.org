#!/bin/bash

sudo npm install -g markdownlint-cli

if ! markdownlint -c .markdownlint.js .; then
    echo "ERROR: Markdown linting failed!"
    echo "SUGGESTION: See messages above for specific issues."
    exit 1
else
    echo "SUCCESS: Markdown linting passed!"
fi
