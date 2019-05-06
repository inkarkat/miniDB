#!/usr/bin/env bats

load temp_database

@test "update with multi-line string adds a single row" {
    initialize_table "$BATS_TEST_NAME" from one-entry
    rowNum="$(get_row_number "$BATS_TEST_NAME")"

    miniDB --table "$BATS_TEST_NAME" --update 'key	Here is
multi-line

text	with
multiple columns'

    updatedRowNum="$(get_row_number "$BATS_TEST_NAME")"; [ "$updatedRowNum" -eq $((rowNum + 1)) ]
}

@test "update with multi-line string can be queried again" {
    initialize_table "$BATS_TEST_NAME" from one-entry
    update='key	Here is
multi-line

text	with
multiple columns'
    miniDB --table "$BATS_TEST_NAME" --update "$update"

    result="$(miniDB --table "$BATS_TEST_NAME" --query key)"

    [ "$result" = "$update" ]
}

@test "update with backslashes can be queried again" {
    initialize_table "$BATS_TEST_NAME" from one-entry
    update='key	/value\	\\column//	>\t\r\n<	END'
    miniDB --table "$BATS_TEST_NAME" --update "$update"

    result="$(miniDB --table "$BATS_TEST_NAME" --query key)"

    [ "$result" = "$update" ]
}

@test "update with multi-line and backslashed key" {
    initialize_table "$BATS_TEST_NAME" from one-entry
    key='s t r a n g e
//k\te\ry\\'
    update="$key	value:	looks normal"
    miniDB --table "$BATS_TEST_NAME" --update "$update"

    result="$(miniDB --table "$BATS_TEST_NAME" --query "$key")"

    [ "$result" = "$update" ]
}

@test "update with multi-line and backslashed fallback key" {
    initialize_table "$BATS_TEST_NAME" from one-entry
    key='s t r a n g e
//k\te\ry\\'
    update="$key	value:	looks normal"
    miniDB --table "$BATS_TEST_NAME" --update "$update"

    result="$(miniDB --table "$BATS_TEST_NAME" --query notInHere --fallback "$key")"

    [ "$result" = "$update" ]
}

@test "update with echo arguments at the beginning of key properly outputs the key" {
    initialize_table "$BATS_TEST_NAME" from one-entry
    key='-n -E gaga'
    update="$key	some value"
    miniDB --table "$BATS_TEST_NAME" --update "$update"

    result="$(miniDB --table "$BATS_TEST_NAME" --query "$key")"

    [ "$result" = "$update" ]
}
