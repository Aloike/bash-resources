#!/bin/bash


FILE_BASH_RESOURCE="${HOME}/.bashrc"

THIS_SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"


# Check that there's no trace of the function to avoid multiple declarations
if [ "$(grep 'FILEPATH_CUSTOM_RESOURCES' ${HOME}/.bash*|wc -l)" != "0" ]
then
	echo "It looks like the function has already been declared!"
	echo "This script will be stopped to avoid multiple declarations."
	echo "If you want to re-run it, please clean your '${HOME}/.bash*' files first."
	exit 1
fi


# Add the function to the bash resources file
echo -en "\n\n" >> "${FILE_BASH_RESOURCE}"
cat << EOT >> "${FILE_BASH_RESOURCE}"
# This function enables bash custom prompt.
function	F_customPrompt_enable()
{
	# FILEPATH_CUSTOM_RESOURCES="\${HOME}/scripts/bash/resources/resources.sh"
	FILEPATH_CUSTOM_RESOURCES="__PLACEHOLDER_PATH_TO_CUSTOM_RESOURCES__"
	if [ ! -f "\${FILEPATH_CUSTOM_RESOURCES}" ]
	then
		echo "No custom bash resources file available at '\${FILEPATH_CUSTOM_RESOURCES}'."
	else
		source "\${FILEPATH_CUSTOM_RESOURCES}"
	fi
}
EOT

sed --in-place \
	-e 's@__PLACEHOLDER_PATH_TO_CUSTOM_RESOURCES__@'"${THIS_SCRIPTDIR}/resources.sh"'@' \
	"${FILE_BASH_RESOURCE}"



echo "Now reload your bash resources, for example by doing..."
echo -e "\n\t. ${FILE_BASH_RESOURCE}\n"
echo "... and you should be good to go. Then activate the custom prompt by"
echo "calling..."
echo -e "\n\tF_customPrompt_enable\n"
echo "... in your terminal."

