#!/usr/bin/env bats

load temp_database

setup()
{
    TX=Trans1
    clear_lock "$BATS_TEST_NAME"
}

@test "ending without any action works" {
    initialize_table "$BATS_TEST_NAME" from one-entry
    miniDB --start-write-transaction "$TX" --table "$BATS_TEST_NAME"
    miniDB --end-transaction "$TX" --table "$BATS_TEST_NAME"

    assert_table_row "$BATS_TEST_NAME" \$ "foo	The Foo is here	42"
}

@test "ending after read action works" {
    initialize_table "$BATS_TEST_NAME" from one-entry
    miniDB --start-read-transaction "$TX" --table "$BATS_TEST_NAME"
    miniDB --within-transaction "$TX" --table "$BATS_TEST_NAME" --query foo
    miniDB --end-transaction "$TX" --table "$BATS_TEST_NAME"

    assert_table_row "$BATS_TEST_NAME" \$ "foo	The Foo is here	42"
}

@test "ending after an update keeps that update" {
    initialize_table "$BATS_TEST_NAME" from one-entry
    miniDB --start-write-transaction "$TX" --table "$BATS_TEST_NAME"
    miniDB --within-transaction "$TX" --table "$BATS_TEST_NAME" --update "foo	A Foo has been updated	43"
    assert_table_row "$BATS_TEST_NAME" \$ "foo	A Foo has been updated	43"
    miniDB --end-transaction "$TX" --table "$BATS_TEST_NAME"

    assert_table_row "$BATS_TEST_NAME" \$ "foo	A Foo has been updated	43"
}

@test "ending after update and addition keeps all changes" {
    initialize_table "$BATS_TEST_NAME" from one-entry
    miniDB --start-write-transaction "$TX" --table "$BATS_TEST_NAME"
    miniDB --within-transaction "$TX" --table "$BATS_TEST_NAME" --update "foo	A Foo has been updated	43"
    miniDB --within-transaction "$TX" --table "$BATS_TEST_NAME" --update "quux This has been added	100"
    miniDB --end-transaction "$TX" --table "$BATS_TEST_NAME"

    assert_table_row "$BATS_TEST_NAME" 2 "foo	A Foo has been updated	43"
    assert_table_row "$BATS_TEST_NAME" \$ "quux This has been added	100"
}

@test "ending without table creation does not create a table" {
    clean_table "$BATS_TEST_NAME"
    miniDB --start-write-transaction "$TX" --table "$BATS_TEST_NAME"
    ! table_exists "$BATS_TEST_NAME"
    miniDB --end-transaction "$TX" --table "$BATS_TEST_NAME"

    ! table_exists "$BATS_TEST_NAME"
}
