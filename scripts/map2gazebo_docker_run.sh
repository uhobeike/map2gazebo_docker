#!/bin/bash -e

docker pull ubeike/ros-melodic-map2gazebo

xhost +local:docker
docker run -it --rm \
    -v $1/map:/home/catkin_ws/src/map2gazebo/map:rw \
    -v $1/config:/home/catkin_ws/src/map2gazebo/config:rw \
    -v $1/outputs/models:/home/catkin_ws/src/map2gazebo/models:rw \
    -e LIBGL_ALWAYS_INDIRECT=1 \
    --privileged \
    --net=host \
    --name raspicat_map2gazebo \
ubeike/ros-melodic-map2gazebo /bin/bash -i -c \
      "bash /run_map2gazebo.sh $2"
xhost -local:docker

killall -9 rosmaster