#!/usr/bin/env bats

load temp_database

@test "update with a new key and numerical column does not output anything when requesting full record as shell variables" {
    initialize_table "$BATS_TEST_NAME" from one-entry

    run miniDB --table "$BATS_TEST_NAME" --update 'quux' --column '1=This has been added' --columns 0\* --as-shell-variables
    [ $status -eq 0 ]
    [ "$output" = "" ]
}

@test "updated plain single-line key can be queried as shell variables of the full record" {
    initialize_table "$BATS_TEST_NAME" from multiline-schema

    run miniDB --table "$BATS_TEST_NAME" --update \* --column COUNT++ --columns 0\*  --as-shell-variables
    [ $status -eq 0 ]

    [ "$output" = "ID=\*
DESCRIPTION=Looks\\ like\\ a\\ placeholder\\ to\\ me
COUNT=0
NOTES=''" ]
}

@test "updated single-line record with backslash can be queried as shell variables of all non-key columns" {
    initialize_table "$BATS_TEST_NAME" from multiline-schema

    run miniDB --table "$BATS_TEST_NAME" --update foo --column 'DESCRIPTION=A Foo has been updated' --columns \* --as-shell-variables

    [ "$output" = "DESCRIPTION=The\\ /Foo\\\\\\ is\\ here
COUNT=42
NOTES=with\ backslash" ]
}

@test "update of multi-line record with backslash can be queried as shell variables of changed columns" {
    initialize_table "$BATS_TEST_NAME" from multiline-schema

    run miniDB --table "$BATS_TEST_NAME" --update bar --column $'NOTES=with\nmultiple\nnewlines' --column COUNT++ --column '1=A man once walked' --columns \# --as-shell-variables

    [ "$output" = "NOTES=$'with one\\nnewline and \\\\ backslash'
COUNT=21
DESCRIPTION=$'A man\\n\\nwalks in\\\\to a'" ]
}

@test "update of record with just a key can be queried as shell variables of names and indices" {
    initialize_table "$BATS_TEST_NAME" from multiline-schema

    run miniDB --table "$BATS_TEST_NAME" --update empty --column COUNT++ --columns '0 COUNT 3 DESCRIPTION' --as-shell-variables

    [ "$output" = "ID=empty
COUNT=''
NOTES=''
DESCRIPTION=''" ]
}
