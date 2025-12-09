#!/usr/bin/env bats

load fixture
load temp_database

@test "delete action with no table prints message and usage instructions" {
    run -2 miniDB --delete foo
    assert_line -n 0 'ERROR: No TABLE passed.'
    assert_line -n 2 -e '^Usage:'
}

@test "a delete key that contains a tab character is rejected" {
    run -2 miniDB --table "$BATS_TEST_NAME" --delete "with	tab"
    assert_line -n 0 'ERROR: KEY cannot contain tab characters.'
}

@test "an empty delete key is rejected" {
    run -2 miniDB --table "$BATS_TEST_NAME" --delete ""
    assert_line -n 0 'ERROR: KEY must not be empty.'
}

@test "a delete on a non-existing database fails" {
    clean_table "$BATS_TEST_NAME"

    run -1 miniDB --table doesNotExist --delete whatever
    assert_output ''
    run ! table_exists "$BATS_TEST_NAME"
}
