

PROMPT_PS1_FUNCTIONS+=("bash_prompt_command_gitInfos")

# Set default format variables
# These values can be overridden in ~/.zshrc or ~/.bashrc
PROMPT_FMT_GIT_ALIASES_ENABLED="${PROMPT_FMT_GIT_ALIASES_ENABLED-${COL_FG_GRN}}"
PROMPT_FMT_GIT_ALIASES_DISABLED="${PROMPT_FMT_GIT_ALIASES_DISABLED-${FMT_BLD}${COL_BG_RED}${COL_FG_BLK}}"
PROMPT_FMT_GIT_BRANCH="${PROMPT_FMT_GIT_BRANCH-${COL_FG_LGRY}}"
PROMPT_FMT_GIT_LOCALREPO="${PROMPT_FMT_GIT_LOCALREPO-${COL_FG_LMAG}}"
PROMPT_FMT_GIT_PATH="${PROMPT_FMT_GIT_PATH-${COL_FG_CYN}}"
PROMPT_GIT_SYMBOL_BRANCH="${PROMPT_GIT_SYMBOL_BRANCH-\u2387}"



# ##############################################################################
# ##############################################################################

function	bash_prompt_command_gitInfos()
{
	local lGitPath="$(git rev-parse --show-toplevel 2>/dev/null)"
	if [ ! -z "${lGitPath}" ]
	then
		lGitLocalRepo=`basename ${lGitPath}`
		lGitBranch=`git branch|sed --quiet -e '/^\*/ s@\* @@p'`

		lGitPath=`pwd|sed -e 's@'"${lGitPath}"'@git:@' -e 's@/$@@'`

		local lFormat=""
		local lData=""

		_prompt_echo_startOfLine_intermediary

		if [ "${g_git_aliases_enabled}" = "1" ]
		then
			# lVar+="${FMT_BLD}${COL_BG_GRN}${COL_FG_BLK}"
			lFormat="${PROMPT_FMT_GIT_ALIASES_ENABLED}"
		else
			# lVar+="${FMT_BLD}${COL_FG_RED}"
			lFormat="${PROMPT_FMT_GIT_ALIASES_DISABLED}"
		fi
		lData="Git"

		_prompt_echo_box	\
			"${lFormat}"	\
			"${lData}"

		_prompt_echo_boxSeparator
		_prompt_echo_box	\
			"${PROMPT_FMT_GIT_LOCALREPO}"	\
			"${lGitLocalRepo}"

		_prompt_echo_boxSeparator
		_prompt_echo_box	\
			"${PROMPT_FMT_GIT_BRANCH}"	\
			"${PROMPT_GIT_SYMBOL_BRANCH} ${lGitBranch}"

		_prompt_echo_boxSeparator
		_prompt_echo_box	\
			"${PROMPT_FMT_GIT_PATH}"	\
			"${lGitPath}"

		echo -en "${lVar}"
	fi
}

# ##############################################################################
# ##############################################################################
