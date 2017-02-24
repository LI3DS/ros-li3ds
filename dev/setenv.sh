#!/bin/bash

DOCKER_TAG=dev

DOCKER_BUILD_OPTIONS=" --rm "
DOCKER_BUILD_OPTIONS+=" --no-cache "
#DOCKER_BUILD_OPTIONS+="--no-cache"
DOCKER_BUILD_TAG=li3ds/${DOCKER_TAG}:latest

#
DOCKER_RUN_OPTIONS+=" -it --rm "
#DOCKER_RUN_OPTIONS+=" --no-cache "
#
# url: https://docs.docker.com/engine/tutorials/dockervolumes/
DOCKER_RUN_OPTIONS+=" -v li3ds_dev_catkin_ws:/root/catkin_ws "
DOCKER_RUN_OPTIONS+=" -v li3ds_dev_overlay_ws:/root/overlay_ws "
#
DOCKER_RUN_OPTIONS+=" -v $(realpath ./scripts):/root/scripts "

#DOCKER_VOLUME_DRIVER="local"
#DOCKER_VOLUME_NAME="li3ds_dev_overlay_ws"

DOCKER_RUN_OPTIONS+=" -e DISPLAY=$DISPLAY "
DOCKER_RUN_OPTIONS+=" -v /tmp/.X11-unix:/tmp/.X11-unix "