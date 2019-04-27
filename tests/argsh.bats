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
  run "${FIXTURE_ROOT}"/bin/example --execute
  log_on_failure
  [ $status -eq 0 ]
  [ "${lines[0]}" == "wubba lubba dub dub" ]
}
