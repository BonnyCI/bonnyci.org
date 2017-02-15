#!/bin/bash
set -eux
sudo gem install github-pages bundler
bundle update
bundle exec jekyll build
mv _site "$BONNYCI_TEST_LOG_DIR"
