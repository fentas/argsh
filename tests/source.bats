#!/usr/bin/env bats

load helper

@test "check if ARGSCRIPT exists" {
  run command -v "${ARGSCRIPT}"
  [ $status -eq 0 ]
}

@test "[ ${ARGSCRIPT} ] no arguments prints message and usage instructions" {
  [ -f "${ARGSCRIPT}" ] || skip
  run "${ARGSCRIPT}"
  [ $status -eq 1 ]
  [ "${lines[0]%% *}" == 'Usage:' ]
}

@test "[ ${ARGSCRIPT} ] -h and --help print help" {
  [ -f "${ARGSCRIPT}" ] || skip
  run "${ARGSCRIPT}" -h
  [ $status -eq 0 ]
  [ "${#lines[@]}" -gt 3 ]
  [ "${lines[0]%% *}" == 'Usage:' ]
}

@test "[ ${ARGSCRIPT} ] invalid option prints message and usage instructions" {
  [ -f "${ARGSCRIPT}" ] || skip
  run filter_control_sequences "${ARGSCRIPT}" --invalid-option
  [ $status -eq 1 ]
  [ "${lines[0]}" == "■■ unrecognized option '--invalid-option'" ]
  [ "${lines[1]%% *}" == 'Usage:' ]
}
