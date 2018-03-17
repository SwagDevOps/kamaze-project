#!/usr/bin/env bash

# This script script is intended to easyfy remote (ssh)
# commands execution.
#
# Sample of use:
#
# ```sh
# remote bundle exec rspec
# ```

WORKING_DIR=/vagrant
set -e
. /etc/profile.d/rvm.sh
cd "${WORKING_DIR}"
exec $@
