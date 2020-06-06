#!/usr/bin/env bats

load temp_database

@test "update of an existing key and numeric column overwrites that column's value" {
    initialize_table "$BATS_TEST_NAME" from one-entry

    run miniDB --table "$BATS_TEST_NAME" --update 'foo' --column "2=77"
    echo >&3 \#"$output"
    assert_table_row "$BATS_TEST_NAME" 1 "# KEY	COLUMN	..."
    assert_table_row "$BATS_TEST_NAME" 2 "foo	The Foo is here	77"
    assert_table_row "$BATS_TEST_NAME" \$ "foo	The Foo is here	77"
}

@test "update of an existing key and schema name column overwrites that column's value" {
    initialize_table "$BATS_TEST_NAME" from one-entry

    run miniDB --schema 'KEY TEXT NUMBER' --table "$BATS_TEST_NAME" --update 'foo' --column "NUMBER=77"
    assert_table_row "$BATS_TEST_NAME" 1 "# KEY	COLUMN	..."
    assert_table_row "$BATS_TEST_NAME" 2 "foo	The Foo is here	77"
    assert_table_row "$BATS_TEST_NAME" \$ "foo	The Foo is here	77"
}

@test "update of an existing key and multiple numeric columns overwrites the column values" {
    initialize_table "$BATS_TEST_NAME" from multiline-schema

    run miniDB --table "$BATS_TEST_NAME" --update 'foo' --column '1=The /Update\ is now here' --column '3=again with backslash'
    assert_table_row "$BATS_TEST_NAME" 2 'foo	The /Update\\ is now here	42	again with backslash'
}

@test "update of an existing key and multiple schema name columns overwrites the column values" {
    initialize_table "$BATS_TEST_NAME" from multiline-schema

    run miniDB --table "$BATS_TEST_NAME" --update 'foo' --column 'DESCRIPTION=The /Update\ is now here' --column 'NOTES=again with backslash'
    assert_table_row "$BATS_TEST_NAME" 2 'foo	The /Update\\ is now here	42	again with backslash'
}

@test "update of an existing key and numeric key overwrites the key" {
    initialize_table "$BATS_TEST_NAME" from one-entry

    run miniDB --table "$BATS_TEST_NAME" --update 'foo' --column "0=new"
    assert_table_row "$BATS_TEST_NAME" 1 "# KEY	COLUMN	..."
    assert_table_row "$BATS_TEST_NAME" 2 "new	The Foo is here	42"
    assert_table_row "$BATS_TEST_NAME" \$ "new	The Foo is here	42"
}

@test "update of an existing key and schema name key overwrites the key" {
    initialize_table "$BATS_TEST_NAME" from one-entry

    run miniDB --schema 'KEY TEXT NUMBER' --table "$BATS_TEST_NAME" --update 'foo' --column "KEY=new"
    assert_table_row "$BATS_TEST_NAME" 1 "# KEY	COLUMN	..."
    assert_table_row "$BATS_TEST_NAME" 2 "new	The Foo is here	42"
    assert_table_row "$BATS_TEST_NAME" \$ "new	The Foo is here	42"
}

@test "update of an existing key and multiple columns overwrites the column values also when given in arbitrary order" {
    initialize_table "$BATS_TEST_NAME" from multiline-schema

    run miniDB --table "$BATS_TEST_NAME" --update 'foo' --column '3=now with exclamation' --column '1=Total makeover!' --column '0=new' --column '2=99'
    assert_table_row "$BATS_TEST_NAME" 2 'new	Total makeover!	99	now with exclamation'
}

@test "update of an existing key and multiple mixed numeric and schema name columns overwrites the column values also when given in arbitrary order" {
    initialize_table "$BATS_TEST_NAME" from multiline-schema

    run miniDB --table "$BATS_TEST_NAME" --update 'foo' --column 'NOTES=now with exclamation' --column '1=Total makeover!' --column '0=new' --column 'COUNT=99'
    assert_table_row "$BATS_TEST_NAME" 2 'new	Total makeover!	99	now with exclamation'
}
