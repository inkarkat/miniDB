#!/usr/bin/env bats

load fixture
load temp_database

@test "non-existing key deletion fails" {
    initialize_table "$BATS_TEST_NAME" from one-entry
    rowNum="$(get_row_number "$BATS_TEST_NAME")"

    run -4 miniDB --table "$BATS_TEST_NAME" --delete notInHere
    assert_equal ${#lines[@]} 0
    assert_row_count "$(get_row_number "$BATS_TEST_NAME")" "$rowNum"
}

@test "key can be deleted among many" {
    initialize_table "$BATS_TEST_NAME" from dev/db
    rowNum="$(get_row_number "$BATS_TEST_NAME")"

    run -0 miniDB --table "$BATS_TEST_NAME" --delete bar
    assert_equal ${#lines[@]} 0
    assert_row_count "$(get_row_number "$BATS_TEST_NAME")" $((rowNum - 1))
    assert_table_row "$BATS_TEST_NAME" 2 "foo	The Foo may have been there	41"
    assert_table_row "$BATS_TEST_NAME" 3 "test	Testing	123"
}

@test "existing single key can be deleted" {
    initialize_table "$BATS_TEST_NAME" from one-entry
    assert_row_count 2

    run -0 miniDB --table "$BATS_TEST_NAME" --delete foo
    assert_equal ${#lines[@]} 0
    assert_row_count 1
    assert_table_row "$BATS_TEST_NAME" 1 "# KEY	COLUMN	..."
}
