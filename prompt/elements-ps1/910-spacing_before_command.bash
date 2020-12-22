#!/bin/bash

# Declare the function to be called by the PS1 prompt.
PROMPT_PS1_FUNCTIONS+=("_prompt_PS1_spacing_before_command")


# ##############################################################################
# ##############################################################################

function    _prompt_PS1_spacing_before_command()
{
	_prompt_echo_emptyLine
	_prompt_echo_startOfLine_emptyLine
}

# ##############################################################################
# ##############################################################################