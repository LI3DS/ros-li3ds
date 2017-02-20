#!/bin/bash

. /home/latty/link_dir/2015_li3ds/__ARDUINO__/__ROS__/launch_rosserial_client.sh &

rostopic echo arduino_trig
