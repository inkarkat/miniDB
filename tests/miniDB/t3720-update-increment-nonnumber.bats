#!/usr/bin/env bats

load temp_database

@test "increment an existing empty column yields 1" {
    initialize_table "$BATS_TEST_NAME" from numbers

    miniDB --table "$BATS_TEST_NAME" --update 'empty' --column 1++
    assert_table_row "$BATS_TEST_NAME" 3 "empty	1			not even a zero"
}

@test "increment a text column does nothing" {
    initialize_table "$BATS_TEST_NAME" from one-entry

    miniDB --table "$BATS_TEST_NAME" --update 'foo' --column 1++
    assert_table_row "$BATS_TEST_NAME" 2 "foo	The Foo is here	42"
}

@test "increment text and number columns only affects the number column" {
    initialize_table "$BATS_TEST_NAME" from one-entry

    miniDB --table "$BATS_TEST_NAME" --update 'foo' --column 1++ --column 2++
    assert_table_row "$BATS_TEST_NAME" 2 "foo	The Foo is here	43"
}
