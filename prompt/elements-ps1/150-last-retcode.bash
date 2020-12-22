#!/bin/bash

# Declare the function to be called by the PS1 prompt.
PROMPT_PS1_FUNCTIONS+=("_prompt_box_retCode")

# ##############################################################################
# ##############################################################################

# keep track of the last executed command
trap 'last_command=$current_command; current_command=$BASH_COMMAND' DEBUG

# ##############################################################################
# ##############################################################################

function _prompt_box_retCode()
{
	# echo "[_prompt_box_retCode] LAST_CMD_RETCODE=${LAST_CMD_RETCODE}"
	local lRetVal=$LAST_CMD_RETCODE

	# echo "[_prompt_box_retCode] LAST_CMD=${LAST_CMD}"
	local lCmd=`echo "${LAST_CMD}"|sed -e 's@^[[:space:]]*@@g'`

	# local lOutput=""
	# lOutput+="${_COL_CONTOUR}${C_BOX_DRAWINGS_LIGHT_VERTICAL}\n"
	_prompt_echo_startOfLine_emptyLine


	
	if [[ "${lRetVal}" = "0" ]]
	then
		_prompt_echo_startOfLine_last "${C_BLACK_RIGHT_POINTING_TRIANGLE}"

		# If exit code is 0 then just write a "OK" in a box
		# lOutput+="[${FMT_BLD}${COL_FG_GRN}OK${FMT_STD}${_COL_CONTOUR}]"
		_prompt_echo_box	\
			"${FMT_BLD}${COL_FG_GRN}"	\
			"OK"
	else
		# If exit code is not null, display the last command and
		# the exit code in boxes.

		# First line : Command : Draw the box containing the last cmd
		# lOutput+="[${FMT_STD}${current_command}${_COL_CONTOUR}]\n"

		_prompt_echo_startOfLine_intermediary
		_prompt_echo_box	\
			"${FMT_STD}"	\
			"${lCmd}"

		# # Second line : Exit code : Draw the horizontal line
		# lOutput+="${C_BOX_DRAWINGS_LIGHT_UP_AND_RIGHT}${C_BOX_DRAWINGS_LIGHT_HORIZONTAL}"

		# # Second line : Exit code : Draw the value in a box
		# lOutput+="[${FMT_STD}${FMT_BLD}${lRetVal}${FMT_STD}${_COL_CONTOUR}]"

		# Second line : Exit code : Draw another horizontal line
		# lOutput+="${C_BOX_DRAWINGS_LIGHT_HORIZONTAL}${C_BLACK_RIGHT_POINTING_TRIANGLE}"

		# # Second line : Exit code : Draw a blinking text.
		# lOutput+="${FMT_BLD}${FMT_BLI}${COL_FG_RED} An error occured.${FMT_STD}"

		_prompt_echo_startOfLine_last

		_prompt_echo_box	\
			"${FMT_STD}${FMT_BLD}"	\
			"${lRetVal}"

		_prompt_echo_boxSeparator

		_prompt_echo_box	\
			"${FMT_BLD}${FMT_BLI}${COL_FG_RED}"	\
			"An error occured."

	fi

	# lOutput+="${FMT_STD}\n"
	# echo -e "${lOutput}"

	_prompt_echo_emptyLine
	_prompt_echo_emptyLine
}

# ##############################################################################
# ##############################################################################
