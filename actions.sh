#!/bin/bash


# ##############################################################################
# ##############################################################################
## This part of the script provides a F_action function to execute an operation
## and give a result with a message on the console, in an "init" style (title of
## the action on the left, result enclosed in brackets on the right).
## The `F_action` function is os-independent, it will source the right file and
## use the right functions depending on the OS.
##
## Usage : `F_action "Action description" action-command and arguments
OS_NAME=$(source /etc/os-release /etc/redhat-release ; echo ${NAME})
OS_ID_LIKE=$(source /etc/os-release /etc/redhat-release ; echo ${ID_LIKE})
echo "OS name : ${OS_NAME}"
echo "OS like : ${OS_ID_LIKE}"


# To have access to "status" traces
if [[ "${OS_ID_LIKE}" =~ .*debian.* ]]
then
	# This is a Debian/Ubuntu
	source /lib/lsb/init-functions

	function F_action()
	{
		log_action_begin_msg "$1"
		shift
		$@
		log_action_end_msg $?
	}

#elif [ -f /etc/redhat-release ]
elif [[ "${OS_ID_LIKE}" =~ .*fedora.* ]]
then
	# This is a Fedora/RedHat
	source /etc/init.d/functions

	function F_action()
	{
		local lMsg="$1"
		shift
		action "${lMsg}" $@
	}
else
	echo "${BASH_SOURCE} +${BASH_LINENO} : WARNING : Unknown os kind!"
fi
