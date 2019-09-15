#!/usr/bin/env bats

load temp_database

setup()
{
    TX=Trans1
}

@test "aborting after an update loses that update" {
    initialize_table "$BATS_TEST_NAME" from one-entry
    miniDB --start-write-transaction "$TX" --table "$BATS_TEST_NAME"
    miniDB --within-transaction "$TX" --table "$BATS_TEST_NAME" --update "foo	A Foo has been updated	43"
    assert_table_row "$BATS_TEST_NAME" \$ "foo	A Foo has been updated	43"
    miniDB --abort-write-transaction "$TX" --table "$BATS_TEST_NAME"

    assert_table_row "$BATS_TEST_NAME" \$ "foo	The Foo is here	42"
}

@test "aborting after update and additon loses all changes" {
    initialize_table "$BATS_TEST_NAME" from one-entry
    miniDB --start-write-transaction "$TX" --table "$BATS_TEST_NAME"
    miniDB --within-transaction "$TX" --table "$BATS_TEST_NAME" --update "foo	A Foo has been updated	43"
    miniDB --within-transaction "$TX" --table "$BATS_TEST_NAME" --update "quux This has been added	100"
    miniDB --abort-write-transaction "$TX" --table "$BATS_TEST_NAME"

    assert_table_row "$BATS_TEST_NAME" 2 "foo	The Foo is here	42"
    assert_table_row "$BATS_TEST_NAME" \$ "foo	The Foo is here	42"
}

@test "aborting after table creation leaves behind an empty table" {
    clean_table "$BATS_TEST_NAME"
    miniDB --start-write-transaction "$TX" --table "$BATS_TEST_NAME"
    miniDB --within-transaction "$TX" --table "$BATS_TEST_NAME" --update "foo	This is new"
    [ "$(get_row_number "$BATS_TEST_NAME")" -eq 2 ]
    miniDB --abort-write-transaction "$TX" --table "$BATS_TEST_NAME"

    [ "$(get_row_number "$BATS_TEST_NAME")" -eq 0 ]
}
