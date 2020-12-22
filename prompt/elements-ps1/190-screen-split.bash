#!/bin/bash

# Declare the function to be called by the PS1 prompt.
PROMPT_PS1_FUNCTIONS+=("_prompt_PS1_screen_split")

# ##############################################################################
# ##############################################################################

# Set default variables values
PROMPT_SCREENSPLIT_ENABLED="${PROMPT_SCREENSPLIT_ENABLED-true}"

PROMPT_FMT_SCREENSPLIT="${PROMPT_FMT_SCREENSPLIT-${COL_FG_CYN}}"


# ##############################################################################
# ##############################################################################

function    _prompt_PS1_screen_split()
{
	if [[ "${PROMPT_SCREENSPLIT_ENABLED}" != true ]]
	then
		return
	fi

	_prompt_echo_emptyLine
	_prompt_screensplit_echo_separator
	_prompt_screensplit_echo_separator
	_prompt_echo_emptyLine
}

function	_prompt_screensplit_echo_separator()
{
	local   lCharSeparator="#"

	echo -en "${PROMPT_FMT_SCREENSPLIT}"
	printf %"$COLUMNS"s |tr " " "${lCharSeparator}"
	echo -e "${FMT_STD}"
}

# ##############################################################################
# ##############################################################################