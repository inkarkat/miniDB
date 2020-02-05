#!/usr/bin/env bats

load temp_database
load concurrent

no_transaction_increment()
{
    counter="$(miniDB "$@" --no-transaction --table "$BATS_TEST_NAME" --query counter --columns 1)"
    let counter+=1
    miniDB "$@" --no-transaction --table "$BATS_TEST_NAME" --update "counter	$counter"
}



@test "50 sequential non-transactional updates to a table keep all updates" {
    for ((i = 0; i < 50; i++))
    do
	no_transaction_increment
    done

    assert_counter -eq 50
}

@test "10 concurrent non-transactional updates to a table lose some updates" {
    for ((i = 0; i < 10; i++))
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
    assert_counter -lt 50
}

@test "50 concurrent non-transactional updates to a table lose some updates" {
    for ((i = 0; i < 50; i++))
    do
	no_transaction_increment &
    done

    wait
    assert_counter -lt 50
}
