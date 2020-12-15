#!/bin/bash

# ##############################################################################
# ##############################################################################
##  @brief  This function declares short aliases for Kubernetes usage.
##
## Just call the function to declare various aliases.
##
## This function also exports the `g_k8s_aliases_enabled` variable set to `1`
## to let the environment know those aliases are available.
function	k8s_aliases()
{
	alias k='kubectl'

	g_k8s_aliases_enabled=1
	export g_k8s_aliases_enabled
}

# ##############################################################################
# ##############################################################################
