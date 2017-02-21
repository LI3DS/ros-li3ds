#!/bin/bash

source ./setenv.sh

# build Docker image
docker rmi --force $DOCKER_BUILD_TAG
