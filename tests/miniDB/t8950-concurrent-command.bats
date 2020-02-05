#!/usr/bin/env bats

load temp_database
load concurrent

increment()
{
    miniDB "$@" --table "$BATS_TEST_NAME" pipethrough1 awk -F '\t' 'BEGIN { OFS = "\t" } $1 == "counter" { update = $2 += 1 } { print } END { if (! update) print "counter\t0" }' {}
}



@test "50 concurrent transactional updates to a table keep all updates" {
    for ((i = 0; i < 50; i++))
    do
	increment --transactional --transaction-timeout 10 &
    done

    wait
    assert_counter -eq 50
}

@test "50 concurrent non-transactional updates to a table lose some updates" {
    for ((i = 0; i < 50; i++))
    do
	increment --no-transaction &
    done

    wait
    assert_counter -lt 50
}
