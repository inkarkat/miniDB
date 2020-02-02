#!/usr/bin/env bats

load canned_databases

@test "existing key can be queried omitting the key" {
    run miniDB --table multiline-schema --query foo --columns \*
    [ $status -eq 0 ]
    [ "$output" = 'The /Foo\ is here	42	with backslash' ]
}

@test "existing multiline key can be queried omitting the key" {
    run miniDB --table multiline-schema --query bar --columns \*
    [ $status -eq 0 ]
    [ "$output" = 'A man

walks in\to a	21	with one
newline and \ backslash' ]
}

@test "existing key with space can be queried omitting the key" {
    run miniDB --table multiline-schema --query 'o O' --columns \*
    [ $status -eq 0 ]
    [ "$output" = 'An ID with space in it' ]
}

@test "existing key without columns can be queried" {
    run miniDB --table multiline-schema --query empty --columns \*
    [ $status -eq 0 ]
    [ "$output" = '' ]
}
