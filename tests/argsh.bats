#!/usr/bin/env bats

load helper
fixtures args

@test "check args integration" {
  run bats "${BATS_TEST_DIRNAME}/source.bats"
  echo "${output}"
  [ $status -eq 0 ]
}

@test "check no args integration" {
  ARGSCRIPT="no-argsh" \
    run bats "${BATS_TEST_DIRNAME}/source.bats"
  echo "${output}"
  [ $status -eq 1 ]
}

@test "execute action" {
  run "${FIXTURE_ROOT}/bin/argsh" --execute
  [ $status -eq 0 ]
  [ "${lines[0]}" == "wavelab dhaba" ]
}