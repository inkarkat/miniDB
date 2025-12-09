#!/usr/bin/env bats

load fixture
load canned_databases

@test "iteration a non-existing database fails" {
    run -1 miniDB --table doesNotExist --each echo
    assert_output ''
}
