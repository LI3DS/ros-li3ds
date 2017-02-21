#!/bin/bash

DOCKER_BUILD_OPTIONS="--rm"
#DOCKER_BUILD_OPTIONS+="--no-cache"
DOCKER_BUILD_TAG=ros:indigo-rosserial-arduino

DOCKER_RUN_OPTIONS="-it --rm --volume-driver=local -v li3ds_catkin_ws:/catkin_ws"

DOCKER_VOLUME_DRIVER="local"
DOCKER_VOLUME_NAME="li3ds_catkin_ws"
