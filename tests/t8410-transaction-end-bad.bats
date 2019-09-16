#!/usr/bin/env bats

load temp_database

setup()
{
    initialize_table "$BATS_TEST_NAME" from one-entry
    clear_lock "$BATS_TEST_NAME"
    export NOW=1568635000
}

@test "ending a transaction without having started one causes error" {
    run miniDB --end-transaction Trans1 --table "$BATS_TEST_NAME"
    [ $status -eq 6 ]
    [ "$output" = "ERROR: Not inside a transaction, or the transaction has timed out and another transaction was completed." ]
}

@test "ending a transaction after it timed out and another one completed causes error" {
    miniDB --start-read-transaction Trans1 --table "$BATS_TEST_NAME"
    let NOW+=5
    miniDB --start-read-transaction Trans2 --table "$BATS_TEST_NAME"
    miniDB --end-transaction Trans2 --table "$BATS_TEST_NAME"

    run miniDB --end-transaction Trans1 --table "$BATS_TEST_NAME"
    [ $status -eq 6 ]
    [ "$output" = "ERROR: Not inside a transaction, or the transaction has timed out and another transaction was completed." ]
}

@test "ending a transaction after it timed out and other one has been started causes error" {
    miniDB --start-read-transaction Trans1 --table "$BATS_TEST_NAME"
    let NOW+=5
    miniDB --start-read-transaction Trans2 --table "$BATS_TEST_NAME"

    run miniDB --end-transaction Trans1 --table "$BATS_TEST_NAME"
    [ $status -eq 6 ]
    [ "$output" = "ERROR: Another transaction by Trans2 has been started; any changes have been lost." ]
}
