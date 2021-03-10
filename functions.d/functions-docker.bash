#!/bin/bash

function    _F_docker_containerIdFromImageName()
{
	pImageName="${1}"

	docker ps|grep "${pImageName}"|awk '{print $1}'
}

function    _F_docker_folderName()
{
	basename $(pwd)
}

function    F_docker_container_build()
{
	local lContainerImageName=`_F_docker_folderName`
	echo "+-- Assumed image name: '${lContainerImageName}'"


	docker build . -t ${lContainerImageName}

	return $?
}

function    F_docker_container_buildNoCache()
{
	local lContainerImageName=`_F_docker_folderName`
	echo "+-- Assumed image name: '${lContainerImageName}'"


	docker build . --no-cache -t ${lContainerImageName}

	return $?
}

function    F_docker_container_exec()
{
	local lContainerImageName="${1:-_F_docker_folderName}"
	echo "+-- Assumed image name: '${lContainerImageName}'"

	local lContainerID=`_F_docker_containerIdFromImageName "${lContainerImageName}"`
	echo "+-- Container ID      : '${lContainerID}'"


	docker exec -it ${lContainerID} bash

	return $?
}

function    F_docker_container_run()
{
	local lContainerImageName=`_F_docker_folderName`
	echo "+-- Assumed image name: '${lContainerImageName}'"


	docker run --rm -it ${lContainerImageName}

	return $?
}

function    docker_aliases_enable()
{
	alias d_container-build='F_docker_container_build'
	alias d_container-buildNoCache='F_docker_container_buildNoCache'
	alias d_container-exec='F_docker_container_exec'
	alias d_container-run='F_docker_container_run'
	alias d_ps='docker ps'

	g_docker_aliases_enabled=1
	export g_docker_aliases_enabled

	PROMPT_DOCKER_ENABLED=true
	export PROMPT_DOCKER_ENABLED
}
