#!/usr/bin/env bats

load temp_database

@test "increment existing 42 in numeric column" {
    initialize_table "$BATS_TEST_NAME" from some-entries

    miniDB --table "$BATS_TEST_NAME" --update foo --column 2++
    assert_table_row "$BATS_TEST_NAME" 2 "foo	The Foo is here	43"
}

@test "increment existing 42 in schema name column" {
    initialize_table "$BATS_TEST_NAME" from some-entries

    miniDB --schema 'KEY TEXT NUMBER' --table "$BATS_TEST_NAME" --update foo --column NUMBER++
    assert_table_row "$BATS_TEST_NAME" 2 "foo	The Foo is here	43"
}

@test "increment existing 99 in numeric column" {
    initialize_table "$BATS_TEST_NAME" from some-entries

    miniDB --table "$BATS_TEST_NAME" --update baz --column 2++
    assert_table_row "$BATS_TEST_NAME" 9 "baz	Last one here	100"
}

@test "increment zero apples" {
    initialize_table "$BATS_TEST_NAME" from numbers

    miniDB --table "$BATS_TEST_NAME" --update 'zero' --column APPLES++
    assert_table_row "$BATS_TEST_NAME" 2 "zero	1	0	0	nothing there"
}

@test "increment zero bananas" {
    initialize_table "$BATS_TEST_NAME" from numbers

    miniDB --table "$BATS_TEST_NAME" --update 'zero' --column BANANAS++
    assert_table_row "$BATS_TEST_NAME" 2 "zero	0	1	0	nothing there"
}

@test "increment zero apples and bananas" {
    initialize_table "$BATS_TEST_NAME" from numbers

    miniDB --table "$BATS_TEST_NAME" --update 'zero' --column APPLES++ --column BANANAS++
    assert_table_row "$BATS_TEST_NAME" 2 "zero	1	1	0	nothing there"
}
@test "increment zero apples, bananas, and comment" {
    initialize_table "$BATS_TEST_NAME" from numbers

    miniDB --table "$BATS_TEST_NAME" --update 'zero' --column APPLES++ --column BANANAS++ --column 'COMMENT=got small delivery'
    assert_table_row "$BATS_TEST_NAME" 2 "zero	1	1	0	got small delivery"
}
