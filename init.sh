#!/bin/bash
set -e
cd `dirname $0`
. .env

docker pull nginx

# Generate the initial manifests. This will also bounce the nginx server.
./generate_manifests.sh
