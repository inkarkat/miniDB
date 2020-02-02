#!/usr/bin/env bats

load temp_database

setup()
{
    initialize_table "$BATS_TEST_NAME" from one-entry
    clear_lock "$BATS_TEST_NAME"
    miniDB --table "$BATS_TEST_NAME" --update "counter	0"
}

no_transaction_increment()
{
    counter="$(miniDB "$@" --no-transaction --table "$BATS_TEST_NAME" --query counter --columns 1)"
    let counter+=1
    miniDB "$@" --no-transaction --table "$BATS_TEST_NAME" --update "counter	$counter"
}

assert_counter()
{
    total="$(miniDB --no-transaction --table "$BATS_TEST_NAME" --query counter --columns 1)"
    echo >&3 "# total: $total"
    [ $total "$@" ]
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
