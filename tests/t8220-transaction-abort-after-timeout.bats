#!/usr/bin/env bats

load temp_database

setup()
{
    initialize_table "$BATS_TEST_NAME" from one-entry
    clear_lock "$BATS_TEST_NAME"
}

@test "aborting after the transaction timed out and another one was started prints a warning" {
    miniDB --start-write-transaction Trans1 --transaction-timeout 0 --table "$BATS_TEST_NAME"
    miniDB --within-transaction Trans1 --table "$BATS_TEST_NAME" --update "foo	A Foo has been updated	43"
    run miniDB --start-write-transaction Trans2 --transaction-timeout 3 --table "$BATS_TEST_NAME"
    [ "$output" = "Warning: Previous transaction by Trans1 timed out 1 second ago and has been rolled back." ]
    assert_table_row "$BATS_TEST_NAME" \$ "foo	The Foo is here	42"

    run miniDB --abort-write-transaction Trans1 --table "$BATS_TEST_NAME"
    [ $status -eq 0 ]
    [ "$output" = "Warning: Another transaction by Trans2 has been started; any changes have been lost, anyway." ]
}

@test "aborting after the transaction timed out and another one was completed prints a warning" {
    miniDB --start-write-transaction Trans1 --transaction-timeout 0 --table "$BATS_TEST_NAME"
    miniDB --within-transaction Trans1 --table "$BATS_TEST_NAME" --update "foo	A Foo has been updated	43"
    run miniDB --start-write-transaction Trans2 --transaction-timeout 3 --table "$BATS_TEST_NAME"
    [ "$output" = "Warning: Previous transaction by Trans1 timed out 1 second ago and has been rolled back." ]
    miniDB --within-transaction Trans2 --table "$BATS_TEST_NAME" --update "foo	Another update	99"
    assert_table_row "$BATS_TEST_NAME" \$ "foo	Another update	99"
    miniDB --end-transaction Trans2 --table "$BATS_TEST_NAME"

    run miniDB --abort-write-transaction Trans1 --table "$BATS_TEST_NAME"
    [ $status -eq 0 ]
    [ "$output" = "Warning: Not inside a transaction, or the transaction has timed out and another transaction was completed." ]
}
