#!/bin/bash

source entry-point.sh

# set the VLP-16 ip address (to contact the webserver)
export VLP16_NETWORK_SENSOR_IP=172.20.0.191

# launch the ros node
roslaunch velodyne_pointcloud VLP16_points.launch