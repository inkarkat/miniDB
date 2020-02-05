#!/usr/bin/env bats

load temp_database
load concurrent

no_transaction_add()
{
    counter="${1:?}"; shift
    miniDB "$@" --no-transaction --table "$BATS_TEST_NAME" --update "$counter	dummy value"
}



@test "$SEQUENTIAL_NUMBER sequential non-transactional additions to a table keep all keys" {
    for ((i = 0; i < $SEQUENTIAL_NUMBER; i++))
    do
	no_transaction_add "$i"
    done

    assert_key_num -eq $((SEQUENTIAL_NUMBER + INITIAL_ROW_NUM))
}

@test "$MIXED_NUMBER concurrent non-transactional additions to a table lose some additions" {
    for ((i = 0; i < $MIXED_NUMBER; i++))
    do
	(
	    no_transaction_add "$((i * 5 + 0))"
	    no_transaction_add "$((i * 5 + 1))"
	    no_transaction_add "$((i * 5 + 2))"
	    no_transaction_add "$((i * 5 + 3))"
	    no_transaction_add "$((i * 5 + 4))"
	) &
    done

    wait
    assert_key_num -lt $((MIXED_NUMBER * 5 + INITIAL_ROW_NUM))
}

@test "$CONCURRENT_NUMBER concurrent non-transactional additions to a table lose some additions" {
    for ((i = 0; i < $CONCURRENT_NUMBER; i++))
    do
	no_transaction_add "$i" --transaction-timeout 10 &
    done

    wait
    assert_key_num -lt $((CONCURRENT_NUMBER + INITIAL_ROW_NUM))
}
