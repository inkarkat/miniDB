#!/usr/bin/env bats

load temp_database

setup()
{
    initialize_table "$BATS_TEST_NAME" from one-entry
    clear_lock "$BATS_TEST_NAME"
    miniDB --table "$BATS_TEST_NAME" --update "counter	0"
}

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

@test "50 sequential transactional upgrading read-write updates to a table keep all updates" {
return
    for ((i = 0; i < 50; i++))
    do
	transactional_increment "$$"
    done

    [ "$(miniDB --transactional --table "$BATS_TEST_NAME" --query counter --columns 1)" -eq 50 ]
}

@test "10 concurrent transactional upgrading read-write updates to a table keep all updates" {
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
    [ "$(miniDB --transactional --table "$BATS_TEST_NAME" --query counter --columns 1)" -eq 50 ]
}

@test "50 concurrent transactional upgrading read-write updates to a table keep all updates" {
    for ((i = 0; i < 50; i++))
    do
	transactional_increment "$i" &
    done

    wait
    [ "$(miniDB --transactional --table "$BATS_TEST_NAME" --query counter --columns 1)" -eq 50 ]
}

