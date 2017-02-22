#!/bin/bash
. create_overlay_ws.sh

cd overlay_ws

##################################
#
##################################
source /opt/ros/indigo/setup.bash

rosdep install --from-paths . --ignore-src --rosdistro indigo

mkdir -p ../catkin_ws/src && pushd ../catkin_ws

catkin_init_workspace src

ln -s `eval echo $(dirs +1)` src/

catkin_make
catkin_make install

cd -
cd ..