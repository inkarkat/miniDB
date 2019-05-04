#!/usr/bin/env bats

load canned_databases

@test "existing single key can be queried" {
    run miniDB --table one-entry --query foo
    [ $status -eq 0 ]
    [ "${#lines[@]}" -eq 1 ]
    [ "${lines[0]}" = 'foo	The Foo is here	42' ]
}

@test "non-existing key query fails" {
    run miniDB --table one-entry --query notInHere
    [ $status -eq 4 ]
    [ "${#lines[@]}" -eq 0 ]
}

@test "key can be queried among many" {
    run miniDB --table some-entries --query foobar
    [ $status -eq 0 ]
    [ "${#lines[@]}" -eq 1 ]
    [ "${lines[0]}" = 'foobar	The original one	1' ]
}

@test "key query is case-sensitive" {
    run miniDB --table some-entries --query Foo
    [ $status -eq 0 ]
    [ "${#lines[@]}" -eq 1 ]
    [ "${lines[0]}" = 'Foo	The upper-case variant	82' ]
}

@test "need a full key match" {
    run miniDB --table some-entries --query oo
    [ $status -eq 4 ]
    [ "${#lines[@]}" -eq 0 ]
}

@test "key with space in it can be queried" {
    run miniDB --table some-entries --query 'o O'
    [ $status -eq 0 ]
    [ "${#lines[@]}" -eq 1 ]
    [ "${lines[0]}" = 'o O	A key with space in it	88' ]
}

@test "cannot query header line" {
    run miniDB --table some-entries --query '# KEY'
    [ $status -eq 4 ]
    [ "${#lines[@]}" -eq 0 ]
}

