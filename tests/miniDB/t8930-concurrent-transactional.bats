#!/usr/bin/env bats

load temp_database
load concurrent

transactional_add()
{
    counter="${1:?}"; shift
    miniDB "$@" --transactional --table "$BATS_TEST_NAME" --update "$counter	dummy value"
}



@test "$SEQUENTIAL_NUMBER sequential transactional additions to a table keep all keys" {
    for ((i = 0; i < $SEQUENTIAL_NUMBER; i++))
    do
	transactional_add "$i"
    done

    assert_key_num -eq $((SEQUENTIAL_NUMBER + INITIAL_ROW_NUM))
}

@test "$MIXED_NUMBER concurrent transactional additions to a table keep all keys" {
    for ((i = 0; i < $MIXED_NUMBER; i++))
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
    assert_key_num -eq $((MIXED_NUMBER * 5 + INITIAL_ROW_NUM))
}

@test "$CONCURRENT_NUMBER concurrent transactional additions to a table keep all keys" {
    for ((i = 0; i < $CONCURRENT_NUMBER; i++))
    do
	transactional_add "$i" --transaction-timeout 10 &
    done

    wait
    assert_key_num -eq $((CONCURRENT_NUMBER + INITIAL_ROW_NUM))
}
