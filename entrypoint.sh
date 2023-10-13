#!/bin/bash -e
set -e

# set Rails Master Key Manually. I will check best practice later.
export RAILS_MASTER_KEY="master_key"

# Remove a potentially pre-existing server.pid for Rails.
rm -f /tmp/pids/server.pid

exec "$@"
