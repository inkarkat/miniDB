#!/usr/bin/env bats

load temp_database

@test "update with a new key and numerical column adds a row" {
    initialize_table "$BATS_TEST_NAME" from one-entry

    miniDB --table "$BATS_TEST_NAME" --update 'quux' --column '1=This has been added'

    assert_table_row "$BATS_TEST_NAME" 1 "# KEY	COLUMN	..."
    assert_table_row "$BATS_TEST_NAME" 2 "foo	The Foo is here	42"
    assert_table_row "$BATS_TEST_NAME" 3 "quux	This has been added"
}

@test "update with a new key and schema name column beyond the first column adds a row with an empty first column" {
    initialize_table "$BATS_TEST_NAME" from one-entry

    miniDB --schema 'KEY TEXT NUMBER' --table "$BATS_TEST_NAME" --update 'quux' --column "NUMBER=99"
    assert_table_row "$BATS_TEST_NAME" 1 "# KEY	COLUMN	..."
    assert_table_row "$BATS_TEST_NAME" 2 "foo	The Foo is here	42"
    assert_table_row "$BATS_TEST_NAME" 3 "quux		99"
}

@test "update with new keys twice and numerical values adds two rows" {
    initialize_table "$BATS_TEST_NAME" from one-entry

    miniDB --table "$BATS_TEST_NAME" --update 'quux' --column '1=This has been added' --column '2=100'
    miniDB --table "$BATS_TEST_NAME" --update 'quuu' --column '2=200' --column '1=Another addition'

    assert_table_row "$BATS_TEST_NAME" 1 "# KEY	COLUMN	..."
    assert_table_row "$BATS_TEST_NAME" 2 "foo	The Foo is here	42"
    assert_table_row "$BATS_TEST_NAME" 3 "quux	This has been added	100"
    assert_table_row "$BATS_TEST_NAME" 4 "quuu	Another addition	200"
}

@test "update with a new key and a column that renames the key adds a row with the latter" {
    initialize_table "$BATS_TEST_NAME" from one-entry

    miniDB --table "$BATS_TEST_NAME" --update 'quux' --column '0=changed'

    assert_table_row "$BATS_TEST_NAME" 1 "# KEY	COLUMN	..."
    assert_table_row "$BATS_TEST_NAME" 2 "foo	The Foo is here	42"
    assert_table_row "$BATS_TEST_NAME" 3 "changed	"
}
