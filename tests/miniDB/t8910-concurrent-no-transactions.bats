#!/usr/bin/env bats

load temp_database
load concurrent

no_transaction_increment()
{
    counter="$(miniDB "$@" --no-transaction --table "$BATS_TEST_NAME" --query counter --columns 1)"
    let counter+=1
    miniDB "$@" --no-transaction --table "$BATS_TEST_NAME" --update "counter	$counter"
}



@test "$SEQUENTIAL_NUMBER sequential non-transactional updates to a table keep all updates" {
    for ((i = 0; i < $SEQUENTIAL_NUMBER; i++))
    do
	no_transaction_increment
    done

    assert_counter -eq $SEQUENTIAL_NUMBER
}

@test "$MIXED_NUMBER concurrent non-transactional updates to a table lose some updates" {
    for ((i = 0; i < $MIXED_NUMBER; i++))
    do
	(
	    no_transaction_increment
	    no_transaction_increment
	    no_transaction_increment
	    no_transaction_increment
	    no_transaction_increment
	) &
    done

    wait
    assert_counter -lt $((MIXED_NUMBER * 5))
}

@test "$CONCURRENT_NUMBER concurrent non-transactional updates to a table lose some updates" {
    for ((i = 0; i < $CONCURRENT_NUMBER; i++))
    do
	no_transaction_increment &
    done

    wait
    assert_counter -lt $CONCURRENT_NUMBER
}
