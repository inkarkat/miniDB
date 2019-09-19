#!/usr/bin/env bats

load temp_database

setup()
{
    initialize_table "$BATS_TEST_NAME" from one-entry
    clear_lock "$BATS_TEST_NAME"
    miniDB --table "$BATS_TEST_NAME" --update "counter	0"
}

assert_counter()
{
    [ "$(miniDB --transactional --table "$BATS_TEST_NAME" --query counter --columns 1)" -eq "${1:?}" ]
}

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
return
    for ((i = 0; i < 50; i++))
    do
	transactional_increment "$$"
    done

    assert_counter 50
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
    assert_counter 50
}

@test "50 concurrent transactional updates to a table keep all updates" {
    for ((i = 0; i < 50; i++))
    do
	transactional_increment "$i" --transaction-timeout 10 &
    done

    wait
    assert_counter 50
}

