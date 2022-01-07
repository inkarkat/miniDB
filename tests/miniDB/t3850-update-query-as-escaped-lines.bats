#!/usr/bin/env bats

load temp_database

@test "update with a new key and numerical column does not output anything when requesting full record as escaped lines" {
    initialize_table "$BATS_TEST_NAME" from one-entry

    run miniDB --table "$BATS_TEST_NAME" --update 'quux' --column '1=This has been added' --columns 0\* --as-escaped-lines
    [ $status -eq 0 ]
    [ "$output" = "" ]
}

@test "updated plain single-line key can be queried as escaped lines of the full record" {
    initialize_table "$BATS_TEST_NAME" from multiline-schema

    run miniDB --table "$BATS_TEST_NAME" --update \* --column COUNT++ --columns 0\*  --as-escaped-lines
    [ $status -eq 0 ]

    [ "$output" = "*
Looks like a placeholder to me
0" ]
}

@test "updated single-line record with backslash can be queried as escaped lines of all non-key columns" {
    initialize_table "$BATS_TEST_NAME" from multiline-schema

    run miniDB --table "$BATS_TEST_NAME" --update foo --column 'DESCRIPTION=A Foo has been updated' --columns \* --as-escaped-lines

    [ "$output" = 'The /Foo\\ is here
42
with backslash' ]
}

@test "update of multi-line record with backslash can be queried as escaped lines of changed columns" {
    initialize_table "$BATS_TEST_NAME" from multiline-schema

    run miniDB --table "$BATS_TEST_NAME" --update bar --column $'NOTES=with\nmultiple\nnewlines' --column COUNT++ --column '1=A man once walked' --columns \# --as-escaped-lines

    [ "$output" = 'with one\nnewline and \\ backslash
21
A man\n\nwalks in\\to a' ]
}

@test "update of record with just a key can be queried as escaped lines of names and indices" {
    initialize_table "$BATS_TEST_NAME" from multiline-schema

    run miniDB --table "$BATS_TEST_NAME" --update empty --column COUNT++ --columns '0 COUNT 3 DESCRIPTION' --as-escaped-lines

    [ "$output" = 'empty' ]
}
