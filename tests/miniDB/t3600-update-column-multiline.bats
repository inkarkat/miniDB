#!/usr/bin/env bats

load fixture
load temp_database

@test "update of an existing key and numeric column with multi-line string can be queried again" {
    update='Here is
multi-line

text'
    initialize_table "$BATS_TEST_NAME" from one-entry

    miniDB --table "$BATS_TEST_NAME" --update 'foo' --column "1=$update"
    result="$(miniDB --table "$BATS_TEST_NAME" --query 'foo' --columns 1)"

    assert_equal "$result" "$update"
}

@test "update of an existing key and additional numeric column with backslashes can be queried again" {
    initialize_table "$BATS_TEST_NAME" from one-entry
    update='/value\column/>\t\r\n<'
    miniDB --table "$BATS_TEST_NAME" --update 'foo' --column "4=$update"

    assert_equal "$(miniDB --table "$BATS_TEST_NAME" --query 'foo' --columns 4)" "$update"
}

@test "update of a new key and numeric column with multi-line string adds a single row" {
    initialize_table "$BATS_TEST_NAME" from one-entry
    rowNum="$(get_row_number "$BATS_TEST_NAME")"

    miniDB --table "$BATS_TEST_NAME" --update 'new' --column "1=$update"

    assert_row_count "$(get_row_number "$BATS_TEST_NAME")" $((rowNum + 1))
}

@test "update of a new key and numeric column with multi-line and backslashed string can be queried again" {
    update='s t r a n g e
//k\te\ry\\'
    initialize_table "$BATS_TEST_NAME" from one-entry

    miniDB --table "$BATS_TEST_NAME" --update 'new' --column "2=$update"

    assert_equal "$(miniDB --table "$BATS_TEST_NAME" --query 'new')" "new		$update"
}
