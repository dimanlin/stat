#!/bin/bash
set -e
bundle install
bundle exec rake db:create
bundle exec rake db:migrate

# BUNDLE_IGNORE_CONFIG=1 bundle install
# pip3 install yarn

exec "/bin/bash"
