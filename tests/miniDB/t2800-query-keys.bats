#!/usr/bin/env bats

load fixture
load canned_databases

@test "existing single key can be queried" {
    run -0 miniDB --table one-entry --query-keys
    assert_output 'foo'
}

@test "existing keys can be queried" {
    run -0 miniDB --table some-entries --query-keys
    assert_output $'foo\nFoo\nbar\nfoobar\nfoxbar\no O\n*\nbaz'
}

@test "no output with empty (just schema) table" {
    run -0 miniDB --table empty --query-keys
    assert_output ''
}

@test "a query on a non-existing database table fails" {
    run -1 miniDB --table doesNotExist --query-keys
    assert_output ''
}
