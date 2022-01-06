#!/usr/bin/env bats

load temp_database

@test "increment an existing key with a numerical column is one beyond the existing ones" {
    initialize_table "$BATS_TEST_NAME" from one-entry

    run miniDB --table "$BATS_TEST_NAME" --update 'foo' --column 3++
    assert_table_row "$BATS_TEST_NAME" \$ 'foo	The Foo is here	42	1'
}

@test "increment an existing key with a schema name column is one beyond the existing ones" {
    initialize_table "$BATS_TEST_NAME" from multiline-schema

    run miniDB --table "$BATS_TEST_NAME" --update 'o O' --column COUNT++
    assert_table_row "$BATS_TEST_NAME" 5 'o O	An ID with space in it	1'
}

@test "increment an existing key with schema name columns is beyond the existing ones" {
    initialize_table "$BATS_TEST_NAME" from multiline-schema

    run miniDB --table "$BATS_TEST_NAME" --update 'empty' --column COUNT++ --column NOTES++
    assert_table_row "$BATS_TEST_NAME" 6 'empty		1	1'
}

@test "increment an existing key with a numerical column far beyond the existing ones" {
    initialize_table "$BATS_TEST_NAME" from one-entry

    run miniDB --table "$BATS_TEST_NAME" --update 'foo' --column 10++
    assert_table_row "$BATS_TEST_NAME" \$ 'foo	The Foo is here	42								1'
}

@test "increment an existing key with numerical columns far beyond the existing ones and in mixed order" {
    initialize_table "$BATS_TEST_NAME" from one-entry

    run miniDB --table "$BATS_TEST_NAME" --update 'foo' --column 10++ --column 9++ --column 2++ --column 7++ --column 6++
    assert_table_row "$BATS_TEST_NAME" \$ 'foo	The Foo is here	43				1	1		1	1'
}
