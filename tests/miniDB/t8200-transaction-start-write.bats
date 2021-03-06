#!/usr/bin/env bats

load temp_database

setup()
{
    initialize_table "$BATS_TEST_NAME" from one-entry
    clear_lock "$BATS_TEST_NAME"
    export NOW=1568635000
}

@test "when starting a new write transaction, a previous started transaction that timed out prints a warning" {
    miniDB --start-write-transaction Trans1 --table "$BATS_TEST_NAME"

    let NOW+=4
    run miniDB --start-write-transaction Trans2 --table "$BATS_TEST_NAME"
    [ $status -eq 0 ]
    [ "$output" = "Warning: Previous write transaction by Trans1 timed out 1 second ago but did not do any changes." ]
}

@test "when starting a new write transaction, a previous updated transaction that timed out prints a warning" {
    miniDB --start-write-transaction Trans1 --table "$BATS_TEST_NAME"
    miniDB --within-transaction Trans1 --table "$BATS_TEST_NAME" --update "foo	A Foo has been updated	43"

    let NOW+=6
    run miniDB --start-write-transaction Trans2 --table "$BATS_TEST_NAME"
    [ $status -eq 0 ]
    [ "$output" = "Warning: Previous write transaction by Trans1 timed out 3 seconds ago and has been rolled back." ]
}

@test "when the owner starts another write transaction after his previous one timed out, a warning is printed" {
    miniDB --start-write-transaction Trans1 --table "$BATS_TEST_NAME"
    miniDB --within-transaction Trans1 --table "$BATS_TEST_NAME" --update "foo	A Foo has been updated	43"

    let NOW+=5
    run miniDB --start-write-transaction Trans1 --table "$BATS_TEST_NAME"
    [ $status -eq 0 ]
    [ "$output" = "Warning: Previous write transaction by Trans1 timed out 2 seconds ago and has been rolled back." ]
}

@test "when the owner starts another write transaction before his previous one times out, this returns 1" {
    miniDB --start-write-transaction Trans1 --table "$BATS_TEST_NAME"
    miniDB --within-transaction Trans1 --table "$BATS_TEST_NAME" --update "foo	A Foo has been updated	43"

    run miniDB --start-write-transaction Trans1 --table "$BATS_TEST_NAME"
    [ $status -eq 1 ]
    [ "$output" = "ERROR: Another write transaction by Trans1 is already in progress." ]
}

@test "when the owner starts a write transaction before another's one times out, the attempt times out" {
    miniDB --start-write-transaction Trans1 --table "$BATS_TEST_NAME"
    miniDB --within-transaction Trans1 --table "$BATS_TEST_NAME" --update "foo	A Foo has been updated	43"

    let NOW+=1
    run miniDB --timeout 1 --start-write-transaction Trans2 --table "$BATS_TEST_NAME"
    [ $status -eq 5 ]
    [ "$output" = "Timed out while another write transaction by Trans1 is in progress." ]
}
