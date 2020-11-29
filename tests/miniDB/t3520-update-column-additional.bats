#!/usr/bin/env bats

load temp_database

@test "update of an existing key with a numerical column is one beyond the existing ones" {
    initialize_table "$BATS_TEST_NAME" from one-entry

    run miniDB --table "$BATS_TEST_NAME" --update 'foo' --column '3=Added'
    assert_table_row "$BATS_TEST_NAME" \$ 'foo	The Foo is here	42	Added'
}

@test "update of an existing key with a schema name column is one beyond the existing ones" {
    initialize_table "$BATS_TEST_NAME" from multiline-schema

    run miniDB --table "$BATS_TEST_NAME" --update 'o O' --column 'COUNT=1'
    assert_table_row "$BATS_TEST_NAME" 5 'o O	An ID with space in it	1'
}

@test "update of an existing key with schema name columns is beyond the existing ones" {
    initialize_table "$BATS_TEST_NAME" from multiline-schema

    run miniDB --table "$BATS_TEST_NAME" --update 'empty' --column 'COUNT=000' --column 'NOTES=skipping the description'
    assert_table_row "$BATS_TEST_NAME" 6 'empty		000	skipping the description'
}

@test "update of an existing key with a numerical column far beyond the existing ones" {
    initialize_table "$BATS_TEST_NAME" from one-entry

    run miniDB --table "$BATS_TEST_NAME" --update 'foo' --column '10=tenth column'
    assert_table_row "$BATS_TEST_NAME" \$ 'foo	The Foo is here	42								tenth column'
}

@test "update of an existing key with numerical columns far beyond the existing ones and in mixed order" {
    initialize_table "$BATS_TEST_NAME" from one-entry

    run miniDB --table "$BATS_TEST_NAME" --update 'foo' --column '10=tenth column' --column '9=ninth column' --column '2=More columns got added' --column '7=seventh' --column '6=sixth'
    assert_table_row "$BATS_TEST_NAME" \$ 'foo	The Foo is here	More columns got added				sixth	seventh		ninth column	tenth column'
}
