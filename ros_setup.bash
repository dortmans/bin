#!/bin/bash
#
# Setup ROS workspace.
#
# Author: eric.dortmans@gmail.com

if [[ $_ == $0 ]]; then
	echo "USAGE: source $_ [workspace]"
	exit 1
fi

WORKSPACE=${HOME}/catkin_ws
if [ -n "${1}" ]; then
	WORKSPACE=${1}
fi

DISTRO=${ROS_DISTRO:-$(ls /opt/ros | head -1)} # ROS distribution

source /opt/ros/${DISTRO}/setup.bash
source ${WORKSPACE}/devel/setup.bash

