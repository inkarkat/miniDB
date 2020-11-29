#!/usr/bin/env bats

load temp_database

@test "delete action with no table prints message and usage instructions" {
    run miniDB --delete foo
    [ $status -eq 2 ]
    [ "${lines[0]}" = 'ERROR: No TABLE passed.' ]
    [ "${lines[2]%% *}" = 'Usage:' ]
}

@test "a delete key that contains a tab character is rejected" {
    run miniDB --table "$BATS_TEST_NAME" --delete "with	tab"
    [ $status -eq 2 ]
    [ "${lines[0]}" = 'ERROR: KEY cannot contain tab characters.' ]
}

@test "an empty delete key is rejected" {
    run miniDB --table "$BATS_TEST_NAME" --delete ""
    [ $status -eq 2 ]
    [ "${lines[0]}" = 'ERROR: KEY must not be empty.' ]
}

@test "a delete on a non-existing database fails" {
    clean_table "$BATS_TEST_NAME"

    run miniDB --table doesNotExist --delete whatever

    [ $status -eq 1 ]
    [ "$output" = "" ]
    ! table_exists "$BATS_TEST_NAME"
}
