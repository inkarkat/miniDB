#!/usr/bin/env bats

load temp_database

@test "update with a new key and numerical column does not output anything when requesting full record" {
    initialize_table "$BATS_TEST_NAME" from one-entry

    run miniDB --table "$BATS_TEST_NAME" --update 'quux' --column '1=This has been added' --columns 0\*
    [ $status -eq 0 ]
    [ "$output" = "" ]
}

@test "update of an existing key prints the previous full record" {
    initialize_table "$BATS_TEST_NAME" from one-entry

    run miniDB --table "$BATS_TEST_NAME" --update "foo	A Foo has been updated	43" --columns 0\*
    [ $status -eq 0 ]
    [ "$output" = 'foo	The Foo is here	42' ]
}

@test "update of an existing key and numeric column prints the previous full record" {
    initialize_table "$BATS_TEST_NAME" from one-entry

    run miniDB --table "$BATS_TEST_NAME" --update 'foo' --column "2=77" --columns 0\*
    [ $status -eq 0 ]
    [ "$output" = 'foo	The Foo is here	42' ]
}

@test "increment of existing multiline record prints the previous full record" {
    initialize_table "$BATS_TEST_NAME" from multiline-schema

    run miniDB --table "$BATS_TEST_NAME" --update bar --column COUNT++ --columns 0\*
    [ $status -eq 0 ]
    [ "$output" = 'bar	A man

walks in\to a	21	with one
newline and \ backslash' ]
}

@test "increment of existing key with space prints the previous full record" {
    initialize_table "$BATS_TEST_NAME" from multiline-schema

    run miniDB --table "$BATS_TEST_NAME" --update 'o O' --column 2++ --columns 0\*
    [ $status -eq 0 ]
    [ "$output" = 'o O	An ID with space in it' ]
}

@test "update of an existing key without columns prints the previous full record" {
    initialize_table "$BATS_TEST_NAME" from multiline-schema

    run miniDB --table "$BATS_TEST_NAME" --update empty --column 'COUNT=000' --column 'NOTES=skipping the description' --columns 0\*
    [ $status -eq 0 ]
    [ "$output" = 'empty	' ]
}
