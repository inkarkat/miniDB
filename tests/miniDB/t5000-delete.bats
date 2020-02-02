#!/usr/bin/env bats

load temp_database

@test "non-existing key deletion fails" {
    initialize_table "$BATS_TEST_NAME" from one-entry
    rowNum="$(get_row_number "$BATS_TEST_NAME")"

    run miniDB --table "$BATS_TEST_NAME" --delete notInHere
    [ $status -eq 4 ]
    [ "${#lines[@]}" -eq 0 ]
    updatedRowNum="$(get_row_number "$BATS_TEST_NAME")"; [ "$updatedRowNum" -eq "$rowNum" ]
}

@test "key can be deleted among many" {
    initialize_table "$BATS_TEST_NAME" from dev/db
    rowNum="$(get_row_number "$BATS_TEST_NAME")"

    run miniDB --table "$BATS_TEST_NAME" --delete bar
    [ $status -eq 0 ]
    [ "${#lines[@]}" -eq 0 ]
    updatedRowNum="$(get_row_number "$BATS_TEST_NAME")"; [ "$updatedRowNum" -eq $((rowNum - 1)) ]
    assert_table_row "$BATS_TEST_NAME" 2 "foo	The Foo may have been there	41"
    assert_table_row "$BATS_TEST_NAME" 3 "test	Testing	123"
}

@test "existing single key can be deleted" {
    initialize_table "$BATS_TEST_NAME" from one-entry
    [ "$(get_row_number "$BATS_TEST_NAME")" -eq 2 ]

    run miniDB --table "$BATS_TEST_NAME" --delete foo

    [ $status -eq 0 ]
    [ "${#lines[@]}" -eq 0 ]
    [ "$(get_row_number "$BATS_TEST_NAME")" -eq 1 ]
    assert_table_row "$BATS_TEST_NAME" 1 "# KEY	COLUMN	..."
}
