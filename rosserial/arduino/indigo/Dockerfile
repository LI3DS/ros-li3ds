#
FROM ros:indigo-ros-core

# APT CONF
COPY apt.conf /etc/apt/apt.conf

RUN apt-get update && \
    apt-get install -y \
    ros-indigo-rosserial-arduino \
    ros-indigo-rosserial

# Set Arduino-CMake from ros-indigo-rosserial-arduino
ENV ARDUINOCMAKE_DIR /opt/ros/indigo/share/rosserial_arduino/arduino-cmake

# Build our catkin workspace from the /catkin_ws directory
WORKDIR /catkin_ws

#
COPY scripts/generate_ros_lib.sh /root
RUN chmod +x /root/generate_ros_lib.sh

# url: https://docs.docker.com/engine/reference/builder/
# Lancement du script de generation du répertoire 'ros_lib'
CMD ["/ros_entrypoint.sh", "/root/generate_ros_lib.sh"]
