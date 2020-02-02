#!/usr/bin/env bats

load temp_database

setup()
{
    initialize_table "$BATS_TEST_NAME" from one-entry
    clear_lock "$BATS_TEST_NAME"
    export NOW=1568635000
}

@test "silence error when the owner starts another read transaction before his previous write one times out" {
    miniDB --start-write-transaction Trans1 --table "$BATS_TEST_NAME"
    miniDB --within-transaction Trans1 --table "$BATS_TEST_NAME" --update "foo	A Foo has been updated	43"

    run miniDB --silence-transaction-errors --start-read-transaction Trans1 --table "$BATS_TEST_NAME"
    [ $status -eq 1 ]
    [ -z "$output" ]
}

@test "silence error when upgrading a transaction when it has become a shared one" {
    miniDB --start-read-transaction Trans1 --table "$BATS_TEST_NAME"
    miniDB --start-read-transaction Trans2 --table "$BATS_TEST_NAME"
    lock_is_shared "$BATS_TEST_NAME"

    let NOW+=1
    run miniDB --silence-transaction-errors --upgrade-to-write-transaction Trans1 --table "$BATS_TEST_NAME"
    [ $status -eq 6 ]
    [ -z "$output" ]
}

@test "silence error when ending a transaction without having started one" {
    run miniDB --silence-transaction-errors --end-transaction Trans1 --table "$BATS_TEST_NAME"
    [ $status -eq 6 ]
    [ -z "$output" ]
}

@test "silence error when ending a transaction after it timed out and other one has been started" {
    miniDB --start-read-transaction Trans1 --table "$BATS_TEST_NAME"
    let NOW+=5
    miniDB --start-read-transaction Trans2 --table "$BATS_TEST_NAME"

    run miniDB --silence-transaction-errors --end-transaction Trans1 --table "$BATS_TEST_NAME"
    [ $status -eq 6 ]
    [ -z "$output" ]
}

@test "silence error when aborting a read transaction" {
    initialize_table "$BATS_TEST_NAME" from one-entry
    miniDB --start-read-transaction Trans1 --table "$BATS_TEST_NAME"
    miniDB --within-transaction Trans1 --table "$BATS_TEST_NAME" --query foo
    run miniDB --silence-transaction-errors --abort-write-transaction Trans1 --table "$BATS_TEST_NAME"
    [ $status -eq 2 ]
    [ -z "$output" ]
}

@test "silence error when inside a current read transaction, writes cause an error" {
    miniDB --start-read-transaction Trans1 --table "$BATS_TEST_NAME"
    let NOW+=1
    run miniDB --silence-transaction-errors --within-transaction Trans1 --table "$BATS_TEST_NAME" --update "foo	A Foo has been updated	43"
    [ $status -eq 2 ]
    [ -z "$output" ]
}

@test "silence error when inside an expired transaction and another one has been started causes error" {
    miniDB --start-read-transaction Trans1 --table "$BATS_TEST_NAME"
    let NOW+=5
    miniDB --start-read-transaction Trans2 --table "$BATS_TEST_NAME"

    run miniDB --silence-transaction-errors --within-transaction Trans1 --table "$BATS_TEST_NAME" --query foo
    [ $status -eq 6 ]
    [ -z "$output" ]
}
