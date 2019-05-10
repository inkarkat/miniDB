#!/usr/bin/env bats

load temp_database

@test "a delete key that contains a tab character is rejected" {
    run miniDB --table "$BATS_TEST_NAME" --delete "with	tab"
    [ $status -eq 2 ]
    [ "${lines[0]}" = 'ERROR: KEY cannot contain tab characters.' ]
}

@test "a delete on a non-existing database fails" {
    run miniDB --table doesNotExist --delete whatever
    [ $status -eq 1 ]
    [ "$output" = "" ]
}
