# ##############################################################################
##  @see    https://www.thegeekstuff.com/2008/09/bash-shell-take-control-of-ps1-ps2-ps3-ps4-and-prompt_command/
#
# This file shall be included in your bashrc file ; for example :
# FILEPATH_PROMPT='/home/<username>/scripts/bash/prompt/prompt-v1.sh'
# if [ -f ${FILEPATH_PROMPT} ]; then
#     . ${FILEPATH_PROMPT}
# fi
# ##############################################################################

declare -a	PROMPT_PS1_FUNCTIONS

# ##############################################################################
# ##############################################################################

function _prompt_command()
{
	for i in `echo ${PROMPT_PS1_FUNCTIONS}|sed -e 's/@/\n/g'`
	do
		# echo "Calling '${i}'"
		${i}
	done

	_prompt_echo_emptyLine
}

# ##############################################################################
# ##############################################################################

function	_prompt_PS1_load_functions()
{
	echo "_prompt_PS1_load_functions called."

	echo "Reset PROMPT_COMMAND..."
	unset PROMPT_COMMAND

	DIR_PROMPT_ELEMENTS_PS1="${THIS_SCRIPTDIR}/elements-ps1"

	# Clear prompt functions list
	#unset $PROMPT_PS1_FUNCTIONS
	#export PROMPT_PS1_FUNCTIONS

	for lFile in `find ${DIR_PROMPT_ELEMENTS_PS1} -type f -iname '*.bash'|sort`
	do
		lFileName=`echo ${lFile}|sed 's@'"${THIS_SCRIPTDIR}"'/*@@'`
		F_action "Sourcing '${lFileName}'" \
			source "${lFile}"
	done


	local lTmpVar=""
	for i in "${PROMPT_PS1_FUNCTIONS[@]}"
	do
		if [ ! -z "${lTmpVar}" ]
		then
			# Add a separator
			lTmpVar+="@"
		fi

		# Add the function name
		lTmpVar+="${i}"
	done

	PROMPT_PS1_FUNCTIONS="${lTmpVar}"
	# export PROMPT_PS1_FUNCTIONS

	# echo "PROMPT_PS1_FUNCTIONS='${PROMPT_PS1_FUNCTIONS}'"
	export PROMPT_COMMAND="${PROMPT_COMMAND:-:};PROMPT_PS1_FUNCTIONS=${PROMPT_PS1_FUNCTIONS}"
}

# ##############################################################################
# ##############################################################################

THIS_SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"


#
#   Load common Bash declarations from the `scripts` directory
#

source "${THIS_SCRIPTDIR}/../chars.bash"
source "${THIS_SCRIPTDIR}/../colors.bash"


#
#   Load the scripts that create the PS1 prompt elements
#   It generates a Bash array that contains names of functions to be called to
#   print the full PS1 string.
#
# declare -a	PROMPT_PS1_FUNCTIONS

# DIR_PROMPT_ELEMENTS_PS1="${THIS_SCRIPTDIR}/elements-ps1"

# for lFile in `find ${DIR_PROMPT_ELEMENTS_PS1} -type f -iname '*.bash'|sort`
# do
# 	lFileName=`echo ${lFile}|sed 's@'"${THIS_SCRIPTDIR}"'/*@@'`
# 	F_action "Sourcing '${lFileName}'" \
# 		source "${lFile}"
# done
_prompt_PS1_load_functions


export PROMPT_SCREENSPLIT_ENABLED=false



##  The contents of the `PROMPT_COMMAND` variable are executed as a regular Bash
##  command just before Bash displays a prompt.
##
##  In the following, we:
##  + store the exit code of the last command that has been run in the
##    `LAST_CMD_RETCODE` variable;
##  + store the last command that has been run in the `LAST_CMD` variable;
##  + Call already defined commands (needed by the Kubernetes prompt element);
##  + Call all functions that display prompt elements.
export PROMPT_COMMAND="LAST_CMD_RETCODE=\$?;LAST_CMD=\"\$(fc -ln -0)\";${PROMPT_COMMAND:-:};_prompt_command"
# export PROMPT_COMMAND="LAST_CMD_RETCODE=\$?;current_command=\$BASH_COMMAND;${PROMPT_COMMAND:-:};_prompt_command"


# PS1 - Default interaction prompt
export PS1="    \[\r${_COL_CONTOUR}${C_BOX_DRAWINGS_LIGHT_VERTICAL_AND_RIGHT}${C_BOX_DRAWINGS_LIGHT_HORIZONTAL}${C_BLACK_RIGHT_POINTING_TRIANGLE}${FMT_BLD}${COL_FG_YLW} \]\$ \[${FMT_STD}\]"

# PS2 - Continuation interactive prompt
export PS2="   \[\r${_COL_CONTOUR}${C_BOX_DRAWINGS_LIGHT_VERTICAL_AND_RIGHT}${C_BOX_DRAWINGS_LIGHT_HORIZONTAL}${C_WHITE_RIGHT_POINTING_TRIANGLE}${FMT_STD}\] "

# PS3 - Prompt used by “select” inside shell script
# PS4 - Used by “set -x” to prefix tracing output
