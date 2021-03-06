#!/usr/bin/env bats

load temp_database

@test "update action with no table prints message and usage instructions" {
    run miniDB --update "quux	This has been added	100"
    [ $status -eq 2 ]
    [ "${lines[0]}" = 'ERROR: No TABLE passed.' ]
    [ "${lines[2]%% *}" = 'Usage:' ]
}

@test "update of a non-existing table initializes it with the passed key and value" {
    [ ! -w /etc ] || skip "Need non-writable /etc directory"

    LC_ALL=C run miniDB --basedir /etc --table testtable --update "key	value"
    [ $status -eq 1 ]
    [[ "$output" =~ "/etc/testtable: Permission denied"$ ]]
}

@test "update of a table with an empty key is rejected" {
    initialize_table "$BATS_TEST_NAME" from one-entry

    run miniDB --table "$BATS_TEST_NAME" --update "	The key is empty	0"
    [ $status -eq 2 ]
    [ "${lines[0]}" = 'ERROR: KEY must not be empty.' ]
}
