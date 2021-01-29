#!/bin/bash

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
	source <(kubectl completion bash)

	# Create an alias for `kubectl`
	alias k='kubectl'

	# extend shell completion to work with that alias
	complete -F __start_kubectl k

	# Create aliases related to context
	alias k_context_list='kubectl config get-contexts'
	alias k_context_switch='kubectl config use-context'

	# Create aliases related to namespaces
	alias k_namespace_list='kubectl get namespaces'
	alias k_namespace_switch='_k8s_namespace_use'


	g_k8s_aliases_enabled=1
	export g_k8s_aliases_enabled

	KUBE_PS1_ENABLED=on
	export KUBE_PS1_ENABLED
}

# ##############################################################################
# ##############################################################################

function	_k8s_namespace_use()
{
	pNamespace="$1"

	kubectl config use-context --current --namespace="${pNamespace}"
}
