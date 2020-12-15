#!/bin/bash

THIS_SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"


DIR_FUNCTIONS="${THIS_SCRIPTDIR}/functions.d"

for lFile in `find ${DIR_FUNCTIONS} -type f -iname *.bash|sort`
do
	lFileName=`echo ${lFile}|sed 's@'"${THIS_SCRIPTDIR}"'/*@@'`
	F_action "Sourcing '${lFileName}'" \
		source "${lFile}"
done
