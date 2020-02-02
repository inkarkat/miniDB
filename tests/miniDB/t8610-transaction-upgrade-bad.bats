#!/usr/bin/env bats

load temp_database

setup()
{
    initialize_table "$BATS_TEST_NAME" from one-entry
    clear_lock "$BATS_TEST_NAME"
    export NOW=1568635000
}

@test "upgrading a transaction when another one has already been started and timed out causes error" {
    miniDB --start-read-transaction Trans1 --table "$BATS_TEST_NAME"
    let NOW+=4
    miniDB --start-read-transaction Trans2 --table "$BATS_TEST_NAME"
    let NOW+=4

    run miniDB --upgrade-to-write-transaction Trans1 --table "$BATS_TEST_NAME"
    [ $status -eq 6 ]
    [ "$output" = "ERROR: Another read transaction by Trans2 has started already (and timed out 1 second ago)." ]
}

@test "upgrading a transaction when another one has already been started causes error" {
    miniDB --start-read-transaction Trans1 --table "$BATS_TEST_NAME"
    let NOW+=4
    miniDB --start-read-transaction Trans2 --table "$BATS_TEST_NAME"
    let NOW+=1

    run miniDB --upgrade-to-write-transaction Trans1 --table "$BATS_TEST_NAME"
    [ $status -eq 6 ]
    [ "$output" = "ERROR: Another read transaction by Trans2 is already in progress." ]
}

@test "upgrading a transaction without having started one causes error" {
    run miniDB --upgrade-to-write-transaction Trans1 --table "$BATS_TEST_NAME"
    [ $status -eq 6 ]
    [ "$output" = "ERROR: Not inside a transaction, or the transaction has timed out and another transaction was completed." ]
}

@test "upgrading a transaction after it timed out and another one completed causes error" {
    miniDB --start-read-transaction Trans1 --table "$BATS_TEST_NAME"
    let NOW+=5
    miniDB --start-read-transaction Trans2 --table "$BATS_TEST_NAME"
    miniDB --end-transaction Trans2 --table "$BATS_TEST_NAME"

    run miniDB --upgrade-to-write-transaction Trans1 --table "$BATS_TEST_NAME"
    [ $status -eq 6 ]
    [ "$output" = "ERROR: Not inside a transaction, or the transaction has timed out and another transaction was completed." ]
}
