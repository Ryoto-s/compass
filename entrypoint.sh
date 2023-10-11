#!/bin/bash -e
set -e
 
# Remove a potentially pre-existing server.pid for Rails.
rm -f /compass/tmp/pids/server.pid

exec "${@}"
