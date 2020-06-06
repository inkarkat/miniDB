#!/usr/bin/env bats

load temp_database

@test "update of a column with bad column values prints error and usage instructions and does not modify the table" {
    initialize_table "$BATS_TEST_NAME" from one-entry

    run miniDB --table "$BATS_TEST_NAME" --update 'foo' --column 'whatIsThis'
    [ $status -eq 2 ]
    [ "${lines[0]}" = 'ERROR: Column values must be specified as COL1=VALUE1 or N=VALUE-N.' ]
    [ "${lines[2]%% *}" = 'Usage:' ]
    assert_table_row "$BATS_TEST_NAME" \$ "foo	The Foo is here	42"
}

@test "update of a column with empty column name prints error and usage instructions and does not modify the table" {
    initialize_table "$BATS_TEST_NAME" from one-entry

    run miniDB --table "$BATS_TEST_NAME" --update 'foo' --column '=updated value'
    [ $status -eq 2 ]
    [ "${lines[0]}" = 'ERROR: Column values must be specified as COL1=VALUE1 or N=VALUE-N.' ]
    [ "${lines[2]%% *}" = 'Usage:' ]
    assert_table_row "$BATS_TEST_NAME" \$ "foo	The Foo is here	42"
}

@test "update of a table with an empty key is rejected" {
    initialize_table "$BATS_TEST_NAME" from one-entry

    run miniDB --table "$BATS_TEST_NAME" --update '' --column "2=77"
    [ $status -eq 2 ]
    [ "${lines[0]}" = 'ERROR: Key must not be empty.' ]
}
