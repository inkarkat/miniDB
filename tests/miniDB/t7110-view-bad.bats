#!/usr/bin/env bats

load fixture
load temp_view

@test "cannot update view" {
    run -2 miniDB --table "$BATS_TEST_NAME" --view "${viewName:?}" --update 'foo	changed	99'
    assert_output 'ERROR: Only read-only actions are allowed in views.'
}

@test "cannot run non-read command view" {
    run -2 miniDB --table "$BATS_TEST_NAME" --view "${viewName:?}" --command 'cat'
    assert_output 'ERROR: Only read-only actions are allowed in views.'
}

@test "cannot delete key in view" {
    run -2 miniDB --table "$BATS_TEST_NAME" --view "${viewName:?}" --delete foo
    assert_output 'ERROR: Only read-only actions are allowed in views.'
}

@test "cannot truncate view" {
    run -2 miniDB --table "$BATS_TEST_NAME" --view "${viewName:?}" --truncate
    assert_output 'ERROR: Only read-only actions are allowed in views.'
}

@test "cannot start transaction on view" {
    run -2 miniDB --table "$BATS_TEST_NAME" --view "${viewName:?}" --start-read-transaction
    assert_output 'ERROR: Cannot use transactions in views; they are read-only, anyway.'
}

@test "cannot use transactions on view" {
    run -2 miniDB --transactional --table "$BATS_TEST_NAME" --view "${viewName:?}" --query foo
    assert_output 'ERROR: Cannot use transactions in views; they are read-only, anyway.'
}
