#!/usr/bin/env bats

load fixture
load canned_databases

@test "query action with no table prints message and usage instructions" {
    run -2 miniDB --query foo
    assert_line -n 0 'ERROR: No TABLE passed.'
    assert_line -n 2 -e '^Usage:'
}

@test "a query key that contains a tab character is rejected" {
    run -2 miniDB --table one-entry --query "with	tab"
    assert_line -n 0 'ERROR: KEY cannot contain tab characters.'
}

@test "an empty query key is rejected" {
    run -2 miniDB --table "$BATS_TEST_NAME" --query ""
    assert_line -n 0 'ERROR: KEY must not be empty.'
}

@test "a query on a non-existing database fails" {
    run -1 miniDB --table doesNotExist --query whatever
    assert_output ''
}
