FROM osrf/ros:melodic-desktop-full

SHELL ["/bin/bash", "-c"]

ENV ROS_MASTER_URI=http://localhost:11311 \
  ROS_HOSTNAME=localhost

ARG USERNAME="root"
ENV USER=$USERNAME
ENV USERNAME=$USERNAME

RUN groupadd -g 1000 $USERNAME && \
  useradd -m -s /bin/bash -u 1000 -g 1000 -d /home/$USERNAME $USERNAME && \
  echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers && \
  chown -R $USERNAME:$USERNAME /home/$USERNAME


RUN apt update && \ 
  apt install -y \
  python-pip \
  python3-pip \
  ros-melodic-map-server \
  python-catkin-tools && \
  pip3 install rospkg catkin_pkg && \
  pip install trimesh && \
  pip install numpy && \
  pip install pycollada && \
  pip install scipy

USER $USERNAME
RUN mkdir -p $HOME/catkin_ws/src && \
  echo "source /opt/ros/melodic/setup.bash" >> $HOME/.bashrc && \
  echo "source $HOME/catkin_ws/devel/setup.bash" >> $HOME/.bashrc && \
  cd $HOME/catkin_ws/src && \
  git clone https://github.com/shilohc/map2gazebo.git && \
  git clone https://github.com/uhobeike/map2gazebo_docker && \
  source /opt/ros/$ROS_DISTRO/setup.bash && cd $HOME/catkin_ws && \
  rosdep update && \
  rosdep install -r -y --from-paths --ignore-src . && \
  catkin build && \
  sudo rm -rf /var/lib/apt/lists/*

WORKDIR /home/$USERNAME/catkin_ws
CMD ["/bin/bash"]
# How to local build
# docker build --build-arg USERNAME=$USER -t ubeike/ros-melodic-map2gazebo -f Dockerfile .