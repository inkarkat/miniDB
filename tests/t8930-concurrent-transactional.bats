#!/usr/bin/env bats

load temp_database

setup()
{
    initialize_table "$BATS_TEST_NAME" from one-entry
    clear_lock "$BATS_TEST_NAME"
}

assert_key_num()
{
    [ "$(miniDB --transactional --table "$BATS_TEST_NAME" --query-keys | wc -l)" -eq "${1:?}" ]
}

transactional_add()
{
    counter="${1:?}"; shift
    miniDB "$@" --transactional --table "$BATS_TEST_NAME" --update "$counter	dummy value"
}



@test "50 sequential transactional additions to a table keep all keys" {
    for ((i = 0; i < 50; i++))
    do
	transactional_add "$i"
    done

    assert_key_num 51
}

@test "10 concurrent transactional additions to a table keep all keys" {
    for ((i = 0; i < 10; i++))
    do
	(
	    transactional_add "$((i * 5 + 0))"
	    transactional_add "$((i * 5 + 1))"
	    transactional_add "$((i * 5 + 2))"
	    transactional_add "$((i * 5 + 3))"
	    transactional_add "$((i * 5 + 4))"
	) &
    done

    wait
    assert_key_num 51
}

@test "50 concurrent transactional additions to a table keep all keys" {
    for ((i = 0; i < 50; i++))
    do
	transactional_add "$i" --transaction-timeout 10 &
    done

    wait
    assert_key_num 51
}
