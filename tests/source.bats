#!/usr/bin/env bats

load helper

@test "${ARGSH_TEST}: is executable" {
  run command -v "${ARGSH_TEST}"
  [ "${status}" -eq 0 ]
}

@test "no arguments prints message and usage instructions" {
  run "${ARGSH_TEST}"
  log_on_failure
  [ "${status}" -eq 1 ]
  [ "${lines[0]%% *}" == 'Usage:' ]
}

@test "-h and --help print help" {
  run "${ARGSH_TEST}" -h
  [ "${status}" -eq 0 ]
  [ "${#lines[@]}" -gt 3 ]
  [ "${lines[0]%% *}" == 'Usage:' ]
}

@test "invalid option prints message and usage instructions" {
  run filter_control_sequences "${ARGSH_TEST}" --invalid-option
  log_on_failure
  [ "${status}" -eq 2 ]
  [ "${lines[0]}" == "■■ unrecognized option '--invalid-option'" ]
  [ "${lines[1]%% *}" == 'Usage:' ]
}
