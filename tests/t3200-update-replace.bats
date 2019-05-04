#!/usr/bin/env bats

load temp_database

@test "update of a table with an existing key overwrites that row" {
    initialize_table "$BATS_TEST_NAME" from one-entry

    miniDB --table "$BATS_TEST_NAME" --update "foo	A Foo has been updated	43"
    assert_table_row "$BATS_TEST_NAME" 1 "# KEY	COLUMN	..."
    assert_table_row "$BATS_TEST_NAME" 2 "foo	A Foo has been updated	43"
    assert_table_row "$BATS_TEST_NAME" \$ "foo	A Foo has been updated	43"
}

@test "update of a larger table with an existing key multiple times updates that row" {
    initialize_table "$BATS_TEST_NAME" from some-entries

    miniDB --table "$BATS_TEST_NAME" --update "foo	A Foo has been updated	43"
    miniDB --table "$BATS_TEST_NAME" --update "bar	A woman walks by a	22"
    miniDB --table "$BATS_TEST_NAME" --update "o O	A key updated with space	99"

    assert_table_row "$BATS_TEST_NAME" 1 "# KEY	COLUMN	..."
    assert_table_row "$BATS_TEST_NAME" 2 "foo	A Foo has been updated	43"
    assert_table_row "$BATS_TEST_NAME" 4 "bar	A woman walks by a	22"
    assert_table_row "$BATS_TEST_NAME" 7 "o O	A key updated with space	99"
}
