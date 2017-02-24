#!/bin/bash

# Source ROS
source /ros_entrypoint.sh

# Set catkin workspace
export LI3DS_ROOT_PATH="/root"
#
export ROS_OVERLAY_WS="/root/overlay_ws"
export ROS_CATKIN_WS="/catkin_ws"

# Set install path
source scripts/source_install.sh
# source scripts/source_devel.sh