#!/usr/bin/env bats

load canned_databases

@test "query action with no table prints message and usage instructions" {
    run miniDB --query foo
    [ $status -eq 2 ]
    [ "${lines[0]}" = 'ERROR: No TABLE passed.' ]
    [ "${lines[2]%% *}" = 'Usage:' ]
}

@test "a query key that contains a tab character is rejected" {
    run miniDB --table one-entry --query "with	tab"
    [ $status -eq 2 ]
    [ "${lines[0]}" = 'ERROR: KEY cannot contain tab characters.' ]
}

@test "an empty query key is rejected" {
    run miniDB --table "$BATS_TEST_NAME" --query ""
    [ $status -eq 2 ]
    [ "${lines[0]}" = 'ERROR: Key must not be empty.' ]
}

@test "a query on a non-existing database fails" {
    run miniDB --table doesNotExist --query whatever
    [ $status -eq 1 ]
    [ "$output" = "" ]
}
