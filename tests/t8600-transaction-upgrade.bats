#!/usr/bin/env bats

load temp_database

setup()
{
    initialize_table "$BATS_TEST_NAME" from one-entry
    clear_lock "$BATS_TEST_NAME"
    export NOW=1568635000
}

@test "when upgrading a read transaction that timed out, a warning is printed" {
    miniDB --start-read-transaction Trans1 --table "$BATS_TEST_NAME"

    let NOW+=4
    run miniDB --upgrade-to-write-transaction Trans1 --table "$BATS_TEST_NAME"
    [ $status -eq 0 ]
    [ "$output" = "Warning: Current transaction timed out 1 second ago." ]
}

@test "when upgrading a write transaction, a warning is printed" {
    miniDB --start-write-transaction Trans1 --table "$BATS_TEST_NAME"

    let NOW+=1
    run miniDB --upgrade-to-write-transaction Trans1 --table "$BATS_TEST_NAME"
    [ $status -eq 0 ]
    [ "$output" = "Note: Current transaction already is a write transaction, no need to upgrade." ]
}

@test "upgrading a read transaction works and extends the expiry time" {
    miniDB --start-read-transaction Trans1 --table "$BATS_TEST_NAME"

    let NOW+=2
    run miniDB --upgrade-to-write-transaction Trans1 --table "$BATS_TEST_NAME"
    [ $status -eq 0 ]
    [ "$output" = "" ]

    let NOW+=2
    miniDB --within-transaction Trans1 --table "$BATS_TEST_NAME" --update "foo	A Foo has been updated	43"
    miniDB --end-transaction Trans1 --table "$BATS_TEST_NAME"
}
