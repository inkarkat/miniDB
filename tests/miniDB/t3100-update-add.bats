#!/usr/bin/env bats

load temp_database

@test "update of a table with a new key adds a row" {
    initialize_table "$BATS_TEST_NAME" from one-entry

    miniDB --table "$BATS_TEST_NAME" --update "quux	This has been added	100"
    assert_table_row "$BATS_TEST_NAME" 1 "# KEY	COLUMN	..."
    assert_table_row "$BATS_TEST_NAME" 2 "foo	The Foo is here	42"
    assert_table_row "$BATS_TEST_NAME" 3 "quux	This has been added	100"
}

@test "update of a table with new keys twice adds two rows" {
    initialize_table "$BATS_TEST_NAME" from one-entry

    miniDB --table "$BATS_TEST_NAME" --update "quux	This has been added	100"
    miniDB --table "$BATS_TEST_NAME" --update "quuu	Another addition	200"

    assert_table_row "$BATS_TEST_NAME" 1 "# KEY	COLUMN	..."
    assert_table_row "$BATS_TEST_NAME" 2 "foo	The Foo is here	42"
    assert_table_row "$BATS_TEST_NAME" 3 "quux	This has been added	100"
    assert_table_row "$BATS_TEST_NAME" 4 "quuu	Another addition	200"
}
