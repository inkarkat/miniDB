#!/usr/bin/env bats

load fixture
load temp_database

@test "existing database can be truncated and only consists of the schema then" {
    initialize_table "$BATS_TEST_NAME" from multiline-schema

    run -0 miniDB --table "$BATS_TEST_NAME" --truncate

    assert_equal ${#lines[@]} 0
    table_exists "$BATS_TEST_NAME"
    assert_row_count 1
    assert_table_row "$BATS_TEST_NAME" 1 "# ID	DESCRIPTION	COUNT	NOTES"
}

@test "truncate of empty database is a no-op" {
    initialize_table "$BATS_TEST_NAME" from empty

    run -0 miniDB --table "$BATS_TEST_NAME" --truncate
    assert_equal ${#lines[@]} 0
    table_exists "$BATS_TEST_NAME"
    assert_row_count 1
    assert_table_row "$BATS_TEST_NAME" 1 "# KEY	COLUMN	..." ]
}

@test "truncate of a non-existing table initializes it with the default header" {
    clean_table "$BATS_TEST_NAME"

    miniDB --table "$BATS_TEST_NAME" --truncate

    table_exists "$BATS_TEST_NAME"
    assert_row_count 1
    assert_table_row "$BATS_TEST_NAME" 1 "# KEY	COLUMN	..."
}

@test "truncate of a non-existing table with passed schema initializes it with a custom header" {
    clean_table "$BATS_TEST_NAME"

    miniDB --table "$BATS_TEST_NAME" --schema "ID SURNAME GIVEN-NAME" --truncate

    table_exists "$BATS_TEST_NAME"
    assert_row_count 1
    assert_table_row "$BATS_TEST_NAME" 1 "# ID	SURNAME	GIVEN-NAME"
}
