#!/bin/bash

##
##  @brief  This file contains functions used by other prompt scripts.
##

# ##############################################################################
# ##############################################################################
##
##  @brief  Draws a full "prompt box" (boxes in which data is presented in each
##          prompt line).
##
##  It takes two parameters :
##  @param  pFormat This is the first parameter. This string defines the display
##                  format of the data (color, etc.).
##  @param  pData   This string is the second parameter. It is the data to be
##                  displayed in the box.
##
function _prompt_echo_box()
{
	# Retrieve arguments
	pFormat="${1}"
	shift
	pData="${@}"

	# Draw the box opening
	_prompt_echo_box_begin

	# Print the box data
	_prompt_echo_box_data	\
		"${pFormat}"	\
		"${pData}"

	# Print the box end
	_prompt_echo_box_end
}

# ##############################################################################
# ##############################################################################
##
##  @brief  Draw the separator that starts a "prompt box" (boxes in which data
##          is presented in each prompt line).
##
function _prompt_echo_box_begin()
{
	echo -en "${_COL_CONTOUR}["
}

# ##############################################################################
# ##############################################################################
##
##  @brief  Draw the content of a "prompt box" (boxes in which data
##          is presented in each prompt line).
##
##  It takes two parameters :
##  @param  pFormat This is the first parameter. This string defines the display
##                  format of the data (color, etc.).
##  @param  pData   This string is the second parameter. It is the data to be
##                  displayed in the box.
##
function _prompt_echo_box_data()
{
	# Retrieve arguments
	pFormat="${1}"
	shift
	pData="${@}"

	# Prepare the string to be echoed
	local lVar=""
	lVar+="${pFormat}"
	lVar+="${pData}"
	lVar+="${FMT_STD}"

	# Echo the data
	echo -en "${lVar}"
}

# ##############################################################################
# ##############################################################################
##
##  @brief  Draw the separator that ends a "prompt box" (boxes in which data
##          is presented in each prompt line).
##
function _prompt_echo_box_end()
{
	echo -en "${_COL_CONTOUR}]"
}

# ##############################################################################
# ##############################################################################
##
##  @brief  Draw the separator between "prompt boxes" (boxes in which data is
##          presented).
##
function _prompt_echo_boxSeparator()
{
	echo -en "${_COL_CONTOUR}${C_BOX_DRAWINGS_LIGHT_HORIZONTAL}"
}

# ##############################################################################
# ##############################################################################
##
##  @brief  Prints an empty line.
##
function _prompt_echo_emptyLine()
{
	echo -e "${FMT_STD}" # Dirty fixup to print an empty line in the prompt...
}

# ##############################################################################
# ##############################################################################
##
##  @brief  Draw the start of line for an empty prompt line.
##
function _prompt_echo_startOfLine_emptyLine()
{
	echo -en "${_COL_CONTOUR}${C_BOX_DRAWINGS_LIGHT_VERTICAL}"
}

# ##############################################################################
# ##############################################################################
##
##  @brief  Draw the start of line for the first prompt line.
##
function _prompt_echo_startOfLine_first()
{
	echo -en "\n${_COL_CONTOUR}${C_BOX_DRAWINGS_LIGHT_DOWN_AND_RIGHT}"
	_prompt_echo_boxSeparator
}

# ##############################################################################
# ##############################################################################
##
##  @brief  Draw the start of line for an intermediary prompt line.
##
function _prompt_echo_startOfLine_intermediary()
{
	echo -en "\n${_COL_CONTOUR}${C_BOX_DRAWINGS_LIGHT_VERTICAL_AND_RIGHT}"
	_prompt_echo_boxSeparator
}

# ##############################################################################
# ##############################################################################
##
##  @brief  Draw the start of line for the last prompt line.
##
function _prompt_echo_startOfLine_last()
{
	echo -en "\n${_COL_CONTOUR}${C_BOX_DRAWINGS_LIGHT_UP_AND_RIGHT}"
	_prompt_echo_boxSeparator

	echo -en "$@"
}

# ##############################################################################
# ##############################################################################