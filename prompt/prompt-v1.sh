# ##############################################################################
##  @see    https://www.thegeekstuff.com/2008/09/bash-shell-take-control-of-ps1-ps2-ps3-ps4-and-prompt_command/
#
# This file shall be included in your bashrc file ; for example :
# FILEPATH_PROMPT='/home/<username>/scripts/bash/prompt/prompt-v1.sh'
# if [ -f ${FILEPATH_PROMPT} ]; then
#     . ${FILEPATH_PROMPT}
# fi
# ##############################################################################
#
# Bash fonts
#
FMT_STD='\e[0m'	# Default format
FMT_BLD='\e[1m'	# Bold
FMT_UDL='\e[4m'	# Underline
FMT_BLI='\e[5m'	# Blink


COL_BG_BLK='\e[40m'	# Background black
COL_BG_RED='\e[41m'	# Background red
COL_BG_GRN='\e[42m'	# Background green
COL_BG_YLW='\e[43m'	# Background yellow
COL_BG_BLU='\e[44m'	# Background blue
COL_BG_MAG='\e[45m'	# Background magenta
COL_BG_CYN='\e[46m'	# Background cyan
COL_BG_WHT='\e[47m'	# Background white


COL_FG_BLK='\e[30m'	# Foreground black
COL_FG_RED='\e[31m'	# Foreground red
COL_FG_GRN='\e[32m'	# Foreground green
COL_FG_YLW='\e[33m'	# Foreground yellow
COL_FG_BLU='\e[34m'	# Foreground blue
COL_FG_MAG='\e[35m'	# Foreground magenta
COL_FG_CYN='\e[36m'	# Foreground cyan
COL_FG_WHT='\e[37m'	# Foreground white

COL_FG_LRED='\e[91m'	# Foreground light red
COL_FG_LMAG='\e[95m'	# Foreground light magenta



#
# Unicode chars convenience declarations
#

# From "Arrows" table
C_RIGHTWARDS_ARROW=`printf '\xe2\x86\x92'`
C_DOWNWARDS_ARROW_WITH_TIP_RIGHTWARDS=`printf '\xe2\x86\xb3'`

# From "Box Drawing" table
C_BOX_DRAWINGS_LIGHT_HORIZONTAL=`printf '\xe2\x94\x80'`
C_BOX_DRAWINGS_LIGHT_VERTICAL=`printf '\xe2\x94\x82'`
C_BOX_DRAWINGS_LIGHT_DOWN_AND_RIGHT=`printf '\xe2\x94\x8c'`
C_BOX_DRAWINGS_HEAVY_DOWN_AND_RIGHT=`printf '\xe2\x94\x8f'`
C_BOX_DRAWINGS_LIGHT_UP_AND_RIGHT=`printf '\xe2\x94\x94'`
C_BOX_DRAWINGS_LIGHT_VERTICAL_AND_RIGHT=`printf '\xe2\x94\x9c'`
C_BLACK_RIGHT_POINTING_TRIANGLE=`printf '\xe2\x96\xb6'`
C_WHITE_RIGHT_POINTING_TRIANGLE=`printf '\xe2\x96\xb7'`
C_BLACK_RIGHT_POINTING_POINTER=`printf '\xe2\x96\xba'`



#
# local variables declaration
#
_COL_CONTOUR="${COL_FG_LRED}"



# keep track of the last executed command
trap 'last_command=$current_command; current_command=$BASH_COMMAND' DEBUG

