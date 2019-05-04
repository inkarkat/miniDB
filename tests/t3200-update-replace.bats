#!/usr/bin/env bats

load temp_database

@test "update of a table with an existing key overwrites that row" {
    initialize_table "$BATS_TEST_NAME" from one-entry

    miniDB --table "$BATS_TEST_NAME" --update "foo	A Foo has been updated	43"
    assert_table_row "$BATS_TEST_NAME" 1 "# KEY	COLUMN	..."
    assert_table_row "$BATS_TEST_NAME" 2 "foo	A Foo has been updated	43"
    assert_table_row "$BATS_TEST_NAME" \$ "foo	A Foo has been updated	43"
}
