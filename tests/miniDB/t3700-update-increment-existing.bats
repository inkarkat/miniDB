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

@test "increment zero apples and bananas in different order" {
    initialize_table "$BATS_TEST_NAME" from numbers

    miniDB --table "$BATS_TEST_NAME" --update 'zero' --column BANANAS++ --column APPLES++
    assert_table_row "$BATS_TEST_NAME" 2 "zero	1	1	0	nothing there"
}

@test "increment zero apples, bananas, and comment in different order" {
    initialize_table "$BATS_TEST_NAME" from numbers

    miniDB --table "$BATS_TEST_NAME" --update 'zero' --column BANANAS++ --column 'COMMENT=got small delivery' --column APPLES++
    assert_table_row "$BATS_TEST_NAME" 2 "zero	1	1	0	got small delivery"
}

@test "increment small apples, bananas, and oranges" {
    initialize_table "$BATS_TEST_NAME" from numbers

    miniDB --table "$BATS_TEST_NAME" --update 'small' --column APPLES++ --column BANANAS++ --column ORANGES++
    assert_table_row "$BATS_TEST_NAME" 4 "small	2	10	3	minimal"
}

@test "increment medium apples, bananas, and oranges" {
    initialize_table "$BATS_TEST_NAME" from numbers

    miniDB --table "$BATS_TEST_NAME" --update 'medium' --column APPLES++ --column BANANAS++ --column ORANGES++
    assert_table_row "$BATS_TEST_NAME" 5 "medium	34	50	10	good"
}

@test "increment large apples, bananas, and oranges" {
    initialize_table "$BATS_TEST_NAME" from numbers

    miniDB --table "$BATS_TEST_NAME" --update 'large' --column APPLES++ --column BANANAS++ --column ORANGES++
    assert_table_row "$BATS_TEST_NAME" 6 "large	1000	4322	4000	will last"
}

