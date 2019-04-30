#!/usr/bin/env bash
# shellcheck disable=SC2034

_argsh_is_file() {
  local -n opt="${2}"
  [ -f "${opt}" ] || {
    echo "[ ${1} ] needs to be a file." 1>&2
    return 127
  }
}

_argsh_is_directory() {
  local -n opt="${2}"
  [ -d "${opt}" ] || {
    echo "[ ${1} ] needs to be a directory." 1>&2
    return 127
  }
}

_argsh_is_executable() {
  local -n opt="${2}"
  command -v "${opt}" &>/dev/null || {
    echo "[ ${1} ] needs to be executable." 1>&2
    return 1
  }
}