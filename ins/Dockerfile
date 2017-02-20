#
FROM ros:indigo-ros-core

# APT CONF
COPY apt.conf /etc/apt/apt.conf


RUN apt-get update && 	\
    apt-get install -y 	\
    realpath			\
    build-essential
    #ros-indigo-rosserial-arduino \
    #ros-indigo-rosserial

COPY cmake-3.8.0-rc1.tar.Z /cmake-3.8.0-rc1.tar.Z
RUN tar xzvf /cmake-3.8.0-rc1.tar.Z
RUN cd cmake-3.8.0-rc1 && ./configure && make -j3 && make install


RUN apt-get install -y			\
	curl						\
	python-rosinstall-generator	\
	usbutils

# Set Arduino-CMake from ros-indigo-rosserial-arduino
#ENV ARDUINOCMAKE_DIR /opt/ros/indigo/share/rosserial_arduino/arduino-cmake

# Build our catkin workspace from the /catkin_ws directory
WORKDIR /root


#
COPY scripts /root/scripts
COPY entry-point.sh /root/entry-point.sh
RUN chmod +x /root/entry-point.sh

#
COPY .gitconfig /root/.gitconfig

# url: https://docs.docker.com/engine/reference/builder/
# Lancement du script de generation du répertoire 'ros_lib'
CMD ["/ros_entrypoint.sh", "bash"]
