#!/usr/bin/env bash

_args_is_file() {
  local -n opt="${1}"
  local -r path_file="$(cat)"
  [ -f "${path_file}" ] || {
    echo "[ ${2} ] needs to be a file." 1>&2
    return
  }
  opt="${path_file}"
}

_args_array() {
  IFS="," read -r -a "${1}" <<<"$(cat)"
  unset IFS
}