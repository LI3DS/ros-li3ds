# INS

#
# FROM ros:indigo-ros-core

# # APT CONF
# COPY apt.conf /etc/apt/apt.conf


# RUN apt-get update && 	\
#     apt-get install -y 	\
#     realpath			\
#     build-essential
#     #ros-indigo-rosserial-arduino \
#     #ros-indigo-rosserial

# COPY cmake-3.8.0-rc1.tar.Z /cmake-3.8.0-rc1.tar.Z
# RUN tar xzvf /cmake-3.8.0-rc1.tar.Z
# RUN cd cmake-3.8.0-rc1 && ./configure && make -j3 && make install


# RUN apt-get install -y			\
# 	curl						\
# 	python-rosinstall-generator	\
# 	usbutils

FROM li3ds/ros:indigo

# Set Arduino-CMake from ros-indigo-rosserial-arduino
#ENV ARDUINOCMAKE_DIR /opt/ros/indigo/share/rosserial_arduino/arduino-cmake

# Build our catkin workspace from the /catkin_ws directory
WORKDIR /root

#
COPY scripts /root/scripts
#
COPY entry-point.sh .
RUN chmod +x entry-point.sh
#
COPY build.sh .
RUN chmod +x build.sh
#
COPY run.sh .
RUN chmod +x run.sh

#
COPY .gitconfig /root/.gitconfig

RUN mkdir -p /catkin_ws


#### Gere les dépendances ROS/APT du projet ####
RUN /bin/bash -c "source scripts/create_overlay_ws.sh"

WORKDIR overlay_ws

RUN /bin/bash -c "source /opt/ros/indigo/setup.bash"

# url: http://docs.ros.org/independent/api/rosdep/html/commands.html#rosdep-usage
RUN rosdep install --from-paths . --ignore-src --rosdistro indigo
####

# http://stackoverflow.com/questions/20635472/using-the-run-instruction-in-a-dockerfile-with-source-does-not-work
#RUN /bin/bash -c "source /ros_entrypoint.sh"
#RUN /bin/bash -c "source /root/entry-point.sh"
#SHELL ["/bin/bash", "-c"]
#RUN . /root/entry-point.sh

# url: https://docs.docker.com/engine/reference/builder/
# Lancement du script de generation du répertoire 'ros_lib'
#ENTRYPOINT ["/root/entry-point.sh"]#
#ENTRYPOINT ["source", "/ros_entrypoint.sh"]
#CMD ["/bin/bash", "-c", "source /root/entry-point.sh"]
#ENTRYPOINT ["source", "/root/entry-point.sh"]

# url: https://github.com/osrf/docker_images/blob/d9efe4367b9d376fd97a154bdaba896ca0382645/ros/indigo/indigo-ros-core/Dockerfile
ENTRYPOINT ["/root/entry-point.sh"]
CMD ["bash"]
WORKDIR /root/