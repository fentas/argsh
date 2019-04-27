#!/usr/bin/env bats

load helper
fixtures args

: "${ARGSCRIPT:="args"}"

@test "no arguments prints message and usage instructions" {
  run "${ARGSCRIPT}"
  [ $status -eq 1 ]
  [ "${lines[0]%% *}" == 'Usage:' ]
}

@test "-h and --help print help" {
  run "${ARGSCRIPT}" -h
  [ $status -eq 0 ]
  [ "${#lines[@]}" -gt 3 ]
  [ "${lines[0]%% *}" == 'Usage:' ]
}

@test "invalid option prints message and usage instructions" {
  run filter_control_sequences "${ARGSCRIPT}" --invalid-option
  [ $status -eq 1 ]
  [ "${lines[0]}" == "■■ unrecognized option '--invalid-option'" ]
  [ "${lines[1]%% *}" == 'Usage:' ]
}
