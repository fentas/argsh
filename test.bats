#!/usr/bin/env argsh
# shellcheck shell=bats disable=SC2154
# argsh shell=bats pass=file

# argsh(e|executable): env(ARGSH_TEST) def(./tests/fixtures/argsh/bin/example) des(executable for argsh integration test.) val(_argsh_is_executable)
# argsh(run):          des(test executable for argsh integration.)

load tests/helper

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
