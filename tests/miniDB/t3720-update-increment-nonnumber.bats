#!/usr/bin/env bats

load temp_database

@test "increment an existing empty column yields 1" {
    initialize_table "$BATS_TEST_NAME" from numbers

    miniDB --table "$BATS_TEST_NAME" --update 'empty' --column 1++
    assert_table_row "$BATS_TEST_NAME" 3 "empty	1			not even a zero"
}
