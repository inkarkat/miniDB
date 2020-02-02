#!/usr/bin/env bats

load canned_databases

@test "existing single key can be queried" {
    run miniDB --table one-entry --query-keys
    [ $status -eq 0 ]
    [ "$output" = 'foo' ]
}

@test "existing keys can be queried" {
    run miniDB --table some-entries --query-keys
    [ $status -eq 0 ]
    [ "$output" = $'foo\nFoo\nbar\nfoobar\nfoxbar\no O\n*\nbaz' ]
}

@test "no output with empty (just schema) table" {
    run miniDB --table empty --query-keys
    [ $status -eq 0 ]
    [ "$output" = '' ]
}

@test "a query on a non-existing database table fails" {
    run miniDB --table doesNotExist --query-keys
    [ $status -eq 1 ]
    [ "$output" = "" ]
}
