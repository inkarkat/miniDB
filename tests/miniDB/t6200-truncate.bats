#!/usr/bin/env bats

load temp_database

@test "existing database can be truncated and only consists of the schema then" {
    initialize_table "$BATS_TEST_NAME" from multiline-schema

    run miniDB --table "$BATS_TEST_NAME" --truncate

    [ $status -eq 0 ]
    [ "${#lines[@]}" -eq 0 ]
    table_exists "$BATS_TEST_NAME"
    [ "$(get_row_number "$BATS_TEST_NAME")" -eq 1 ]
    assert_table_row "$BATS_TEST_NAME" 1 "# ID	DESCRIPTION	COUNT	NOTES"
}

@test "truncate of empty database is a no-op" {
    initialize_table "$BATS_TEST_NAME" from empty

    run miniDB --table "$BATS_TEST_NAME" --truncate

    [ $status -eq 0 ]
    [ "${#lines[@]}" -eq 0 ]
    table_exists "$BATS_TEST_NAME"
    [ "$(get_row_number "$BATS_TEST_NAME")" -eq 1 ]
    assert_table_row "$BATS_TEST_NAME" 1 "# KEY	COLUMN	..." ]
}

@test "truncate of a non-existing table initializes it with the default header" {
    clean_table "$BATS_TEST_NAME"

    miniDB --table "$BATS_TEST_NAME" --truncate

    table_exists "$BATS_TEST_NAME"
    [ "$(get_row_number "$BATS_TEST_NAME")" -eq 1 ]
    assert_table_row "$BATS_TEST_NAME" 1 "# KEY	COLUMN	..."
}

@test "truncate of a non-existing table with passed schema initializes it with a custom header" {
    clean_table "$BATS_TEST_NAME"

    miniDB --table "$BATS_TEST_NAME" --schema "ID SURNAME GIVEN-NAME" --truncate

    table_exists "$BATS_TEST_NAME"
    [ "$(get_row_number "$BATS_TEST_NAME")" -eq 1 ]
    assert_table_row "$BATS_TEST_NAME" 1 "# ID	SURNAME	GIVEN-NAME"
}
