# ##############################################################################
##  @see    https://github.com/jonmosco/kube-ps1/blob/master/kube-ps1.sh
# ##############################################################################

# Declare the function to be called by the PS1 prompt.
PROMPT_PS1_FUNCTIONS+=("bash_prompt_command_kubernetes")

# ##############################################################################
# ##############################################################################

# Default values for the prompt
# Override these values in ~/.zshrc or ~/.bashrc
KUBE_PS1_BINARY="${KUBE_PS1_BINARY:-kubectl}"
KUBE_PS1_SYMBOL_ENABLE="${KUBE_PS1_SYMBOL_ENABLE:-true}"
KUBE_PS1_SYMBOL_DEFAULT=${KUBE_PS1_SYMBOL_DEFAULT:-$'\u2388 '}
KUBE_PS1_SYMBOL_USE_IMG="${KUBE_PS1_SYMBOL_USE_IMG:-true}"
KUBE_PS1_NS_ENABLE="${KUBE_PS1_NS_ENABLE:-true}"
KUBE_PS1_CONTEXT_ENABLE="${KUBE_PS1_CONTEXT_ENABLE:-true}"
KUBE_PS1_PREFIX="${KUBE_PS1_PREFIX-(}"
KUBE_PS1_SEPARATOR="${KUBE_PS1_SEPARATOR-|}"
KUBE_PS1_DIVIDER="${KUBE_PS1_DIVIDER-:}"
KUBE_PS1_SUFFIX="${KUBE_PS1_SUFFIX-)}"
KUBE_PS1_KUBECONFIG_CACHE="${KUBECONFIG}"
KUBE_PS1_DISABLE_PATH="${HOME}/.kube/kube-ps1/disabled"
KUBE_PS1_LAST_TIME=0
KUBE_PS1_CLUSTER_FUNCTION="${KUBE_PS1_CLUSTER_FUNCTION}"
KUBE_PS1_NAMESPACE_FUNCTION="${KUBE_PS1_NAMESPACE_FUNCTION}"
PROMPT_FMT_K8S_CONTEXT="${PROMPT_FMT_K8S_CONTEXT-${COL_FG_MAG}}"
PROMPT_FMT_K8S_NAME="${PROMPT_FMT_K8S_NAME-${FMT_BLD}${COL_FG_WHT}}"
PROMPT_FMT_K8S_NAMESPACE="${PROMPT_FMT_K8S_NAMESPACE-${COL_FG_CYN}}"
PROMPT_FMT_K8S_SYMBOL="${PROMPT_FMT_K8S_SYMBOL-${COL_FG_BLU}}"


# Determine our shell
if [ "${ZSH_VERSION-}" ]; then
  KUBE_PS1_SHELL="zsh"
elif [ "${BASH_VERSION-}" ]; then
  KUBE_PS1_SHELL="bash"
fi

# ##############################################################################
# ##############################################################################

_kube_ps1_binary_check() {
  command -v $1 >/dev/null
}

# ##############################################################################
# ##############################################################################

_kube_ps1_get_context() {
  if [[ "${KUBE_PS1_CONTEXT_ENABLE}" == true ]]; then
    KUBE_PS1_CONTEXT="$(${KUBE_PS1_BINARY} config current-context 2>/dev/null)"
    # Set namespace to 'N/A' if it is not defined
    KUBE_PS1_CONTEXT="${KUBE_PS1_CONTEXT:-N/A}"

    if [[ ! -z "${KUBE_PS1_CLUSTER_FUNCTION}" ]]; then
      KUBE_PS1_CONTEXT=$($KUBE_PS1_CLUSTER_FUNCTION $KUBE_PS1_CONTEXT)
    fi
  fi
}

# ##############################################################################
# ##############################################################################

_kube_ps1_get_context_ns() {
  # Set the command time
  if [[ "${KUBE_PS1_SHELL}" == "bash" ]]; then
    if ((BASH_VERSINFO[0] >= 4 && BASH_VERSINFO[1] >= 2)); then
      KUBE_PS1_LAST_TIME=$(printf '%(%s)T')
    else
      KUBE_PS1_LAST_TIME=$(date +%s)
    fi
  elif [[ "${KUBE_PS1_SHELL}" == "zsh" ]]; then
    KUBE_PS1_LAST_TIME=$EPOCHSECONDS
  fi

  _kube_ps1_get_context
  _kube_ps1_get_ns
}

# ##############################################################################
# ##############################################################################

_kube_ps1_get_ns() {
  if [[ "${KUBE_PS1_NS_ENABLE}" == true ]]; then
    KUBE_PS1_NAMESPACE="$(${KUBE_PS1_BINARY} config view --minify --output 'jsonpath={..namespace}' 2>/dev/null)"
    # Set namespace to 'default' if it is not defined
    KUBE_PS1_NAMESPACE="${KUBE_PS1_NAMESPACE:-default}"

    if [[ ! -z "${KUBE_PS1_NAMESPACE_FUNCTION}" ]]; then
        KUBE_PS1_NAMESPACE=$($KUBE_PS1_NAMESPACE_FUNCTION $KUBE_PS1_NAMESPACE)
    fi
  fi
}

