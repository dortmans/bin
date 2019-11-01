#!/bin/bash
#
# Make ROS workspaces.
#
# Author: e.dortmans@fontys.nl

# Defaults
DIST=${ROS_DISTRO:-$(ls /opt/ros | head -1)} # ROS distribution
CATKINWS=catkin_ws
ROSBUILDWS=rosbuild_ws

# Commandline params
if [ $1 ]; then
CATKINWS=$1
fi
if [ $2 ]; then
ROSBUILDWS=$2
fi

source /opt/ros/$DIST/setup.bash

###########################
# Create a catkin workspace
# http://www.ros.org/wiki/catkin/Tutorials/create_a_workspace
###########################
echo "### Create Catkin workspace: $CATKINWS ###"
mkdir -p $CATKINWS/src
cd $CATKINWS/src
wstool init
catkin_init_workspace
cd ..
catkin_make
. devel/setup.bash
cd ..

###########################
# Create rosbuild workspace on top of catkin workspace
# See: Developing rosbuild packages on top of groovy
# http://www.ros.org/wiki/catkin/Tutorials/using_rosbuild_with_catkin
###########################
echo "### Create Rosbuild workspace: $ROSBUILDWS ###"
mkdir $ROSBUILDWS
cd $ROSBUILDWS
rosws init . ../$CATKINWS/devel
# instead on top of groovy: rosws init . /opt/ros/groovy
mkdir sandbox
rosws set sandbox -y
rosws update
. setup.bash
# Make it permanent for new terminals
echo -e "\n# ROS workspace initialisation\nsource $PWD/setup.bash" >> ~/.bashrc
cd ..

###########################
echo -e "\n### ROS Environment variables ###"
printenv | grep ROS


