#!/usr/bin/env bats

load canned_databases

@test "attempting to open database without corresponding namespace fails" {
    run miniDB --table db --query foo
    [ $status -eq 1 ]
}

@test "key from database in namespace can be queried" {
    run miniDB --namespace dev --table db --query foo
    [ $status -eq 0 ]
    [ "${#lines[@]}" -eq 1 ]
    [ "${lines[0]}" = 'foo	The Foo may have been there	41' ]
}

@test "key from database in another namespace can be queried" {
    run miniDB --namespace prod --table db --query foo
    [ $status -eq 0 ]
    [ "${#lines[@]}" -eq 1 ]
    [ "${lines[0]}" = 'foo	The Foo has been here	42' ]
}

