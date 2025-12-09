#!/usr/bin/env bats

load fixture
load canned_databases

@test "a query of updated columns gives an error" {
    run -2 miniDB --table one-entry --query foo --columns \#
    assert_output 'ERROR: Updated columns can only be queried in combination with --update.'
}
