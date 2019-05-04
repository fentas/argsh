#!/usr/bin/env bash
# shellcheck disable=SC2064
set -eu -o pipefail

export ARGSH_SOURCE
export ARGSH_FIELD_SEPERATOR
export ARGSH_ACTIONS
: "${ARGSH_SOURCE:="${BASH_SOURCE[-1]}"}"
: "${ARGSH_FIELD_SEPERATOR:=""}" # \u001E - Record Separator

_argsh_error() {
  [ -n "${1-}" ] || {
    file="$(mktemp)"; trap "rm $file" EXIT; echo "${file}"
    return
  }
  local -r msg="$(sed 's/^getopt: //' "${1:?}")"
  [ -z "${msg}" ] || {
    _usage "${msg}" >&2
    exit 2
  }
}

_argsh_settings() {
  awk -f "${ARGSH_LIBEXEC}"/libs/settings.awk "${1}"
}

_argsh_parse() {
  awk -f "${ARGSH_LIBEXEC}"/libs/parse.awk "${1}"
}

_argsh_declare() {
  eval "$(awk -f "${ARGSH_LIBEXEC}"/libs/declare.awk)"
}

_argsh_usage() {
  source /dev/stdin < <(awk -f "${ARGSH_LIBEXEC}/libs/usage.awk")
}

# shellcheck disable=SC2034,SC2154
_argsh_arguments() {
  local -r args="$(cat)"
  local file_error

  local params getopt error; error="$(_argsh_error)"
  getopt="$(awk -f "${ARGSH_LIBEXEC}"/libs/getopt.awk <<<"${args}")"
  params="$($getopt -- "$@" 2>"${error}" || _argsh_error "${error}")"

  eval set -- "${params}"
  local cmd opt val
  until [ "${1}" = '--' ]; do
    eval "$(awk -v arg="${1}" -f "${ARGSH_LIBEXEC}"/libs/arguments.awk <<<"${args}")"
    shift

    if [ "${cmd}" == "h" ] || [ "${cmd}" == "help" ]; then
      _usage
      exit
    fi

    if [ -n "${opt}" ]; then
      declare -n ref="${opt}"
      ref=true
      [ -n "${val}" ] || continue
      ref="${1}"
      shift; continue
    fi

    ARGSH_ACTIONS+="${cmd}"$'\n'
  done

  ARGSH_ACTIONS="${ARGSH_ACTIONS-%$'\n'}"
}

_argsh_validators() {
  local val cmd opt error; error="$(_argsh_error)"
  while IFS= read -r variables; do
    eval "${variables}"

    declare -f "${val}" &>/dev/null || {
      [ "${val}" == "" ] || echo -e "[argsh][warning]\tfunction does not exists '${val}'" 1>&2
      continue
    }
    "${val}" "${cmd}" "${opt}" 2>"${error}" || _argsh_error "${error}"
  done < <(awk -f "${ARGSH_LIBEXEC}"/libs/validators.awk)
}

_argsh() {
  # TODO: do not fail of there is no argsh comment
  local -r args="$(_argsh_parse "${ARGSH_SOURCE}")"

  _argsh_declare \
    <<<"${args}"
  _argsh_usage \
    <<<"${args}"
  [ -n "${*}" ] || {
    _usage
    exit 1
  }
  _argsh_arguments "${@}" \
    <<<"${args}"
  _argsh_validators \
    <<<"${args}"
}
