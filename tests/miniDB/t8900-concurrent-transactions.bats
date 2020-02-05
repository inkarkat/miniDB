#!/usr/bin/env bats

load temp_database
load concurrent

transactional_increment()
{
    owner="${1:?}"; shift
    miniDB "$@" --start-write-transaction "$owner" --table "$BATS_TEST_NAME"
    counter="$(miniDB "$@" --within-transaction "$owner" --table "$BATS_TEST_NAME" --query counter --columns 1)"
    let counter+=1
    miniDB "$@" --within-transaction "$owner" --table "$BATS_TEST_NAME" --update "counter	$counter"
    miniDB "$@" --end-transaction "$owner" --table "$BATS_TEST_NAME"
}



@test "50 sequential transactional updates to a table keep all updates" {
    for ((i = 0; i < 50; i++))
    do
	transactional_increment "$$"
    done

    assert_counter -eq 50
}

@test "10 concurrent transactional updates to a table keep all updates" {
    for ((i = 0; i < 10; i++))
    do
	(
	    transactional_increment "$i"
	    transactional_increment "$i"
	    transactional_increment "$i"
	    transactional_increment "$i"
	    transactional_increment "$i"
	) &
    done

    wait
    assert_counter -eq 50
}

@test "50 concurrent transactional updates to a table keep all updates" {
    for ((i = 0; i < 50; i++))
    do
	transactional_increment "$i" --transaction-timeout 10 &
    done

    wait
    assert_counter -eq 50
}

