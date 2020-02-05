#!/usr/bin/env bats

load temp_database

@test "read can happen concurrently with read command" {
    initialize_table "$BATS_TEST_NAME" from one-entry
    miniDB --transactional --table "$BATS_TEST_NAME" --read-command 'sleep 0.5; sed -i "2y/Fe/Ba/" {}' &
    sleep 0.1
    run miniDB --transactional --table "$BATS_TEST_NAME" --query foo --columns 1
    wait
    [ $status -eq 0 ]
    [ "$output" = "The Foo is here" ]
}

@test "read waits for conclusion of write command" {
    initialize_table "$BATS_TEST_NAME" from one-entry
    miniDB --transactional --table "$BATS_TEST_NAME" --command 'sleep 0.5; sed -i "2y/Fe/Ba/" {}' &
    sleep 0.1
    run miniDB --transactional --table "$BATS_TEST_NAME" --query foo --columns 1
    wait
    [ $status -eq 0 ]
    [ "$output" = "Tha Boo is hara" ]
}

@test "simple command is a write command" {
    type -t slowcommand >/dev/null || skip

    initialize_table "$BATS_TEST_NAME" from one-entry
    miniDB --transactional --table "$BATS_TEST_NAME" --command 'slowcommand 1 sed -i "2y/Fe/Ba/" {}' &
    sleep 0.1
    run miniDB --transactional --table "$BATS_TEST_NAME" --query foo --columns 1
    wait
    [ $status -eq 0 ]
    [ "$output" = "Tha Boo is hara" ]
}

@test "read can happen concurrently with two read commands" {
    initialize_table "$BATS_TEST_NAME" from one-entry
    miniDB --transactional --table "$BATS_TEST_NAME" --read-command 'sleep 0.5' --read-command 'sed -i "2y/Fe/Ba/" {}' &
    sleep 0.1
    run miniDB --transactional --table "$BATS_TEST_NAME" --query foo --columns 1
    wait
    [ $status -eq 0 ]
    [ "$output" = "The Foo is here" ]
}

@test "read and write commands act as write" {
    initialize_table "$BATS_TEST_NAME" from one-entry
    miniDB --transactional --table "$BATS_TEST_NAME" --read-command 'sleep 0.5' --command 'sed -i "2y/Fe/Ba/" {}' &
    sleep 0.1
    run miniDB --transactional --table "$BATS_TEST_NAME" --query foo --columns 1
    wait
    [ $status -eq 0 ]
    [ "$output" = "Tha Boo is hara" ]
}

@test "write and read commands act as write" {
    initialize_table "$BATS_TEST_NAME" from one-entry
    miniDB --transactional --table "$BATS_TEST_NAME" --command 'sleep 0.5' --read-command 'sed -i "2y/Fe/Ba/" {}' &
    sleep 0.1
    run miniDB --transactional --table "$BATS_TEST_NAME" --query foo --columns 1
    wait
    [ $status -eq 0 ]
    [ "$output" = "Tha Boo is hara" ]
}
