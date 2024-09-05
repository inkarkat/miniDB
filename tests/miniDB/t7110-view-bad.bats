#!/usr/bin/env bats

load temp_view

@test "cannot update view" {
    run miniDB --table "$BATS_TEST_NAME" --view "${viewName:?}" --update 'foo	changed	99'
    [ $status -eq 2 ]
    [ "$output" = 'ERROR: Only read-only actions are allowed in views.' ]
}

@test "cannot run non-read command view" {
    run miniDB --table "$BATS_TEST_NAME" --view "${viewName:?}" --command 'cat'
    [ $status -eq 2 ]
    [ "$output" = 'ERROR: Only read-only actions are allowed in views.' ]
}

@test "cannot delete key in view" {
    run miniDB --table "$BATS_TEST_NAME" --view "${viewName:?}" --delete foo
    [ $status -eq 2 ]
    [ "$output" = 'ERROR: Only read-only actions are allowed in views.' ]
}

@test "cannot truncate view" {
    run miniDB --table "$BATS_TEST_NAME" --view "${viewName:?}" --truncate
    [ $status -eq 2 ]
    [ "$output" = 'ERROR: Only read-only actions are allowed in views.' ]
}

@test "cannot start transaction on view" {
    run miniDB --table "$BATS_TEST_NAME" --view "${viewName:?}" --start-read-transaction
    [ $status -eq 2 ]
    [ "$output" = 'ERROR: Cannot use transactions in views; they are read-only, anyway.' ]
}

@test "cannot use transactions on view" {
    run miniDB --transactional --table "$BATS_TEST_NAME" --view "${viewName:?}" --query foo
    [ $status -eq 2 ]
    [ "$output" = 'ERROR: Cannot use transactions in views; they are read-only, anyway.' ]
}
