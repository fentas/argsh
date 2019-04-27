#!/usr/bin/env bats

load helper
fixtures args

@test "check args integration" {
  run bats "${BATS_TEST_DIRNAME}/args-script.bats"
  echo "${output}"
  [ $status -eq 0 ]
}

@test "check no args integration" {
  ARGSCRIPT="no-args" \
    run bats "${BATS_TEST_DIRNAME}/args-script.bats"
  echo "${output}"
  [ $status -eq 1 ]
}

@test "execute action" {
  run "${FIXTURE_ROOT}/bin/args" --execute
  [ $status -eq 0 ]
  [ "${lines[0]}" == "wavelab dhaba" ]
}