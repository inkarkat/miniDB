#!/bin/bash

setup()
{
    initialize_table "$BATS_TEST_NAME" from one-entry
    clear_lock "$BATS_TEST_NAME"
    miniDB --table "$BATS_TEST_NAME" --update "counter	0"
}
INITIAL_ROW_NUM=2

assert_counter()
{
    total="$(miniDB --no-transaction --table "$BATS_TEST_NAME" --query counter --columns 1)"
    [ "$DEBUG" ] && echo >&3 "# total: $total"
    [ $total "$@" ]
}

assert_key_num()
{
    total="$(miniDB --no-transaction --table "$BATS_TEST_NAME" --query-keys | wc -l)"
    [ "$DEBUG" ] && echo >&3 "# total: $total"
    [ $total "$@" ]
}

SEQUENTIAL_NUMBER=50
MIXED_NUMBER=10
CONCURRENT_NUMBER=50
