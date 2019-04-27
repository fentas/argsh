#!/usr/bin/env bash

fixtures() {
  FIXTURE_ROOT="${BATS_TEST_DIRNAME}/fixtures/${1}"
  RELATIVE_FIXTURE_ROOT="${FIXTURE_ROOT#${BATS_CWD}/}"

  [ ! -d "${FIXTURE_ROOT}" ] || path_add "${FIXTURE_ROOT}/bin"
}

teardown() {
  path_remove "${FIXTURE_ROOT}/bin"
}

filter_control_sequences() {
  "${@}" 2>&1 | sed $'s,\x1b\\[[0-9;]*[a-zA-Z],,g'
  exit "${PIPESTATUS[0]}"
}

log_on_failure() {
  echo Failed with status "${status}" and output:
  echo "${output}"
}
path_add() {
  local -r path="${1:?}"

  PATH="${path}:${PATH}"
}

path_remove() {
  local -r path="${1:?}"

  PATH="${PATH//":${path}:"/":"}"
  PATH="${PATH/#"${path}:"/}"
  PATH="${PATH/%":${path}"/}"
}

path() {
  command -v "${1}"
}