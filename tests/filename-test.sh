#!/bin/bash

FILENAME_LIST=$(find . -path './.git' -prune -o -wholename './index.md' -prune -o -name 'index*' -print)

if ! [[ -z "$FILENAME_LIST" ]]; then
    echo "ERROR: Files in BonnyCI/bonnyci.org should not be named index."
    for FILENAME in $FILENAME_LIST; do
        # shellcheck disable=SC2001
        FILENAME_PATH=$(echo "$FILENAME" | sed 's/\/index.*$//')
        if [[ "$FILENAME" != "*.md" ]]; then
            echo "ERROR: $FILENAME's extension is not .md."
            echo "SUGGESTION: Please ensure $FILENAME is written in Markdown, and name it $FILENAME_PATH/README.md."
        else
            echo "SUGGESTION: Consider renaming $FILENAME to $FILENAME_PATH/README.md."
        fi
    done
    exit 1
else
    echo "SUCCESS: No unnecessary index files found."
fi
