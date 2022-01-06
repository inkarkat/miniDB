#!/usr/bin/env bats

load temp_database

@test "update with a new key and numerical column increment adds a row with value 1" {
    initialize_table "$BATS_TEST_NAME" from one-entry

    miniDB --table "$BATS_TEST_NAME" --update 'quux' --column 1++

    assert_table_row "$BATS_TEST_NAME" 1 "# KEY	COLUMN	..."
    assert_table_row "$BATS_TEST_NAME" 2 "foo	The Foo is here	42"
    assert_table_row "$BATS_TEST_NAME" 3 "quux	1"
}

@test "update with a new key and schema name column increment beyond the first column adds a row with an empty first column and value 1" {
    initialize_table "$BATS_TEST_NAME" from one-entry

    miniDB --schema 'KEY TEXT NUMBER' --table "$BATS_TEST_NAME" --update 'quux' --column NUMBER++
    assert_table_row "$BATS_TEST_NAME" 1 "# KEY	COLUMN	..."
    assert_table_row "$BATS_TEST_NAME" 2 "foo	The Foo is here	42"
    assert_table_row "$BATS_TEST_NAME" 3 "quux		1"
}

@test "update with new keys twice and incremented values adds two rows" {
    initialize_table "$BATS_TEST_NAME" from one-entry

    miniDB --table "$BATS_TEST_NAME" --update 'quux' --column 1++ --column 2++
    miniDB --table "$BATS_TEST_NAME" --update 'quuu' --column 1++ --column 2++

    assert_table_row "$BATS_TEST_NAME" 1 "# KEY	COLUMN	..."
    assert_table_row "$BATS_TEST_NAME" 2 "foo	The Foo is here	42"
    assert_table_row "$BATS_TEST_NAME" 3 "quux	1	1"
    assert_table_row "$BATS_TEST_NAME" 4 "quuu	1	1"
}

@test "update with a new key and a column that increments the key adds a row with the latter" {
    initialize_table "$BATS_TEST_NAME" from one-entry

    miniDB --table "$BATS_TEST_NAME" --update 'quux' --column '0++'

    assert_table_row "$BATS_TEST_NAME" 1 "# KEY	COLUMN	..."
    assert_table_row "$BATS_TEST_NAME" 2 "foo	The Foo is here	42"
    assert_table_row "$BATS_TEST_NAME" 3 "1	"
}
