#!/bin/bash

#
export PATH=$PATH:$(realpath scripts)

ls scripts/ -1

export ROS_CATKIN_WS=$(realpath /catkin_ws)

#source /opt/ros/indigo/setup.bash
source /opt/ros/indigo/setup.sh
#source /opt/ros/indigo/setup.zsh

source scripts/source_install.sh
# source scripts/source_devel.sh
