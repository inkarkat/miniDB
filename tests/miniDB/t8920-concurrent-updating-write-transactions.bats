#!/usr/bin/env bats

load temp_database
load concurrent

transactional_increment()
{
    owner="${1:?}"; shift
    miniDB "$@" --start-read-transaction "$owner" --table "$BATS_TEST_NAME"
    counter="$(miniDB "$@" --within-transaction "$owner" --table "$BATS_TEST_NAME" --query counter --columns 1)"
    if ! miniDB "$@" --silence-transaction-errors --upgrade-to-write-transaction "$owner" --table "$BATS_TEST_NAME"; then
	miniDB "$@" --silence-transaction-errors --end-transaction "$owner" --table "$BATS_TEST_NAME"
	if miniDB "$@" --start-write-transaction "$owner" --table "$BATS_TEST_NAME"; then
	    counter="$(miniDB "$@" --within-transaction "$owner" --table "$BATS_TEST_NAME" --query counter --columns 1)"
	else
	    return
	fi
    fi

    let counter+=1
    miniDB "$@" --within-transaction "$owner" --table "$BATS_TEST_NAME" --update "counter	$counter"
    miniDB "$@" --end-transaction "$owner" --table "$BATS_TEST_NAME"
}



@test "$SEQUENTIAL_NUMBER sequential transactional upgrading read-write updates to a table keep all updates" {
    for ((i = 0; i < $SEQUENTIAL_NUMBER; i++))
    do
	transactional_increment "$$"
    done

    assert_counter -eq $SEQUENTIAL_NUMBER
}

@test "$MIXED_NUMBER concurrent transactional upgrading read-write updates to a table keep all updates" {
    for ((i = 0; i < $MIXED_NUMBER; i++))
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
    assert_counter -eq $((MIXED_NUMBER * 5))
}

@test "$CONCURRENT_NUMBER concurrent transactional upgrading read-write updates to a table keep all updates" {
    for ((i = 0; i < $CONCURRENT_NUMBER; i++))
    do
	transactional_increment "$i" --transaction-timeout 10 &
    done

    wait
    assert_counter -eq $CONCURRENT_NUMBER
}
