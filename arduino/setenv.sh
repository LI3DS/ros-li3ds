#!/bin/bash

DOCKER_BUILD_OPTIONS="--rm"
#DOCKER_BUILD_OPTIONS+="--no-cache"
DOCKER_BUILD_TAG=li3ds/arduino:latest

#
DOCKER_RUN_OPTIONS+="-it --rm"
#
DOCKER_RUN_OPTIONS+=" --volume-driver=local "
DOCKER_RUN_OPTIONS+=" -v li3ds_catkin_ws:/catkin_ws "
DOCKER_RUN_OPTIONS+=" -v $(realpath LI3DS_ARDUINO/):/root/. "
# share USB/serial arduino device
# url: https://reprage.com/post/how-to-deploy-docker-containers-to-an-arduino
DOCKER_RUN_OPTIONS+=" --privileged -v /dev/bus/usb:/dev/bus/usb"