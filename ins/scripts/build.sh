#!/bin/bash

# url: http://answers.ros.org/question/54181/how-to-exclude-one-package-from-the-catkin_make-build/
cd $ROS_CATKIN_WS
# catkin_make -DCATKIN_BLACKLIST_PACKAGES="velodyne_settings;velodyne_status" -j3 install
catkin_make -j3 install
cd -