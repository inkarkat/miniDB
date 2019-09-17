#!/usr/bin/env bats

load temp_database

setup()
{
    initialize_table "$BATS_TEST_NAME" from one-entry
    clear_lock "$BATS_TEST_NAME"
    export NOW=1568635000
}

@test "ending after the started transaction timed out prints a warning" {
    miniDB --start-write-transaction Trans1 --table "$BATS_TEST_NAME"
    miniDB --within-transaction Trans1 --table "$BATS_TEST_NAME" --update "foo	A Foo has been updated	43"
    let NOW+=5
    run miniDB --end-transaction Trans1 --table "$BATS_TEST_NAME"
    [ $status -eq 0 ]
    [ "$output" = "Warning: Current transaction timed out 2 seconds ago." ]
}

@test "ending after the shared transaction timed out prints a warning" {
    miniDB --start-read-transaction Trans1 --table "$BATS_TEST_NAME"
    let NOW+=1
    miniDB --transaction-timeout 1 --start-read-transaction Trans2 --table "$BATS_TEST_NAME"
    lock_is_shared "$BATS_TEST_NAME"

    let NOW+=5
    run miniDB --end-transaction Trans1 --table "$BATS_TEST_NAME"
    [ $status -eq 0 ]
    [ "$output" = "Warning: Shared read transaction timed out 3 seconds ago." ]
}
