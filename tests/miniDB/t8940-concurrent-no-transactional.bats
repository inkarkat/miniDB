#!/usr/bin/env bats

load temp_database
load concurrent

no_transaction_add()
{
    counter="${1:?}"; shift
    miniDB "$@" --no-transaction --table "$BATS_TEST_NAME" --update "$counter	dummy value"
}



@test "50 sequential non-transactional additions to a table keep all keys" {
    for ((i = 0; i < 50; i++))
    do
	no_transaction_add "$i"
    done

    assert_key_num -eq $((50 + INITIAL_ROW_NUM))
}

@test "10 concurrent non-transactional additions to a table lose some additions" {
    for ((i = 0; i < 10; i++))
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
    assert_key_num -lt $((50 + INITIAL_ROW_NUM))
}

@test "50 concurrent non-transactional additions to a table lose some additions" {
    for ((i = 0; i < 50; i++))
    do
	no_transaction_add "$i" --transaction-timeout 10 &
    done

    wait
    assert_key_num -lt $((50 + INITIAL_ROW_NUM))
}
