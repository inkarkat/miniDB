#!/usr/bin/env bats

load temp_database

@test "update with a new key and numerical column does not output anything when omitting the key" {
    initialize_table "$BATS_TEST_NAME" from one-entry

    run miniDB --table "$BATS_TEST_NAME" --update 'quux' --column '1=This has been added' --columns \*
    [ $status -eq 0 ]
    [ "$output" = "" ]
}

@test "update of an existing key prints the previous columns omitting the key" {
    initialize_table "$BATS_TEST_NAME" from one-entry

    run miniDB --table "$BATS_TEST_NAME" --update "foo	A Foo has been updated	43" --columns \*
    [ $status -eq 0 ]
    [ "$output" = 'The Foo is here	42' ]
}

@test "update of an existing key and numeric column prints the previous columns omitting the key" {
    initialize_table "$BATS_TEST_NAME" from one-entry

    run miniDB --table "$BATS_TEST_NAME" --update 'foo' --column "2=77" --columns \*
    [ $status -eq 0 ]
    [ "$output" = 'The Foo is here	42' ]
}

@test "increment of existing multiline record prints the previous columns omitting the key" {
    initialize_table "$BATS_TEST_NAME" from multiline-schema

    run miniDB --table "$BATS_TEST_NAME" --update bar --column COUNT++ --columns \*
    [ $status -eq 0 ]
    [ "$output" = 'A man

walks in\to a	21	with one
newline and \ backslash' ]
}

@test "increment of existing key with space prints the previous columns omitting the key" {
    initialize_table "$BATS_TEST_NAME" from multiline-schema

    run miniDB --table "$BATS_TEST_NAME" --update 'o O' --column 2++ --columns \*
    [ $status -eq 0 ]
    [ "$output" = 'An ID with space in it' ]
}

@test "update of an existing key without columns prints the previous columns omitting the key" {
    initialize_table "$BATS_TEST_NAME" from multiline-schema

    run miniDB --table "$BATS_TEST_NAME" --update empty --column 'COUNT=000' --column 'NOTES=skipping the description' --columns \*
    [ $status -eq 0 ]
    [ "$output" = '' ]
}
