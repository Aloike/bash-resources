
PROMPT_PS1_FUNCTIONS+=("bash_prompt_command_kubernetes")


function	bash_prompt_command_kubernetes()
{
	if [ "${g_k8s_aliases_enabled}" != "1" ]
	then
		return
	fi


	local lVar=""
	lVar+="\n${_COL_CONTOUR}${C_BOX_DRAWINGS_LIGHT_VERTICAL_AND_RIGHT}"

	lVar+="${_COL_CONTOUR}${C_BOX_DRAWINGS_LIGHT_HORIZONTAL}["
	if [ "${g_k8s_aliases_enabled}" = "1" ]
	then
		# lVar+="${FMT_BLD}${COL_BG_GRN}${COL_FG_BLK}"
        lVar+="${FMT_BLD}${COL_FG_GRN}"
	else
		lVar+="${FMT_BLD}${COL_FG_WHT}"
	fi
	lVar+="k8s${FMT_STD}"
	lVar+="${_COL_CONTOUR}]"

	echo -en "${lVar}"
}
