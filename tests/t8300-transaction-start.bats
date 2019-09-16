#!/usr/bin/env bats

load temp_database

setup()
{
    initialize_table "$BATS_TEST_NAME" from one-entry
    clear_lock "$BATS_TEST_NAME"
    export NOW=1568635000
}

@test "when starting a new transaction, a previous started transaction that timed out prints a warning" {
    miniDB --start-write-transaction Trans1 --table "$BATS_TEST_NAME"
    let NOW+=4
    run miniDB --start-write-transaction Trans2 --table "$BATS_TEST_NAME"
    [ "$output" = "Warning: Previous transaction by Trans1 timed out 1 second ago but did not do any changes." ]
}

@test "when starting a new transaction, a previous updated transaction that timed out prints a warning" {
    miniDB --start-write-transaction Trans1 --table "$BATS_TEST_NAME"
    miniDB --within-transaction Trans1 --table "$BATS_TEST_NAME" --update "foo	A Foo has been updated	43"
    let NOW+=6
    run miniDB --start-write-transaction Trans2 --table "$BATS_TEST_NAME"
    [ "$output" = "Warning: Previous transaction by Trans1 timed out 3 seconds ago and has been rolled back." ]
}
