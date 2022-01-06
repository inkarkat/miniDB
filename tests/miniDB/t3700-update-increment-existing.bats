#!/usr/bin/env bats

load temp_database

@test "increment existing 42 in numeric column" {
    initialize_table "$BATS_TEST_NAME" from some-entries

    miniDB --table "$BATS_TEST_NAME" --update 'foo' --column "2++"
    assert_table_row "$BATS_TEST_NAME" 2 "foo	The Foo is here	43"
}

@test "increment existing 42 in schema name column" {
    initialize_table "$BATS_TEST_NAME" from some-entries

    miniDB --schema 'KEY TEXT NUMBER' --table "$BATS_TEST_NAME" --update 'foo' --column "NUMBER++"
    assert_table_row "$BATS_TEST_NAME" 2 "foo	The Foo is here	43"
}

@test "increment existing 99 in numeric column" {
    initialize_table "$BATS_TEST_NAME" from some-entries

    miniDB --table "$BATS_TEST_NAME" --update 'baz' --column "2++"
    assert_table_row "$BATS_TEST_NAME" 9 "baz	Last one here	100"
}
