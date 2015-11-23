#!/bin/bash
cd `dirname $0`
set -e
. .env

# Stop nginx
./stop.sh

# Start nginx
./start.sh

echo
