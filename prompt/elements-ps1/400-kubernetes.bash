
PROMPT_PS1_FUNCTIONS+=("bash_prompt_command_kubernetes")


function	bash_prompt_command_kubernetes()
{
	# local lGitStr=""
	# local lGitPath="$(git rev-parse --show-toplevel 2>/dev/null)"
	# if [ ! -z "${lGitPath}" ]
	# then
	# 	lGitLocalRepo=`basename ${lGitPath}`
	# 	lGitBranch=`git branch|sed --quiet -e '/^\*/ s@\* @@p'`

	# 	lGitPath=`pwd|sed -e 's@'"${lGitPath}"'@git:@' -e 's@/$@@'`

		local lVar=""
		lVar+="\n${_COL_CONTOUR}${C_BOX_DRAWINGS_LIGHT_VERTICAL_AND_RIGHT}"

		lVar+="${_COL_CONTOUR}${C_BOX_DRAWINGS_LIGHT_HORIZONTAL}["
	# 	if [ "${g_git_aliases_enabled}" = "1" ]
	# 	then
	# 		lVar+="${FMT_BLD}${COL_BG_GRN}${COL_FG_BLK}"
	# 	else
	# 		lVar+="${FMT_BLD}${COL_FG_RED}"
	# 	fi
		lVar+="k8s${FMT_STD}"
		lVar+="${_COL_CONTOUR}]"

	#	lVar+="${_COL_CONTOUR}${C_BOX_DRAWINGS_LIGHT_HORIZONTAL}["
	# 	lVar+="${COL_FG_GRN}${lGitLocalRepo}"
	# 	lVar+="${_COL_CONTOUR}]"

	#	lVar+="${_COL_CONTOUR}${C_BOX_DRAWINGS_LIGHT_HORIZONTAL}["
	# 	lVar+="${COL_FG_YLW}${lGitBranch}"
	# 	lVar+="${_COL_CONTOUR}]"

	#	lVar+="${_COL_CONTOUR}${C_BOX_DRAWINGS_LIGHT_HORIZONTAL}["
	# 	lVar+="${COL_FG_YLW}${lGitPath}"
	# 	lVar+="${_COL_CONTOUR}]"

		echo -en "${lVar}"
	# fi
}