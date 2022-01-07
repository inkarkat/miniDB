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

@test "update of an existing record with one changed numerical column prints the previous column value when requesting updated columns" {
    initialize_table "$BATS_TEST_NAME" from one-entry

    run miniDB --table "$BATS_TEST_NAME" --update 'foo'	--column '1=A Foo has been updated' --columns \#
    [ $status -eq 0 ]
    [ "$output" = 'The Foo is here' ]
}

@test "update of an existing record with one changed named column prints the previous column value when requesting updated columns" {
    initialize_table "$BATS_TEST_NAME" from multiline-schema

    run miniDB --table "$BATS_TEST_NAME" --update 'foo'	--column 'DESCRIPTION=A Foo has been updated' --columns \#
    [ $status -eq 0 ]
    [ "$output" = 'The /Foo\ is here' ]
}

@test "update of an existing record with two changed named columns prints the previous column values when requesting updated columns" {
    initialize_table "$BATS_TEST_NAME" from multiline-schema

    run miniDB --table "$BATS_TEST_NAME" --update 'foo'	--column 'DESCRIPTION=A Foo has been updated' --column COUNT++ --columns \#
    [ $status -eq 0 ]
    [ "$output" = 'The /Foo\ is here	42' ]
}

@test "update of an existing record with multiple changed named columns including the key prints the previous column values in the given order when requesting updated columns" {
    initialize_table "$BATS_TEST_NAME" from multiline-schema

    run miniDB --table "$BATS_TEST_NAME" --update 'foo'	--column 'NOTES=got modified' --column COUNT++ --column 'ID=fox' --column 'DESCRIPTION=Now a fox.' --columns \#
    [ $status -eq 0 ]
    [ "$output" = 'with backslash	42	foo	The /Foo\ is here' ]
}

@test "update of an existing record that adds additional fields prints the previous empty values when requesting updated changes" {
    initialize_table "$BATS_TEST_NAME" from multiline-schema

    run miniDB --table "$BATS_TEST_NAME" --update empty --column 'COUNT=11' --column 'NOTES=Now with count' --columns \#
    [ $status -eq 0 ]
    [ "$output" = "	" ]
}
