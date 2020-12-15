
PROMPT_PS1_FUNCTIONS+=("_prompt_PS1_user_host_path")


function _prompt_PS1_user_host_path()
{
	echo -en "${_COL_CONTOUR}${C_BOX_DRAWINGS_LIGHT_DOWN_AND_RIGHT}"
	echo -en "${C_BOX_DRAWINGS_LIGHT_HORIZONTAL}$(_box_userAndHost)"
	echo -en "${C_BOX_DRAWINGS_LIGHT_HORIZONTAL}$(_box_path)"
}



function _box_path()
{
#	# Improve path display
	local lPWD="$(pwd)"
	lPWD="$(echo ${lPWD}|sed s@${HOME}@~@)"


	local lOutput=""
	lOutput+="${_COL_CONTOUR}["

	# Display path
	# lOutput+="${COL_FG_LMAG}\\w"
	lOutput+="${COL_FG_LMAG}${lPWD}"

	# Separator at end of line
	lOutput+="${_COL_CONTOUR}]"

	echo -en "${lOutput}"
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