#!/usr/bin/env bats

load temp_database

setup()
{
    initialize_table "$BATS_TEST_NAME" from one-entry
    clear_lock "$BATS_TEST_NAME"
    export NOW=1568635000
}

@test "upgrading a transaction when it has become a shared one causes error" {
    miniDB --start-read-transaction Trans1 --table "$BATS_TEST_NAME"
    miniDB --start-read-transaction Trans2 --table "$BATS_TEST_NAME"
    lock_is_shared "$BATS_TEST_NAME"

    let NOW+=1
    run miniDB --upgrade-to-write-transaction Trans1 --table "$BATS_TEST_NAME"
    [ $status -eq 6 ]
    [ "$output" = "ERROR: Another shared read transaction is already in progress." ]
}
