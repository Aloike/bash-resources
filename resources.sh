#!/bin/bash

## To use this resources file, just 'source' it into your `~/.bashrc` file or
## any equivalent (eg. `~/.bash_profile`). For example, like this:
##
## FILEPATH_CUSTOM_RESOURCES="/home/${USER}/scripts/bash/resources/resources.sh"
## if [ -f ${FILEPATH_CUSTOM_RESOURCES} ]; then
##     source ${FILEPATH_CUSTOM_RESOURCES}
## else
##     echo "No custom bash resources file available at ${FILEPATH_CUSTOM_RESOURCES}"
## fi


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


# Determine the directory in which this script is
BASEDIR_RESOURCES="$(dirname $BASH_SOURCE)"



FILEPATH_ALIASES="${BASEDIR_RESOURCES}/aliases.sh"
F_action "Loading user aliases" source ${FILEPATH_ALIASES}


FILEPATH_FUNCTIONS="${BASEDIR_RESOURCES}/functions.sh"
F_action "Loading user functions" source ${FILEPATH_FUNCTIONS}


FILEPATH_PROMPT="${BASEDIR_RESOURCES}/prompt/prompt-v1.sh"
F_action "Loading Bash custom prompt" source ${FILEPATH_PROMPT}
