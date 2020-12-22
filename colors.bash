#!/bin/bash


# ------------------------------------------------------------------------------
#   Bash control chars definitions
# ------------------------------------------------------------------------------

ESC_CHAR="\\e"	# Default is Linux definition.
# From https://stackoverflow.com/a/12099167
#ifeq ($(OS),Windows_NT)
#	echo "Windows not supported !"
#	exit 1
#else
	UNAME_S="$(uname -s)"
	if [[ "${UNAME_S}" == "Linux" ]]
	then
		ESC_CHAR="\\e"
	elif [[ "${UNAME_S}" == "Darwin" ]]
	then
		ESC_CHAR="\\033"
	fi
#endif


# Bash format definitions
FMT_STD="${ESC_CHAR}[0m"	# Default format
FMT_BLD="${ESC_CHAR}[1m"	# Bold
FMT_UDL="${ESC_CHAR}[4m"	# Underline
FMT_BLI="${ESC_CHAR}[5m"	# Blink


# Bash background colors list
COL_BG_BLK="${ESC_CHAR}[40m"	# Background black
COL_BG_RED="${ESC_CHAR}[41m"	# Background red
COL_BG_GRN="${ESC_CHAR}[42m"	# Background green
COL_BG_YLW="${ESC_CHAR}[43m"	# Background yellow
COL_BG_BLU="${ESC_CHAR}[44m"	# Background blue
COL_BG_MAG="${ESC_CHAR}[45m"	# Background magenta
COL_BG_CYN="${ESC_CHAR}[46m"	# Background cyan
COL_BG_WHT="${ESC_CHAR}[47m"	# Background white


# Bash foreground colors list
COL_FG_BLK="${ESC_CHAR}[30m"	# Foreground black
COL_FG_RED="${ESC_CHAR}[31m"	# Foreground red
COL_FG_GRN="${ESC_CHAR}[32m"	# Foreground green
COL_FG_YLW="${ESC_CHAR}[33m"	# Foreground yellow
COL_FG_BLU="${ESC_CHAR}[34m"	# Foreground blue
COL_FG_MAG="${ESC_CHAR}[35m"	# Foreground magenta
COL_FG_CYN="${ESC_CHAR}[36m"	# Foreground cyan
COL_FG_GRY="${ESC_CHAR}[90m"	# Foreground gray
COL_FG_WHT="${ESC_CHAR}[97m"	# Foreground white

COL_FG_LGRY="${ESC_CHAR}[37m"	# Foreground light gray
COL_FG_LRED="${ESC_CHAR}[91m"	# Foreground light red
COL_FG_LMAG="${ESC_CHAR}[95m"	# Foreground light magenta


# Bash "assembled colors" list
COL_CYN="${ESC_CHAR}[30;46m"
COL_GRE="${ESC_CHAR}[47m"
COL_GRN="${ESC_CHAR}[30;42m"
COL_ORG="${ESC_CHAR}[30;43m"
COL_MAG="${ESC_CHAR}[30;45m"
COL_YLW="${ESC_CHAR}[30;103m"


##  @brief  Control char to fill a line.
CLREOL="${ESC_CHAR}[K"