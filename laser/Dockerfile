# LASER

FROM li3ds/ros:indigo

# Build our catkin workspace from the /catkin_ws directory
WORKDIR /root

RUN mkdir -p /catkin_ws

#
COPY scripts /root/scripts

#### Gere les dépendances ROS/APT du projet ####
RUN /bin/bash -c "source scripts/create_overlay_ws.sh"

WORKDIR overlay_ws

RUN /bin/bash -c "source /opt/ros/indigo/setup.bash"

# urls: 
# - http://docs.ros.org/independent/api/rosdep/html/commands.html#rosdep-usage
# - http://docs.ros.org/independent/api/rosdep/html/commands.html#options
RUN rosdep install --default-yes --from-paths . --ignore-src --rosdistro indigo
####

WORKDIR /root/

# url: https://github.com/osrf/docker_images/blob/d9efe4367b9d376fd97a154bdaba896ca0382645/ros/indigo/indigo-ros-core/Dockerfile
ENTRYPOINT ["/root/entry-point.sh"]
CMD ["bash"]

# EXPOSE 2368/udp
# EXPOSE 8308/udp

#
COPY entry-point.sh .
RUN chmod +x entry-point.sh
#
COPY build.sh .
RUN chmod +x build.sh
#
COPY run.sh .
RUN chmod +x run.sh