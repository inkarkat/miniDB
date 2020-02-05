#!/bin/bash

assert_counter()
{
    total="$(miniDB --no-transaction --table "$BATS_TEST_NAME" --query counter --columns 1)"
    echo >&3 "# total: $total"
    [ $total "$@" ]
}

assert_key_num()
{
    total="$(miniDB --no-transaction --table "$BATS_TEST_NAME" --query-keys | wc -l)"
    echo >&3 "# total: $total"
    [ $total "$@" ]
}
