#!/bin/bash

source ./setenv.sh

docker volume create -d $DOCKER_VOLUME_DRIVER $DOCKER_VOLUME_NAME 

docker volume inspect $DOCKER_VOLUME_NAME 
