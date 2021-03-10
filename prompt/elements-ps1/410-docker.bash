

PROMPT_PS1_FUNCTIONS+=("bash_prompt_command_docker")

# Set default format variables
# These values can be overridden in ~/.zshrc or ~/.bashrc
PROMPT_DOCKER_ENABLED=${PROMPT_DOCKER_ENABLED:-false}
PROMPT_FMT_DOCKER_ALIASES_ENABLED="${PROMPT_FMT_DOCKER_ALIASES_ENABLED-${COL_FG_GRN}}"
PROMPT_FMT_DOCKER_ALIASES_DISABLED="${PROMPT_FMT_DOCKER_ALIASES_DISABLED-${FMT_BLD}${COL_BG_RED}${COL_FG_BLK}}"

# ##############################################################################
# ##############################################################################

function	bash_prompt_command_docker()
{
	# If docker aliases are not enabled, just don't show the line
	if [ "${PROMPT_DOCKER_ENABLED}" = "false" ]
	then
		return
	fi


	#
	# Print the output
	#
	local lFormat=""
	local lData=""

	# Begin an intermediary line of prompt infos
	_prompt_echo_startOfLine_intermediary

	# First box of the line is a title with a color changing depending on
	# whether related aliases are enabled or not.
	local lLineTitleFormat=''
	if [ "${g_docker_aliases_enabled}" = "1" ]
	then
		lLineTitleFormat="${PROMPT_FMT_GIT_ALIASES_ENABLED}"
	else
		lLineTitleFormat="${PROMPT_FMT_GIT_ALIASES_DISABLED}"
	fi

	lLineTitleText="Docker"

	_prompt_echo_box	\
		"${lLineTitleFormat}"	\
		"${lLineTitleText}"


	# _prompt_echo_boxSeparator
	# _prompt_echo_box	\
	# 	"${PROMPT_FMT_GIT_LOCALREPO}"	\
	# 	"${lGitLocalRepo}"
}

# ##############################################################################
# ##############################################################################
