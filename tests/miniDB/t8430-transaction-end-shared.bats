#!/usr/bin/env bats

load temp_database

setup()
{
    initialize_table "$BATS_TEST_NAME" from one-entry
    clear_lock "$BATS_TEST_NAME"
    export NOW=1568635000
}

@test "ending the first of a 2-way shared read transaction keeps the lock" {
    initialize_table "$BATS_TEST_NAME" from one-entry
    miniDB --start-read-transaction Trans1 --table "$BATS_TEST_NAME"
    miniDB --start-read-transaction Trans2 --table "$BATS_TEST_NAME"
    lock_is_shared "$BATS_TEST_NAME"
    let NOW+=1
    miniDB --within-transaction Trans1 --table "$BATS_TEST_NAME" --query foo

    miniDB --end-transaction Trans1 --table "$BATS_TEST_NAME"
    lock_is_shared "$BATS_TEST_NAME"
}

@test "ending the second of a 3-way shared read transaction keeps the lock" {
    initialize_table "$BATS_TEST_NAME" from one-entry
    miniDB --start-read-transaction Trans1 --table "$BATS_TEST_NAME"
    miniDB --start-read-transaction Trans2 --table "$BATS_TEST_NAME"
    miniDB --start-read-transaction Trans3 --table "$BATS_TEST_NAME"
    lock_is_shared "$BATS_TEST_NAME"
    let NOW+=1

    miniDB --within-transaction Trans1 --table "$BATS_TEST_NAME" --query foo
    miniDB --end-transaction Trans1 --table "$BATS_TEST_NAME"
    lock_is_shared "$BATS_TEST_NAME"
    miniDB --within-transaction Trans2 --table "$BATS_TEST_NAME" --query foo

    miniDB --end-transaction Trans2 --table "$BATS_TEST_NAME"
    lock_is_shared "$BATS_TEST_NAME"
}

@test "ending the last of a 3-way shared read transaction removes the lock" {
    initialize_table "$BATS_TEST_NAME" from one-entry
    miniDB --start-read-transaction Trans1 --table "$BATS_TEST_NAME"
    miniDB --start-read-transaction Trans2 --table "$BATS_TEST_NAME"
    miniDB --start-read-transaction Trans3 --table "$BATS_TEST_NAME"
    lock_is_shared "$BATS_TEST_NAME"
    let NOW+=1

    miniDB --within-transaction Trans1 --table "$BATS_TEST_NAME" --query foo
    miniDB --end-transaction Trans1 --table "$BATS_TEST_NAME"
    lock_is_shared "$BATS_TEST_NAME"
    miniDB --within-transaction Trans2 --table "$BATS_TEST_NAME" --query foo
    miniDB --end-transaction Trans2 --table "$BATS_TEST_NAME"
    lock_is_shared "$BATS_TEST_NAME"
    miniDB --within-transaction Trans3 --table "$BATS_TEST_NAME" --query foo

    miniDB --end-transaction Trans3 --table "$BATS_TEST_NAME"
    ! lock_is_shared "$BATS_TEST_NAME"
}
