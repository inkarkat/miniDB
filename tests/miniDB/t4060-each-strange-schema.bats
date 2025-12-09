#!/usr/bin/env bats

load fixture
load canned_databases

@test "iterating over a table with strange irregular schema names works as they are normalized" {
    run -0 miniDB --table strange-schema --each 'printf "%s-%s-%s\\n" "$WHAT_a_KEY0" "$a__mysterious__description__" "$_2funny_hat"'
    assert_equal ${#lines[@]} 1
    assert_line -n 0 'foo-The Foo here is missing-abracadabra'
}

