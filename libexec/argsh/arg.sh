#!/usr/bin/env bash
set -eu -o pipefail

export ARGSH_SOURCE
export ARGSH_FIELD_SEPERATOR
export ARGSH_ACTIONS
: "${ARGSH_SOURCE:="${BASH_SOURCE[-1]}"}"
: "${ARGSH_FIELD_SEPERATOR:=""}" # \u001E - Record Separator

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

# shellcheck disable=SC2034,SC2064,SC2154
_argsh_arguments() {
  local -r args="$(cat)"
  local file_error
  file_error="$(mktemp)"
  trap "rm ${file_error}" EXIT

  error() {
    local -r msg="$(sed 's/^getopt: //' "${file_error}")"
    [ -z "${msg}" ] || {
      _usage "${msg}"
      exit 2
    }
  }
  noop() {
    declare -n ref="${1}"
    ref="$(cat)"
  }

  local params getopt; getopt="$(awk -f "${ARGSH_LIBEXEC}"/libs/getopt.awk <<<"${args}")"
  params="$($getopt -- "$@" 2>"${file_error}" || true)"
  error >&2

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
      [ -n "${val}" ] || { ref=true; continue; }

      declare -f "${val}" &>/dev/null || {
        [ "${val}" == "" ] ||
          echo -e "[args][warning]\tfunction does not exists '${val}'" 1>&2
        val="noop"
      }

      # call val function
      "${val}" "${cmd}" "${opt}" <<<"${1}" 2>"${file_error}"
      error >&2
      shift
      continue
    fi

    ARGSH_ACTIONS+="${cmd}"$'\n'
  done

  ARGSH_ACTIONS="${ARGSH_ACTIONS-%$'\n'}"
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
}
