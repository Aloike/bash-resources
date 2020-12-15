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


# Determine the directory in which this script is
BASEDIR_RESOURCES="$(dirname $BASH_SOURCE)"



# Must be the first to be loaded as it provides `F_action`.
FILEPATH_ACTIONS="${BASEDIR_RESOURCES}/actions.sh"
source ${FILEPATH_ACTIONS}


FILEPATH_ALIASES="${BASEDIR_RESOURCES}/aliases.sh"
F_action "Loading user aliases" source ${FILEPATH_ALIASES}


FILEPATH_FUNCTIONS="${BASEDIR_RESOURCES}/functions.sh"
F_action "Loading user functions" source ${FILEPATH_FUNCTIONS}


FILEPATH_PROMPT="${BASEDIR_RESOURCES}/prompt/prompt-v1.sh"
F_action "Loading Bash custom prompt" source ${FILEPATH_PROMPT}
