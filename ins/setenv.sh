#!/bin/bash

DOCKER_BUILD_OPTIONS=" --rm "
#DOCKER_BUILD_OPTIONS+="--no-cache"
DOCKER_BUILD_TAG=li3ds/ins:latest

#
DOCKER_RUN_OPTIONS+=" -it --rm "
#
# url: https://docs.docker.com/engine/tutorials/dockervolumes/
DOCKER_RUN_OPTIONS+="						\
--volume-driver=local 						\
-v li3ds_catkin_ws:/catkin_ws "
#
#DOCKER_RUN_OPTIONS+=" --no-cache "
DOCKER_RUN_OPTIONS+=" -v li3ds_ins_overlay_ws:/root/overlay_ws "
DOCKER_RUN_OPTIONS+=" -v $(realpath ./scripts):/root/scripts "

# share USB/serial sbg ellipse-n device
# url: https://reprage.com/post/how-to-deploy-docker-containers-to-an-arduino
DOCKER_RUN_OPTIONS+=" --privileged -v /dev/bus/usb:/dev/bus/usb "

DOCKER_VOLUME_DRIVER="local"
DOCKER_VOLUME_NAME="li3ds_ins_overlay_ws"