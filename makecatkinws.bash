#!/bin/bash
#
# Make a ROS Catkin workspace.
#
# Author: e.dortmans@fontys.nl

# Defaults
DIST=${ROS_DISTRO:-$(ls /opt/ros | head -1)} # ROS distribution
CATKINWS=sandbox # default name of workspace

# Commandline params
if [ $1 ]; then
CATKINWS=$1 # name of workspace
fi

#[ -d ${CATKINWS} ] && echo "Workspace '${CATKINWS}' already exists...quitting." && exit 0

if [ -d ${CATKINWS} ]; then
    # Skip when sandbox already exists
    echo "Workspace '${CATKINWS}' already exists...quitting."
else
    # If not then create workspace as overlay on ROS distro
    . /opt/ros/$DIST/setup.bash
    mkdir -p ${CATKINWS}/src
    cd ${CATKINWS}/src
    catkin_init_workspace
		wstool init
    cd ..
    catkin_make
    cd ..
    echo "Do not forget to source ${PWD}/${CATKINWS}/devel/setup.bash"
fi

