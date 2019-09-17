#!/usr/bin/env bats

load temp_database

setup()
{
    initialize_table "$BATS_TEST_NAME" from one-entry
    clear_lock "$BATS_TEST_NAME"
    export NOW=1568635000
}

@test "when inside a current transaction, reads and writes work" {
    miniDB --start-write-transaction Trans1 --table "$BATS_TEST_NAME"
    let NOW+=1
    run miniDB --within-transaction Trans1 --table "$BATS_TEST_NAME" --query foo
    [ $status -eq 0 ]
    [ "$output" = "foo	The Foo is here	42" ]
    let NOW+=1
    run miniDB --within-transaction Trans1 --table "$BATS_TEST_NAME" --update "foo	A Foo has been updated	43"
    [ $status -eq 0 ]
}

@test "when inside an expired transaction a read action print a warning" {
    miniDB --start-write-transaction Trans1 --table "$BATS_TEST_NAME"
    let NOW+=1
    miniDB --within-transaction Trans1 --table "$BATS_TEST_NAME" --query foo

    let NOW+=4
    run miniDB --within-transaction Trans1 --table "$BATS_TEST_NAME" --query foo
    [ "${lines[0]}" = "Warning: Current transaction timed out 2 seconds ago." ]
    [ "${lines[1]}" = "foo	The Foo is here	42" ]
}

@test "when inside an expired shared transaction a read action print a warning" {
    miniDB --start-read-transaction Trans1 --table "$BATS_TEST_NAME"
    miniDB --start-read-transaction Trans2 --table "$BATS_TEST_NAME"
    lock_is_shared "$BATS_TEST_NAME"
    let NOW+=1
    miniDB --within-transaction Trans1 --table "$BATS_TEST_NAME" --query foo

    let NOW+=4
    run miniDB --within-transaction Trans1 --table "$BATS_TEST_NAME" --query foo
    [ "${lines[0]}" = "Warning: Current shared transaction timed out 2 seconds ago." ]
    [ "${lines[1]}" = "foo	The Foo is here	42" ]
    let NOW+=1
    run miniDB --within-transaction Trans2 --table "$BATS_TEST_NAME" --query foo
    [ "${lines[0]}" = "Warning: Current shared transaction timed out 3 seconds ago." ]
    [ "${lines[1]}" = "foo	The Foo is here	42" ]
}

@test "when inside an expired transaction a write action causes an error" {
    miniDB --start-write-transaction Trans1 --table "$BATS_TEST_NAME"

    let NOW+=5
    run miniDB --within-transaction Trans1 --table "$BATS_TEST_NAME" --update "foo	A Foo has been updated	43"
    [ $status -eq 6 ]
    [ "$output" = "ERROR: Current transaction timed out 2 seconds ago." ]
}

@test "when inside an expired transaction without having started one causes error" {
    run miniDB --within-transaction Trans1 --table "$BATS_TEST_NAME" --query foo
    [ $status -eq 6 ]
    [ "$output" = "ERROR: Not inside a transaction, or the transaction has timed out and another transaction was completed." ]
}

@test "when inside an expired transaction after it timed out and another one completed causes error" {
    miniDB --start-read-transaction Trans1 --table "$BATS_TEST_NAME"
    let NOW+=5
    miniDB --start-read-transaction Trans2 --table "$BATS_TEST_NAME"
    miniDB --end-transaction Trans2 --table "$BATS_TEST_NAME"

    run miniDB --within-transaction Trans1 --table "$BATS_TEST_NAME" --query foo
    [ $status -eq 6 ]
    [ "$output" = "ERROR: Not inside a transaction, or the transaction has timed out and another transaction was completed." ]
}

@test "when inside an expired transaction and another one has been started causes error" {
    miniDB --start-read-transaction Trans1 --table "$BATS_TEST_NAME"
    let NOW+=5
    miniDB --start-read-transaction Trans2 --table "$BATS_TEST_NAME"

    run miniDB --within-transaction Trans1 --table "$BATS_TEST_NAME" --query foo
    [ $status -eq 6 ]
    [ "$output" = "ERROR: Another read transaction by Trans2 has been started; any changes have been lost." ]
}
