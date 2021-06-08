
# Declare the function to be called by the PS1 prompt.
PROMPT_PS1_FUNCTIONS+=("_prompt_PS1_user_host_path")

# Set default format variables
PROMPT_FMT_HOST_KNOWN="${PROMPT_FMT_HOST_KNOWN-${FMT_STD}${COL_FG_CYN}}"
PROMPT_FMT_HOST_SERVER="${PROMPT_FMT_HOST_SERVER-${FMT_STD}${COL_FG_BLK}${COL_BG_ORG}}"
PROMPT_FMT_HOST_UNKNOWN="${PROMPT_FMT_HOST_UNKNOWN-${FMT_STD}${COL_FG_BLK}${COL_BG_RED}}"
PROMPT_FMT_PWD="${PROMPT_FMT_PWD-${COL_FG_YLW}}"
PROMPT_FMT_SEP_USERANDHOST="${PROMPT_FMT_SEP_USERANDHOST-${COL_FG_YLW}${FMT_BLD}}"
PROMPT_FMT_USERNAME="${PROMPT_FMT_USERNAME-${COL_FG_GRN}}"
PROMPT_FMT_USERNAME_ROOT="${PROMPT_FMT_USERNAME_ROOT-${FMT_STD}${COL_FG_BLK}${COL_BG_RED}}"

# ##############################################################################
# ##############################################################################

function _prompt_PS1_user_host_path()
{
	_prompt_echo_startOfLine_first
	_prompt_box_userAndHost
	_prompt_echo_boxSeparator
	_prompt_box_path
}

# ##############################################################################
# ##############################################################################

function    _prompt_box_path()
{
	local	lFormat="${PROMPT_FMT_PWD}"


	# Improve path display
	local lData="$(pwd)"
	lData="$(echo ${lData}|sed s@${HOME}@~@)"


	_prompt_echo_box	\
		"${lFormat}"	\
		"${lData}"
}

# ##############################################################################
# ##############################################################################

function    _prompt_box_userAndHost()
{
	local lData=""

	# Get the user name
	local lUsername="$(whoami)"

	# Set username format depending on whether it's root or not.
	case "${lUsername}" in
		"root")
			lData+="${PROMPT_FMT_USERNAME_ROOT}"
			;;
		*)
			lData+="${PROMPT_FMT_USERNAME}"
			;;
	esac
	lData+="${lUsername}${FMT_STD}"


	# Add a separator between username and hostname
	lData+="${PROMPT_FMT_SEP_USERANDHOST}@"


	#
	#   Prepare hostname string
	#

	# Get the hostname
	local	lHostnameFQDNS="$(hostname --fqdn| sed -e 's@[[:space:]]*$@@')"

	# Set hostname's format depending on whether it's known or not.
	case "${lHostnameFQDNS}" in
		"HP-x360")
			lData+="${PROMPT_FMT_HOST_KNOWN}"
			;;
		*)
			lData+="${PROMPT_FMT_HOST_UNKNOWN}"
			;;
	esac
	lData+="${lHostnameFQDNS}${FMT_STD}"

	#
	#   Print the box
	#

	# As we use different print formats in the same box, we pass them through
	# the `pData` parameter instead of the `pFormat`, which is kept empty.
	_prompt_echo_box	\
		""	\
		"${lData}"
}

# ##############################################################################
# ##############################################################################
