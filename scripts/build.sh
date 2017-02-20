#!/bin/bash

source ./setenv.sh

# build Docker image
docker build    			\
    $DOCKER_BUILD_OPTIONS   \
    --tag $DOCKER_BUILD_TAG \
    .