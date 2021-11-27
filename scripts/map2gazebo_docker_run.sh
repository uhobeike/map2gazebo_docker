#!/bin/bash -e

docker pull ubeike/ros-melodic-map2gazebo

xhost +local:docker
docker run -it --rm \
    -v $1:/home/catkin_ws/src/map2gazebo/models:rw \
    -v /tmp/.X11-unix:/tmp/.X11-unix:rw \
    -e DISPLAY=$DISPLAY \
    -e QT_X11_NO_MITSHM=1 \
    -e LIBGL_ALWAYS_INDIRECT=1 \
    --privileged \
    --net=host \
    --name raspicat_gmapping \
ubeike/ros-melodic-map2gazebo /bin/bash -i -c \
      "bash /run_map2gazebo.sh $2"
xhost -local:docker

killall -9 rosmaster