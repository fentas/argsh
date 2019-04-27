#!/usr/bin/env bats

load helper
fixtures argsh

@test "check args integration" {
  ARGSH_TEST="${FIXTURE_ROOT}"/bin/example \
    run bats "${BATS_TEST_DIRNAME}/source.bats"
  log_on_failure
  [ $status -eq 0 ]
}

@test "check no args integration" {
  ARGSH_TEST="${FIXTURE_ROOT}"/bin/no-argsh \
    run bats "${BATS_TEST_DIRNAME}"/source.bats
  log_on_failure
  [ $status -eq 1 ]
}

@test "execute action" {
  run "${FIXTURE_ROOT}"/bin/example --simple-output
  log_on_failure
  [ $status -eq 0 ]
  [ "${lines[0]}" == "wubba lubba dub dub" ]
}

@test "check if default value is set" {
  run "${FIXTURE_ROOT}"/bin/example --print
  log_on_failure
  [ $status -eq 0 ]
  [ "${lines[0]}" == "default value" ]
}

@test "overwrite default value" {
  local -r s="$(date '+%s')"
  run "${FIXTURE_ROOT}"/bin/example -i "${s}" --print
  log_on_failure
  [ $status -eq 0 ]
  [ "${lines[0]}" == "${s}" ]
}

@test "print environment variable" {
  export NON_EMPTY="Lorem Ipsum"
  run "${FIXTURE_ROOT}"/bin/example -v NON_EMPTY --print
  log_on_failure
  [ $status -eq 0 ]
  [ "${lines[0]}" == "Lorem Ipsum" ]
}

@test "overwrite env with empty default value" {
  export INPUT="Lorem Ipsum"
  run "${FIXTURE_ROOT}"/bin/example --print
  log_on_failure
  [ $status -eq 0 ]
  [ "${lines[0]}" == "" ]
}
