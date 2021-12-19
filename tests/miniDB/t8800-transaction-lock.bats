#!/usr/bin/env bats

load temp_database

@test "truncation of existing database keeps the lock file" {
    initialize_table "$BATS_TEST_NAME" from multiline-schema

    miniDB --transactional --table "$BATS_TEST_NAME" --truncate

    lock_exists "$BATS_TEST_NAME"
}

@test "dropping of existing database removes the lock file" {
    initialize_table "$BATS_TEST_NAME" from one-entry
    miniDB --transactional --table "$BATS_TEST_NAME" --update "quux	This has been added	100"
    lock_exists "$BATS_TEST_NAME"

    miniDB --transactional --table "$BATS_TEST_NAME" --drop
    ! lock_exists "$BATS_TEST_NAME"
}

@test "dropping of existing database removes the lock file at the end of the transaction" {
    local TX=Trans1
    initialize_table "$BATS_TEST_NAME" from one-entry
    miniDB --start-write-transaction "$TX" --table "$BATS_TEST_NAME"
    miniDB --within-transaction "$TX" --table "$BATS_TEST_NAME" --update "quux	This has been added	100"
    miniDB --within-transaction "$TX" --table "$BATS_TEST_NAME" --drop
    miniDB --end-transaction "$TX" --table "$BATS_TEST_NAME"

    ! lock_exists "$BATS_TEST_NAME"
}
