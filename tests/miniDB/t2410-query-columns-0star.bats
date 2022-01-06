#!/usr/bin/env bats

load canned_databases

@test "existing key can be queried with 0*" {
    run miniDB --table multiline-schema --query foo --columns 0\*
    [ $status -eq 0 ]
    [ "$output" = 'foo	The /Foo\ is here	42	with backslash' ]
}

@test "existing multiline record can be queried with 0*" {
    run miniDB --table multiline-schema --query bar --columns 0\*
    [ $status -eq 0 ]
    [ "$output" = 'bar	A man

walks in\to a	21	with one
newline and \ backslash' ]
}

@test "existing key with space can be queried with 0*" {
    run miniDB --table multiline-schema --query 'o O' --columns 0\*
    [ $status -eq 0 ]
    [ "$output" = 'o O	An ID with space in it' ]
}

@test "existing key without columns can be queried" {
    run miniDB --table multiline-schema --query empty --columns 0\*
    [ $status -eq 0 ]
    [ "$output" = 'empty	' ]
}
