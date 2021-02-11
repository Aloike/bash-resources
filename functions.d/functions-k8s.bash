#!/bin/bash

CMD_KUBECTL='kubectl'
#CMD_KUBECTL='microk8s.kubectl'

# ##############################################################################
# ##############################################################################
##
##  @brief  This function declares short aliases for Kubernetes usage.
##
## Just call the function to declare various aliases.
##
## This function also exports the `g_k8s_aliases_enabled` variable set to `1`
## to let the environment know those aliases are available.
##
## It also enables the "kubernetes prompt" from my custom prompts dir by setting
## the `KUBE_PS1_ENABLED` variable to `on`.
##
##  @see    bash/resources/prompt/elements-ps1/400-kubernetes.bash
##
##  @par References
##  + https://kubernetes.io/docs/tasks/tools/install-kubectl/#enable-kubectl-autocompletion
##
function	k8s_aliases()
{
	# Source the completion script in your ~/.bashrc file
	source <(${CMD_KUBECTL} completion bash)

	# Create an alias for `kubectl`
	alias k="${CMD_KUBECTL}"

	# extend shell completion to work with that alias
	complete -F __start_kubectl k

	alias k_applyRecursively='_k8s_applyRecursively'

	# Create aliases related to context
	alias k_context_list="${CMD_KUBECTL} config get-contexts"
	alias k_context_switch="${CMD_KUBECTL} config use-context"

	alias k_deletePods_whereStatusFailed='kubectl delete pod --field-selector="status.phase==Failed"'

	alias k_getPods='kubectl get pods'
	alias k_getPods_byAge='kubectl get pods --sort-by=.status.startTime'

	# Create aliases related to namespaces
	alias k_namespace_list="${CMD_KUBECTL} get namespaces"
	alias k_namespace_switch='__k8s_namespace_use'


	alias k_ide_lens='kontena-lens'
	alias k_ide_octant='octant'


	g_k8s_aliases_enabled=1
	export g_k8s_aliases_enabled

	KUBE_PS1_ENABLED=on
	export KUBE_PS1_ENABLED
}

# ##############################################################################
# ##############################################################################

function	_k8s_applyRecursively()
{
	local lRet=0


	# Iterate over each parameter given to the function
	for lParam in "$@"
	do
		# If the parameter is a directory, then recursively call this
		# function.
		# Otherwise, try to apply the file.
		if [ -d "${lParam}" ]
		then
			echo -e "${COL_FG_BLU}+-- Entering directory: '${lParam}'${CLR_EOL}${FMT_CLR}"

			for lDirEntry in `find "${lParam}" -mindepth 1 -maxdepth 1|sort`
			do
				_k8s_applyRecursively "${lDirEntry}"
				lRet="$?"

				if [[ "$lRet" != "0" ]]
				then
					echo "Error!"
					return ${lRet}
				fi
			done
		elif [[ "${lParam}" =~ .*\.ya*ml$ ]]
		then
			echo -e "${COL_FG_BLU}+-- Applying file: '${lParam}'${CLR_EOL}${FMT_CLR}"
			kubectl apply -f "${lParam}" | lRet="$?" sed -e 's@.*@    +-- &@'	\
				| __k8s_applyRecursively_highlight_pattern 'configured$' "${COL_BG_CYN}"	\
				| __k8s_applyRecursively_highlight_pattern 'created$' "${COL_BG_GRN}"	\
				| __k8s_applyRecursively_highlight_pattern 'unchanged$' "${COL_BG_GRY}"	\
				| __k8s_applyRecursively_highlight_ifNoAnsiCode
			if [[ "$lRet" != "0" ]]
			then
				echo "Error!"
				return ${lRet}
			fi
		else
			echo -e "${COL_FG_ORG}+-- Unknown file type: '${lParam}'${CLR_EOL}${FMT_CLR}"
		fi
	done


	return ${lRet}
}

# ##############################################################################
# ##############################################################################

function	__k8s_applyRecursively_highlight_ifNoAnsiCode()
{
	read pInput     # from https://stackoverflow.com/a/11457183/1303262

	if [[ `echo -e "${pInput}" | sed -r "/\x1B\[([0-9]{1,3}(;[0-9]{1,2})?)?[mGK]/d"|wc -l` = "0" ]]
	then
		echo "${pInput}"
	else
		echo "${pInput}"        \
			| sed -e 's@\(^.*$\)@'"$(echo -e ${COL_BG_RED})"'\1'"$(echo -e ${FMT_CLR})@"
	fi
}

# ##############################################################################
# ##############################################################################

function	__k8s_applyRecursively_highlight_pattern()
{
	read pInput	# from https://stackoverflow.com/a/11457183/1303262

	pPattern="$1"
	shift
	pColor="$1"
	shift
	#pInput="$@"

	echo "${pInput}"	\
		| sed -e 's@\('"${pPattern}"'\)@'"$(echo -e ${pColor})"'\1'"$(echo -e ${FMT_CLR})@"
}

# ##############################################################################
# ##############################################################################

function	__k8s_namespace_use()
{
	pNamespace="$1"

	kubectl config set-context --current --namespace="${pNamespace}"
}

# ##############################################################################
# ##############################################################################

