#!/usr/bin/env bats

load temp_database

@test "increment an existing empty column yields 1" {
    initialize_table "$BATS_TEST_NAME" from numbers

    miniDB --table "$BATS_TEST_NAME" --update 'empty' --column 1++
    assert_table_row "$BATS_TEST_NAME" 3 "empty	1			not even a zero"
}

@test "increment a text column does nothing" {
    initialize_table "$BATS_TEST_NAME" from one-entry

    miniDB --table "$BATS_TEST_NAME" --update 'foo' --column 1++
    assert_table_row "$BATS_TEST_NAME" 2 "foo	The Foo is here	42"
}

@test "increment text and number columns only affects the number column" {
    initialize_table "$BATS_TEST_NAME" from one-entry

    miniDB --table "$BATS_TEST_NAME" --update 'foo' --column 1++ --column 2++
    assert_table_row "$BATS_TEST_NAME" 2 "foo	The Foo is here	43"
}

@test "increment a column with trailing text does nothing" {
    initialize_table "$BATS_TEST_NAME" from quirky-numbers

    miniDB --table "$BATS_TEST_NAME" --update 'foo' --column 1++ --column 2++
    assert_table_row "$BATS_TEST_NAME" 2 "foo	21Guns	21 Jump Street"
}

@test "increment a column with surrounding text does nothing" {
    initialize_table "$BATS_TEST_NAME" from quirky-numbers

    miniDB --table "$BATS_TEST_NAME" --update 'bar' --column 1++ --column 2++
    assert_table_row "$BATS_TEST_NAME" 3 "bar	Catch22	good4you"
}

@test "increment a column with negative numbers does nothing" {
    initialize_table "$BATS_TEST_NAME" from quirky-numbers

    miniDB --table "$BATS_TEST_NAME" --update 'neg' --column 1++ --column 2++
    assert_table_row "$BATS_TEST_NAME" 4 "neg	-32	-0"
}

@test "increment a column with numbers surrounded by spaces does nothing" {
    initialize_table "$BATS_TEST_NAME" from quirky-numbers

    miniDB --table "$BATS_TEST_NAME" --update 'spaced' --column 1++ --column 2++
    assert_table_row "$BATS_TEST_NAME" 5 "spaced	3 	 4"
}
