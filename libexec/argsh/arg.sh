#!/usr/bin/env bash
set -eu -o pipefail

export ARGSH_SOURCE
export ARGSH_FIELD_SEPERATOR
export ARGSH_ACTIONS
: "${ARGSH_SOURCE:="${BASH_SOURCE[-1]}"}"
: "${ARGSH_FIELD_SEPERATOR:=""}" # \u001E - Record Separator

_argsh_parse() {
  awk -f "${ARGSH_LIBEXEC}"/libs/parse.awk "${1}"
}

_argsh_declare() {
  eval "$(awk -f "${ARGSH_LIBEXEC}"/libs/declare.awk)"
}

_argsh_usage() {
  source /dev/stdin < <(awk -f "${ARGSH_LIBEXEC}/libs/usage.awk")
}

# shellcheck disable=SC2034
_argsh_arguments() {
  local -r args="$(awk \
    -v FS="${ARGSH_FIELD_SEPERATOR}" -v OFS="${ARGSH_FIELD_SEPERATOR}" '{
    print $1, $2, $3, $5
  }')"
  local file_error
  file_error="$(mktemp)"
  trap "rm ${file_error}" EXIT

  get() {
    local -r param="${1}" col="${2}"
    echo "${args}" |
      awk -v FS="${ARGSH_FIELD_SEPERATOR}" "\$1 == \"${param}\" || \$2 == \"${param}\" { print \$${col} }"
  }
  opts() {
    local -r col="${1}"
    echo "${args}" |
      awk -v FS="${ARGSH_FIELD_SEPERATOR}" "\$${col} { print \$${col} (\$4 ? \":\" : \"\") }" |
      paste -sd ,
  }
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

  local params
  params="$(getopt -o "$(opts 1)" -l "$(opts 2)" -- "$@" 2>"${file_error}" || true)"
  error >&2

  eval set -- "${params}"
  local opt val
  until [ "${1}" = '--' ]; do
    cmd="$(sed 's/^-*//' <<<"${1}")"
    shift

    if [ "${cmd}" == "h" ] || [ "${cmd}" == "help" ]; then
      _usage
      exit
    fi

    opt="$(get "${cmd}" 3)"
    if [ -n "${opt}" ]; then
      declare -n ref="${opt}"
      val="$(get "${cmd}" 4)"
      [ -n "${val}" ] || {
        ref=true
        continue
      }

      declare -f "${val}" &>/dev/null || {
        [ "${val}" == "" ] ||
          echo -e "[args][warning]\tfunction does not exists '${val}'" 1>&2
        val="noop"
      }
      # call val function
      "${val}" "${opt}" "${cmd}" <<<"${1}" 2>"${file_error}"
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
