#!/usr/bin/env bats

load canned_databases

@test "normal fallback key is used when key does not exist" {
    run miniDB --table some-entries --query notInHere --fallback foxbar
    [ $status -eq 0 ]
    [ "${#lines[@]}" -eq 1 ]
    [ "${lines[0]}" = 'foxbar	A variant	2' ]
}

@test "generic fallback key is used when key does not exist" {
    run miniDB --table some-entries --query notInHere --fallback '*'
    [ $status -eq 0 ]
    [ "${#lines[@]}" -eq 1 ]
    [ "${lines[0]}" = '*	Looks like a placeholder to me	0' ]
}

@test "non-existing key and non-existing fallback key query fails" {
    run miniDB --table some-entries --query notInHere --fallback alsoNotHere
    [ $status -eq 4 ]
    [ "${#lines[@]}" -eq 0 ]
}

@test "cannot query header line with fallback key" {
    run miniDB --table some-entries --query notInHere --fallback '# KEY'
    [ $status -eq 4 ]
    [ "${#lines[@]}" -eq 0 ]
}

