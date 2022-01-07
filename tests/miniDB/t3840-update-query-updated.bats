#!/usr/bin/env bats

load temp_database

@test "update with a new key and record does not output anything when requesting updated columns" {
    initialize_table "$BATS_TEST_NAME" from one-entry

    run miniDB --table "$BATS_TEST_NAME" --update "new	A new record this is.	11" --columns \#
    [ $status -eq 0 ]
    [ "$output" = "" ]
}

@test "update with a new key and numerical column does not output anything when requesting updated columns" {
    initialize_table "$BATS_TEST_NAME" from one-entry

    run miniDB --table "$BATS_TEST_NAME" --update 'quux' --column '1=This has been added' --columns \#
    [ $status -eq 0 ]
    [ "$output" = "" ]
}

@test "update of an existing record prints the previous full record when requesting updated columns" {
    initialize_table "$BATS_TEST_NAME" from one-entry

    run miniDB --table "$BATS_TEST_NAME" --update "foo	A Foo has been updated	42" --columns \#
    [ $status -eq 0 ]
    [ "$output" = 'foo	The Foo is here	42' ]
}
