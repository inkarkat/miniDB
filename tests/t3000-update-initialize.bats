#!/usr/bin/env bats

load temp_database

setup()
{
    clean_table "$BATS_TEST_NAME"
}

@test "update of a non-existing table initializes it with a default header" {
    miniDB --table "$BATS_TEST_NAME" --update "key	value"
    dump_table "$BATS_TEST_NAME"

    assert_table_row "$BATS_TEST_NAME" 1 "# KEY	COLUMN	..."
    assert_table_row "$BATS_TEST_NAME" \$ "key	value"
}

@test "update of a non-existing table with passed schema initializes it with a custom header" {
    miniDB --table "$BATS_TEST_NAME" --schema "ID SURNAME GIVEN-NAME" --update "key	value"

    assert_table_row "$BATS_TEST_NAME" 1 "# ID	SURNAME	GIVEN-NAME"
    assert_table_row "$BATS_TEST_NAME" \$ "key	value"
}