# ##############################################################################
# ##############################################################################

_kube_ps1_init() {
  [[ -f "${KUBE_PS1_DISABLE_PATH}" ]] && KUBE_PS1_ENABLED=off

  case "${KUBE_PS1_SHELL}" in
    "zsh")
      _KUBE_PS1_OPEN_ESC="%{"
      _KUBE_PS1_CLOSE_ESC="%}"
      _KUBE_PS1_DEFAULT_BG="%k"
      _KUBE_PS1_DEFAULT_FG="%f"
      setopt PROMPT_SUBST
      autoload -U add-zsh-hook
      add-zsh-hook precmd _kube_ps1_update_cache
      zmodload -F zsh/stat b:zstat
      zmodload zsh/datetime
      ;;
    "bash")
      _KUBE_PS1_OPEN_ESC=$'\001'
      _KUBE_PS1_CLOSE_ESC=$'\002'
      _KUBE_PS1_DEFAULT_BG=$'\033[49m'
      _KUBE_PS1_DEFAULT_FG=$'\033[39m'
      [[ $PROMPT_COMMAND =~ _kube_ps1_update_cache ]] || PROMPT_COMMAND="_kube_ps1_update_cache;${PROMPT_COMMAND:-:}"
      ;;
  esac
}

# ##############################################################################
# ##############################################################################
##
##  @brief  Draw the context box.
##
##  This box shows the selected context name. Context configuration can be found
##  in the `~/.kube/config` file.
##
_kube_ps1_box_context()
{
	if [[ "${KUBE_PS1_CONTEXT_ENABLE}" != true ]]
	then
		return
	fi

	local	lFormat="${PROMPT_FMT_K8S_CONTEXT}"
	local	lData="${KUBE_PS1_CONTEXT}"

	_prompt_echo_box	\
		"${lFormat}"	\
		"${lData}"
}

# ##############################################################################
# ##############################################################################
##
##  @brief  Draw the main box (with the "k8s" name in it).
##
_kube_ps1_box_name()
{
	# # Symbol
	# echo -en "${PROMPT_FMT_K8S_SYMBOL}$(_kube_ps1_symbol)"

	local	lFormat="${PROMPT_FMT_K8S_NAME}"
	local	lData=""
	
	# lData+="$(_kube_ps1_symbol) "
	lData+="k8s"

	_prompt_echo_box	\
		"${lFormat}"	\
		"${lData}"
}

# ##############################################################################
# ##############################################################################
##
##  @brief  Draw the namespace box.
##
##  This box shows the selected namespace. Available namespaces can be found
##  in the `~/.kube/config` file.
##
_kube_ps1_box_namespace()
{
	if [[ "${KUBE_PS1_NS_ENABLE}" != true ]]
	then
		return
	fi

	local	lFormat="${PROMPT_FMT_K8S_NAMESPACE}"
	local	lData="${KUBE_PS1_NAMESPACE}"

	_prompt_echo_box	\
		"${lFormat}"	\
		"${lData}"
}

# ##############################################################################
# ##############################################################################

_kube_ps1_file_newer_than() {
  local mtime
  local file=$1
  local check_time=$2

  if [[ "${KUBE_PS1_SHELL}" == "zsh" ]]; then
    mtime=$(zstat +mtime "${file}")
  elif stat -c "%s" /dev/null &> /dev/null; then
    # GNU stat
    mtime=$(stat -L -c %Y "${file}")
  else
    # BSD stat
    mtime=$(stat -L -f %m "$file")
  fi

  [[ "${mtime}" -gt "${check_time}" ]]
}

# ##############################################################################
# ##############################################################################

_kube_ps1_split() {
  type setopt >/dev/null 2>&1 && setopt SH_WORD_SPLIT
  local IFS=$1
  echo $2
}

# ##############################################################################
# ##############################################################################

_kube_ps1_symbol() {
  [[ "${KUBE_PS1_SYMBOL_ENABLE}" == false ]] && return

  case "${KUBE_PS1_SHELL}" in
    bash)
      if ((BASH_VERSINFO[0] >= 4)) && [[ $'\u2388 ' != "\\u2388 " ]]; then
        KUBE_PS1_SYMBOL="${KUBE_PS1_SYMBOL_DEFAULT}"
        # KUBE_PS1_SYMBOL=$'\u2388 '
        KUBE_PS1_SYMBOL_IMG=$'\u2638\ufe0f '
      else
        KUBE_PS1_SYMBOL=$'\xE2\x8E\x88 '
        KUBE_PS1_SYMBOL_IMG=$'\xE2\x98\xB8 '
      fi
      ;;
    zsh)
      KUBE_PS1_SYMBOL="${KUBE_PS1_SYMBOL_DEFAULT}"
      KUBE_PS1_SYMBOL_IMG="\u2638 ";;
    *)
      KUBE_PS1_SYMBOL="k8s"
  esac

  if [[ "${KUBE_PS1_SYMBOL_USE_IMG}" == true ]]; then
    KUBE_PS1_SYMBOL="${KUBE_PS1_SYMBOL_IMG}"
  fi

  echo "${KUBE_PS1_SYMBOL}"
}

