#!/bin/bash

# ##############################################################################
# ##############################################################################
##  @brief  This function declares short aliases for Kubernetes usage.
##
## Just call the function to declare various aliases.
##
## This function also exports the `g_k8s_aliases_enabled` variable set to `1`
## to let the environment know those aliases are available.
##
##  @par References
##  + https://kubernetes.io/docs/tasks/tools/install-kubectl/#enable-kubectl-autocompletion
# ##############################################################################
function	k8s_aliases()
{
	# Source the completion script in your ~/.bashrc file
	source <(kubectl completion bash)

	# Create an alias for `kubectl`
	alias k='kubectl'

	# extend shell completion to work with that alias
	complete -F __start_kubectl k

	g_k8s_aliases_enabled=1
	export g_k8s_aliases_enabled
}

# ##############################################################################
# ##############################################################################
