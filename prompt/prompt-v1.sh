# This file shall be included in your bashrc file ; for example :
# FILEPATH_PROMPT='/home/<username>/scripts/bash/prompt/prompt-v1.sh'
# if [ -f ${FILEPATH_PROMPT} ]; then
#     . ${FILEPATH_PROMPT}
# fi
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


function	bash_prompt_command_gitInfos()
{
	local lGitStr=""
	local lGitPath="$(git rev-parse --show-toplevel 2>/dev/null)"
	if [ ! -z "${lGitPath}" ]
	then
		lGitLocalRepo=`basename ${lGitPath}`
		lGitBranch=`git branch|sed --quiet -e '/^\*/ s@\* @@p'`

		lGitPath=`pwd|sed -e 's@'"${lGitPath}"'@git:@' -e 's@/$@@'`

		local lVar=""
		lVar+="\n${_COL_CONTOUR}${C_BOX_DRAWINGS_LIGHT_VERTICAL_AND_RIGHT}"

                lVar+="${_COL_CONTOUR}${C_BOX_DRAWINGS_LIGHT_HORIZONTAL}["
		lVar+="${FMT_BLD}${COL_FG_RED}Git${FMT_STD}"
		lVar+="${_COL_CONTOUR}]"

                lVar+="${_COL_CONTOUR}${C_BOX_DRAWINGS_LIGHT_HORIZONTAL}["
		lVar+="${COL_FG_GRN}${lGitLocalRepo}"
		lVar+="${_COL_CONTOUR}]"

                lVar+="${_COL_CONTOUR}${C_BOX_DRAWINGS_LIGHT_HORIZONTAL}["
		lVar+="${COL_FG_YLW}${lGitBranch}"
		lVar+="${_COL_CONTOUR}]"

                lVar+="${_COL_CONTOUR}${C_BOX_DRAWINGS_LIGHT_HORIZONTAL}["
		lVar+="${COL_FG_YLW}${lGitPath}"
		lVar+="${_COL_CONTOUR}]"

		echo -en "${lVar}"
	fi
}



function _box_path()
{
#        # Improve path display
#        local lPWD="$(pwd)"
#        lPWD="$(echo ${lPWD}|sed s@^${HOME}@~@)"


        local lOutput=""
        lOutput+="${_COL_CONTOUR}["

        # Display path
        lOutput+="${COL_FG_LMAG}\w"

        # Separator at end of line
        lOutput+="${_COL_CONTOUR}]"

        echo -en "${lOutput}"
}



function _box_retCode()
{
        local lRetVal=$?
        if [[ "${lRetVal}" = "0" ]]
        then
                psLastRetCodeStr="${FMT_BLD}${COL_FG_GRN}OK${FMT_STD}"
        else
                psLastRetCodeStr="${FMT_BLD}${FMT_BLI}${COL_FG_RED}An error occured (ret=${lRetVal}).${FMT_STD}"
        fi

        local lOutput=""
        lOutput+="${_COL_CONTOUR}${C_BOX_DRAWINGS_LIGHT_VERTICAL}\n"
        lOutput+="${C_BOX_DRAWINGS_LIGHT_UP_AND_RIGHT}"
        lOutput+="${C_BOX_DRAWINGS_LIGHT_HORIZONTAL}${C_BLACK_RIGHT_POINTING_TRIANGLE}"
        lOutput+="[${psLastRetCodeStr}${_COL_CONTOUR}]${FMT_STD}\n"
        echo -e "${lOutput}"
}


function _box_userAndHost()
{
        local retval=""

        retval+=""
        retval+="${_COL_CONTOUR}["
        retval+="${COL_FG_GRN}$(whoami)"

        # Separator between username and hostname
        retval+="${COL_FG_YLW}${FMT_BLD}@"

        # Prepare hostname string
        # Display hostname
        local	lHostnameFQDNS="$(hostname --fqdn| sed -e 's@[[:space:]]*$@@')"
        case "${lHostnameFQDNS}" in
                "HP-x360")
                        retval+="${FMT_STD}${COL_FG_CYN}${lHostnameFQDNS}${FMT_STD}"
                        ;;
                *)
                        retval+="${FMT_STD}${COL_FG_BLK}${COL_BG_CYN}${lHostnameFQDNS}${FMT_STD}"
                        ;;
        esac

        retval+=""
        retval+="${_COL_CONTOUR}]"


        echo -en "${retval}"
}



function    _screen_split()
{
        local   lCharSeparator="#"
        echo -en "\e[36m"
        printf %"$COLUMNS"s |tr " " "${lCharSeparator}"
        echo -en "${FMT_STD}"
}



function bash_prompt_command()
{
        echo -e "\$(_box_retCode)\n"

        echo -en "\$(_screen_split)"
        echo -en "\$(_screen_split)"
        echo "\n"

        echo -en "${_COL_CONTOUR}${C_BOX_DRAWINGS_LIGHT_DOWN_AND_RIGHT}"
        echo -en "${C_BOX_DRAWINGS_LIGHT_HORIZONTAL}$(_box_userAndHost)"
        echo -en "${C_BOX_DRAWINGS_LIGHT_HORIZONTAL}$(_box_path)"
        echo -en "\$(bash_prompt_command_gitInfos)"
        echo -en "\n${_COL_CONTOUR}${C_BOX_DRAWINGS_LIGHT_VERTICAL}\n"
}



#export PROMPT_COMMAND="echo $(bash_prompt_command)"
export PROMPT_COMMAND=""
export PS1="\[$(bash_prompt_command)\n\]   \[\r${C_BOX_DRAWINGS_LIGHT_VERTICAL_AND_RIGHT}${C_BOX_DRAWINGS_LIGHT_HORIZONTAL}${C_BLACK_RIGHT_POINTING_TRIANGLE}${FMT_BLD}${COL_FG_YLW} \]\$ \[${FMT_STD}\]"
export PS2="   \[\r${_COL_CONTOUR}${C_BOX_DRAWINGS_LIGHT_VERTICAL_AND_RIGHT}${C_BOX_DRAWINGS_LIGHT_HORIZONTAL}${C_WHITE_RIGHT_POINTING_TRIANGLE}\] "