# ##############################################################################
# ##############################################################################

_kube_ps1_update_cache() {
  local return_code=$?

  [[ "${KUBE_PS1_ENABLED}" == "off" ]] && return $return_code

  if ! _kube_ps1_binary_check "${KUBE_PS1_BINARY}"; then
    # No ability to fetch context/namespace; display N/A.
    KUBE_PS1_CONTEXT="BINARY-N/A"
    KUBE_PS1_NAMESPACE="N/A"
    return
  fi

  if [[ "${KUBECONFIG}" != "${KUBE_PS1_KUBECONFIG_CACHE}" ]]; then
    # User changed KUBECONFIG; unconditionally refetch.
    KUBE_PS1_KUBECONFIG_CACHE=${KUBECONFIG}
    _kube_ps1_get_context_ns
    return
  fi

  # kubectl will read the environment variable $KUBECONFIG
  # otherwise set it to ~/.kube/config
  local conf
  for conf in $(_kube_ps1_split : "${KUBECONFIG:-${HOME}/.kube/config}"); do
    [[ -r "${conf}" ]] || continue
    if _kube_ps1_file_newer_than "${conf}" "${KUBE_PS1_LAST_TIME}"; then
      _kube_ps1_get_context_ns
      return
    fi
  done

  return $return_code
}

# ##############################################################################
# ##############################################################################

_kubeon_usage() {
  cat <<"EOF"
Toggle kube-ps1 prompt on
Usage: kubeon [-g | --global] [-h | --help]
With no arguments, turn on kube-ps1 status for this shell instance (default).
  -g --global  turn on kube-ps1 status globally
  -h --help    print this message
EOF
}

# ##############################################################################
# ##############################################################################

_kubeoff_usage() {
  cat <<"EOF"
Toggle kube-ps1 prompt off
Usage: kubeoff [-g | --global] [-h | --help]
With no arguments, turn off kube-ps1 status for this shell instance (default).
  -g --global turn off kube-ps1 status globally
  -h --help   print this message
EOF
}

# ##############################################################################
# ##############################################################################

kubeon() {
  if [[ "${1}" == '-h' || "${1}" == '--help' ]]; then
    _kubeon_usage
  elif [[ "${1}" == '-g' || "${1}" == '--global' ]]; then
    rm -f -- "${KUBE_PS1_DISABLE_PATH}"
  elif [[ "$#" -ne 0 ]]; then
    echo -e "error: unrecognized flag ${1}\\n"
    _kubeon_usage
    return
  fi

  KUBE_PS1_ENABLED=on
}

# ##############################################################################
# ##############################################################################

kubeoff() {
  if [[ "${1}" == '-h' || "${1}" == '--help' ]]; then
    _kubeoff_usage
  elif [[ "${1}" == '-g' || "${1}" == '--global' ]]; then
    mkdir -p -- "$(dirname "${KUBE_PS1_DISABLE_PATH}")"
    touch -- "${KUBE_PS1_DISABLE_PATH}"
  elif [[ $# -ne 0 ]]; then
    echo "error: unrecognized flag ${1}" >&2
    _kubeoff_usage
    return
  fi

  KUBE_PS1_ENABLED=off
}

# ##############################################################################
# ##############################################################################

function	bash_prompt_command_kubernetes()
{
	if [ "${KUBE_PS1_ENABLED}" != "on" ]
	then
		return
	fi


	_prompt_echo_startOfLine_intermediary
	_kube_ps1_box_name


	# local KUBE_PS1
	# local KUBE_PS1_RESET_COLOR="${_KUBE_PS1_OPEN_ESC}${_KUBE_PS1_DEFAULT_FG}${_KUBE_PS1_CLOSE_ESC}"
	local KUBE_PS1_RESET_COLOR="${FMT_STD}"

	# Context
	_prompt_echo_boxSeparator
	_kube_ps1_box_context

	# Namespace
	_prompt_echo_boxSeparator
	_kube_ps1_box_namespace

	# echo -e "${KUBE_PS1}"
}

# ##############################################################################
# ##############################################################################

# Set kube-ps1 shell defaults
_kube_ps1_init

# Toggle kube-ps1 prompt on
# Made in the k8s_alias function: KUBE_PS1_ENABLED=on

# ##############################################################################
# ##############################################################################