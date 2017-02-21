#!/bin/sh

#echo "arguments: $@"

roslaunch sbg_driver ELLIPSE_N.launch uart_port:=/dev/ttyUSB0
