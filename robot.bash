#!/usr/bin/env bash
# Setup ROS robot environment

# read Robot config data
. ~/.robot

#-----------------------------------------------------------------------------#
#
# Following code copied and adapted from 'robot.sh' script
# Copyright (c) 2013-2015, Rethink Robotics
# 
#-----------------------------------------------------------------------------#

tf=$(tempfile)
trap "rm -f -- '${tf}'" EXIT

# If 'config' file specifies an ip address or hostname - unset any previously set
# ROS_IP and/or ROS_HOSTNAME.
# If 'config' file does not specify an ip address or hostname - use the
# previously specified ROS_IP/ROS_HOSTNAME environment variables.
if [ -n "${your_ip}" ] || [ -n "${your_hostname}" ]; then
	unset ROS_IP && unset ROS_HOSTNAME
else
	your_ip="${ROS_IP}" && your_hostname="${ROS_HOSTNAME}"
fi

# If argument provided, set robot_hostname to argument
# If argument is sim or local, set robot_hostname to localhost
if [ -n "${1}" ]; then
	if [[ "${1}" == "sim" ]] || [[ "${1}" == "local" ]]; then
		robot_hostname="localhost"
		if [[ -z ${your_ip} || "${your_ip}" == "192.168.XXX.XXX" ]] && \
		[[ -z ${your_hostname} || "${your_hostname}" == "my_computer.local" ]]; then
			your_hostname="localhost"
			your_ip=""
		fi
	else
		robot_hostname="${1}"
	fi
fi

topdir=$(basename $(readlink -f $(dirname ${BASH_SOURCE[0]})))

cat <<-EOF > ${tf}
	[ -s "\${HOME}"/.bashrc ] && source "\${HOME}"/.bashrc
	[ -s "\${HOME}"/.bash_profile ] && source "\${HOME}"/.bash_profile

	# if set, verify user has modified the robot_hostname
	if [ -n ${robot_hostname} ] && \
	[[ "${robot_hostname}" == "robot_hostname.local" ]]; then
		echo -ne "EXITING - Please edit 'config' file, modifying the \
'robot_hostname' variable to reflect robot's current hostname.\n"
		exit 1
	fi

	# if set, verify user has modified their ip address (your_ip)
	if [ -n ${your_ip} ] && [[ "${your_ip}" == "192.168.XXX.XXX" ]]; then
		echo -ne "EXITING - Please edit 'config' file, modifying the 'your_ip' \
variable to reflect your current IP address.\n"
		exit 1
	fi

	# if set, verify user has modified their computer hostname (your_hostname)
	if [ -n ${your_hostname} ] && \
	[[ "${your_hostname}" == "my_computer.local" ]]; then
		echo -ne "EXITING - Please edit 'config' file, modifying the \
'your_hostname' variable to reflect your current PC hostname.\n"
		exit 1
	fi

	# verify user does not have both their ip *and* hostname set
	if [ -n "${your_ip}" ] && [ -n "${your_hostname}" ]; then
		echo -ne "EXITING - Please edit 'config' file, modifying to specify \
*EITHER* your_ip or your_hostname.\n"
		exit 1
	fi

	# verify that one of your_ip, your_hostname, ROS_IP, or ROS_HOSTNAME is set
	if [ -z "${your_ip}" ] && [ -z "${your_hostname}" ]; then
		echo -ne "EXITING - Please edit 'config' file, modifying to specify \
your_ip or your_hostname.\n"
		exit 1	
	fi

	[ -n "${your_ip}" ] && export ROS_IP="${your_ip}"
	[ -n "${your_hostname}" ] && export ROS_HOSTNAME="${your_hostname}"
	[ -n "${robot_hostname}" ] && \
		export ROS_MASTER_URI="http://${robot_hostname}:11311"

	# setup the bash prompt
	export __ROS_PROMPT=\${__ROS_PROMPT:-0}
	[ \${__ROS_PROMPT} -eq 0 -a -n "\${PROMPT_COMMAND}" ] && \
		export __ORIG_PROMPT_COMMAND=\${PROMPT_COMMAND}

	__ros_prompt () {
		if [ -n "\${__ORIG_PROMPT_COMMAND}" ]; then
			eval \${__ORIG_PROMPT_COMMAND}
		fi
		if ! echo \${PS1} | grep '\[robot' &>/dev/null; then
			export PS1="\[\033[00;33m\][robot - \
\${ROS_MASTER_URI}]\[\033[00m\] \${PS1}"
		fi
	}

	if [ "\${TERM}" != "dumb" ]; then
		export PROMPT_COMMAND=__ros_prompt
		__ROS_PROMPT=1
	elif ! echo \${PS1} | grep '\[robot' &>/dev/null; then
		export PS1="[robot - \${ROS_MASTER_URI}] \${PS1}"
	fi

EOF

${SHELL} --rcfile ${tf}

rm -f -- "${tf}"
trap - EXIT
