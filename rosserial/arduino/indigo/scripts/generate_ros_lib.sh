echo "delete 'ros_lib'"
rm -r ros_lib

echo "generate ros_lib ..."
rosrun rosserial_arduino make_libraries.py .
