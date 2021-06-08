#!/bin/bash

# ##############################################################################
# ##############################################################################
##  @brief  This function declares short aliases for Git usage.
##
## Just call the function to declare various aliases, mostly with two letters
## only.
## This function also exports the `g_git_aliases_enabled` variable set to `1`
## to let the environment know those aliases are available.
function	git_aliases()
{
	alias ga='git add'
	alias gb='git branch'
	alias gc='git checkout'
	alias gC='git commit'
	alias gd='git diff'
	alias gf='git fetch'
	alias gg='git gui'
	alias gk='gitk --all'
	alias gl='git log --graph --oneline --all --color --decorate'
	alias gm='git merge --no-ff --no-commit'
	alias gp='git pull'
	alias gP='git push'
	alias gs='git status'

	g_git_aliases_enabled=1
	export g_git_aliases_enabled
}

# ##############################################################################
# ##############################################################################
