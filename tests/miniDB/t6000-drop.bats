#!/usr/bin/env bats

load temp_database

@test "existing database can be dropped" {
    initialize_table "$BATS_TEST_NAME" from one-entry

    run miniDB --table "$BATS_TEST_NAME" --drop
    [ $status -eq 0 ]
    [ "${#lines[@]}" -eq 0 ]
    ! table_exists "$BATS_TEST_NAME"
}

@test "other tables are not affected" {
    initialize_table "${BATS_TEST_NAME}1" from some-entries
    initialize_table "${BATS_TEST_NAME}11" from some-entries
    initialize_table "${BATS_TEST_NAME}2" from some-entries

    miniDB --table "${BATS_TEST_NAME}1" --drop

    ! table_exists "${BATS_TEST_NAME}1"
    table_exists "${BATS_TEST_NAME}11"
    table_exists "${BATS_TEST_NAME}2"

    clean_table "${BATS_TEST_NAME}11"
    clean_table "${BATS_TEST_NAME}2"
}
