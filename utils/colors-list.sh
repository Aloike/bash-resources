#!/bin/bash

function	colors_ANSI()
{
	echo -e "\n\n\t ANSI colors\n"

	for val in $(seq 0 255)
	do
		if [[ $(echo "$val % 10"|bc) == 0 ]]
		then
			echo ""
		fi
		echo -en "\e[${val}m"'\\'"e[${val}m\e[0m   \t"
	done
	echo ""
}



function	colors_8bit()
{
	local lModulo=6

	echo -e "\n\n\t8-bit colors\n"


	echo -e "\t\tForeground codes\n"

	for val in $(seq 0 255)
	do
		#if [[ $val -eq 1 ]] || [[ $val -eq 9 ]] || [[ $val -eq 16 ]]
		if [[ $val -gt 0 ]] && [[ $val -lt 16 ]] && [[ $(echo "($val -16) % 8"|bc) == 0 ]]
		then
			echo ""
		#elif [[ $(echo "($val -16)"|bc) -ge 0 ]] && [[ $(echo "($val -16) % ${lModulo}"|bc) == 0 ]]
		#elif [[ $val -ge ${lModulo} ]] && [[ $(echo "($val -16) % ${lModulo}"|bc) == 0 ]]
#		elif [[ $val -le 16 ]] && [[ $(echo "($val) % 4"|bc) == 0 ]]
#		then
#			echo "br_std1"
		elif [[ $val -ge 16 ]] && [[ $(echo "($val -16) % ${lModulo}"|bc) == 0 ]]
		then
			echo ""
		fi

		echo -en "\e[38;5;${val}m"'\\'"e[38;5;${val}m\e[0m   \t"
	done
	echo ""

	echo -e "\n\n                Background codes\n"

	for val in $(seq 0 255)
	do
		if [[ $val -gt 0 ]] && [[ $val -lt 16 ]] && [[ $(echo "($val -16) % 8"|bc) == 0 ]]
		then
			echo ""
		elif [[ $val -ge 16 ]] && [[ $(echo "($val -16) % ${lModulo}"|bc) == 0 ]]
		then
			echo ""
		fi

		echo -en "\e[48;5;${val}m"'\\'"e[48;5;${val}m\e[0m   \t"
	done
	echo ""
}



#function	setColor()
#{
#	local R=$1
#	local G=$2
#	local B=$3
#
#	local lIsBackground=false
#	if [ ! -z "$4" ] && [[ $4 == true ]]
#	then
#		lIsBackground=true
#	fi
#
#	echo "R=${R}"
#	echo "G=${G}"
#	echo "B=${B}"
#	echo "lIsBackground=${lIsBackground}"
#}


colors_ANSI
colors_8bit


exit 0
