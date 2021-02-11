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

	# Create aliases related to namespaces
	alias k_namespace_list="${CMD_KUBECTL} get namespaces"
	alias k_namespace_switch='__k8s_namespace_use'


	g_k8s_aliases_enabled=1
	export g_k8s_aliases_enabled

	KUBE_PS1_ENABLED=on
	export KUBE_PS1_ENABLED
}

# ##############################################################################
# ##############################################################################

function	_k8s_applyRecursively()
{
	# Iterate over each parameter given to the function
	for lParam in "$@"
	do
		# If the parameter is a directory, then recursively call this
		# function.
		# Otherwise, try to apply the file.
		if [ -d "${lParam}" ]
		then
			for lDirEntry in `find "${lParam}" -mindepth 1 -maxdepth 1|sort`
			do
				_k8s_applyRecursively "${lDirEntry}"
			done
		else
			${CMD_KUBECTL} apply -f "${lParam}"
		fi
	done
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

