#!/usr/bin/env bats

load temp_database

@test "update of a table with an empty key is rejected" {
    initialize_table "$BATS_TEST_NAME" from one-entry

    run miniDB --table "$BATS_TEST_NAME" --update "	The key is empty	0"
    [ $status -eq 2 ]
    [ "${lines[0]}" = 'ERROR: Key must not be empty.' ]
}