function _box_retCode()
{
	local lRetVal=$?

	local lOutput=""
	lOutput+="${_COL_CONTOUR}${C_BOX_DRAWINGS_LIGHT_VERTICAL}\n"


	if [[ "${lRetVal}" = "0" ]]
	then
		# If exit code is 0 then just write a "OK" in a box
		lOutput+="${C_BOX_DRAWINGS_LIGHT_UP_AND_RIGHT}"
		lOutput+="${C_BOX_DRAWINGS_LIGHT_HORIZONTAL}${C_BLACK_RIGHT_POINTING_TRIANGLE}"
		lOutput+="[${FMT_BLD}${COL_FG_GRN}OK${FMT_STD}${_COL_CONTOUR}]"
	else
		# If exit code is not null, display the last command and
		# the exit code in boxes.

		# First line : Command : Draw the horizontal line
		lOutput+="${_COL_CONTOUR}${C_BOX_DRAWINGS_LIGHT_VERTICAL_AND_RIGHT}"
		lOutput+="${C_BOX_DRAWINGS_LIGHT_HORIZONTAL}"

		# First line : Command : Draw the box containing the last cmd
		lOutput+="[${FMT_STD}${current_command}${_COL_CONTOUR}]\n"

		# Second line : Exit code : Draw the horizontal line
		lOutput+="${C_BOX_DRAWINGS_LIGHT_UP_AND_RIGHT}${C_BOX_DRAWINGS_LIGHT_HORIZONTAL}"

		# Second line : Exit code : Draw the value in a box
		lOutput+="[${FMT_STD}${FMT_BLD}${lRetVal}${FMT_STD}${_COL_CONTOUR}]"

		# Second line : Exit code : Draw another horizontal line
		lOutput+="${C_BOX_DRAWINGS_LIGHT_HORIZONTAL}${C_BLACK_RIGHT_POINTING_TRIANGLE}"

		# Second line : Exit code : Draw a blinking text.
		lOutput+="${FMT_BLD}${FMT_BLI}${COL_FG_RED} An error occured.${FMT_STD}"
	fi

	lOutput+="${FMT_STD}\n"
	echo -e "${lOutput}"
}



function    _screen_split()
{
        local   lCharSeparator="#"
        echo -en "\e[36m"
        printf %"$COLUMNS"s |tr " " "${lCharSeparator}"
        echo -en "${FMT_STD}"
}



function _prompt_PS1()
{
		echo -e "\$(_box_retCode)\n"

#        echo -en "\$(_screen_split)"
#        echo -en "\$(_screen_split)"
#        echo "\n"

		for i in "${PROMPT_PS1_FUNCTIONS[@]}"
		do   
			echo -en "\$(${i})"
			# echo -en "\${PROMPT_FUNCTIONS[$i]}"
		done

		echo -en "\n${_COL_CONTOUR}${C_BOX_DRAWINGS_LIGHT_VERTICAL}\n"
}


THIS_SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"


declare -a	PROMPT_PS1_FUNCTIONS

DIR_PROMPT_ELEMENTS_PS1="${THIS_SCRIPTDIR}/elements-ps1"

for lFile in `find ${DIR_PROMPT_ELEMENTS_PS1} -type f -iname *.bash|sort`
do
	lFileName=`echo ${lFile}|sed 's@'"${THIS_SCRIPTDIR}"'/*@@'`
	F_action "Sourcing '${lFileName}'" \
		source "${lFile}"
done



#export PROMPT_COMMAND="echo $(bash_prompt_command)"
export PROMPT_COMMAND=""

# PS1 - Default interaction prompt
export PS1="\[$(_prompt_PS1)\n\]   \[\r${C_BOX_DRAWINGS_LIGHT_VERTICAL_AND_RIGHT}${C_BOX_DRAWINGS_LIGHT_HORIZONTAL}${C_BLACK_RIGHT_POINTING_TRIANGLE}${FMT_BLD}${COL_FG_YLW} \]\$ \[${FMT_STD}\]"

# PS2 - Continuation interactive prompt
export PS2="   \[\r${_COL_CONTOUR}${C_BOX_DRAWINGS_LIGHT_VERTICAL_AND_RIGHT}${C_BOX_DRAWINGS_LIGHT_HORIZONTAL}${C_WHITE_RIGHT_POINTING_TRIANGLE}${FMT_STD}\] "

# PS3 - Prompt used by “select” inside shell script
# PS4 - Used by “set -x” to prefix tracing output
