#!/usr/bin/env bash

: "${PATH_BASE:="$(git rev-parse --show-toplevel)"}"

fixtures() {
  FIXTURE_ROOT="${BATS_TEST_DIRNAME}/fixtures/${1}"
  RELATIVE_FIXTURE_ROOT="${FIXTURE_ROOT#${BATS_CWD}/}"
}

filter_control_sequences() {
  "${@}" 2>&1 | sed $'s,\x1b\\[[0-9;]*[a-zA-Z],,g'
  exit "${PIPESTATUS[0]}"
}

log_on_failure() {
  echo Failed with status "${status}" and output:
  echo "${output}"
}