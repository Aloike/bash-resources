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


# To have access to "status" traces
source /lib/lsb/init-functions


# Determine the directory in which this script is
BASEDIR_RESOURCES="$(dirname $BASH_SOURCE)"



FILEPATH_ALIASES="${BASEDIR_RESOURCES}/aliases.sh"
log_action_begin_msg "Loading user aliases"
. ${FILEPATH_ALIASES}
log_action_end_msg $?


FILEPATH_FUNCTIONS="${BASEDIR_RESOURCES}/functions.sh"
log_action_begin_msg "Loading user functions"
. ${FILEPATH_FUNCTIONS}
log_action_end_msg $?


FILEPATH_PROMPT="${BASEDIR_RESOURCES}/prompt/prompt-v1.sh"
log_action_begin_msg "Loading Bash custom prompt"
source ${FILEPATH_PROMPT}
log_action_end_msg $?
