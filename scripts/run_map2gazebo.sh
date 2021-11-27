#!/bin/bash -e

source /root/.bashrc
rosrun map_server map_server $(find /home -name $1)&
roslaunch map2gazebo map2gazebo.launch