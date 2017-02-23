#!/bin/bash

source ./setenv.sh

docker volume rm --force $DOCKER_VOLUME_NAME
