#!/usr/bin/env bash
# shellcheck disable=SC2034

_argsh_is_file() {
  local -n opt="${2}"
  local -r file="$(cat)"
  [ -f "${file}" ] || {
    echo "[ ${1} ] needs to be a file." 1>&2
    return
  }
  opt="${file}"
}

_argsh_is_directory() {
  local -n opt="${2}"
  local -r path="$(cat)"
  [ -d "${path}" ] || {
    echo "[ ${1} ] needs to be a directory." 1>&2
    return
  }
  opt="${path}"
}