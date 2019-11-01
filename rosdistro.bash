#!/bin/bash
#
# Make a ROS Catkin workspace.
#
# Author: e.dortmans@fontys.nl

# Defaults
DIST=${ROS_DISTRO:-$(ls /opt/ros | head -1)} # ROS distribution

echo "${DIST}"


