#!/bin/bash
set -e
cd `dirname $0`
. .env

# Shut down any running instance
echo
echo "Stopping containers..."
nginx_container="$(docker ps -q --filter 'name=nginx-vagrant-boxes')"
if [ "$nginx_container" != "" ]
then
  docker stop $nginx_container
fi

# Clean up old containers
echo
echo "Removing stopped containers..."
containers="$(docker ps -q --filter "status=exited")"
if [ "$containers" != "" ]
then
  docker rm -v $containers
fi
