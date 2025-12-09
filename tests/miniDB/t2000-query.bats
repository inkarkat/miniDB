#!/usr/bin/env bats

load fixture
load canned_databases

@test "existing single key can be queried" {
    run -0 miniDB --table one-entry --query foo
    assert_equal ${#lines[@]} 1
    assert_line -n 0 'foo	The Foo is here	42'
}

@test "non-existing key query fails" {
    run -4 miniDB --table one-entry --query notInHere
    assert_equal ${#lines[@]} 0
}

@test "key can be queried among many" {
    run -0 miniDB --table some-entries --query foobar
    assert_equal ${#lines[@]} 1
    assert_line -n 0 'foobar	The original one	1'
}

@test "key query is case-sensitive" {
    run -0 miniDB --table some-entries --query Foo
    assert_equal ${#lines[@]} 1
    assert_line -n 0 'Foo	The upper-case variant	82'
}

@test "need a full key match" {
    run -4 miniDB --table some-entries --query oo
    assert_equal ${#lines[@]} 0
}

@test "key with space in it can be queried" {
    run -0 miniDB --table some-entries --query 'o O'
    assert_equal ${#lines[@]} 1
    assert_line -n 0 'o O	A key with space in it	88'
}

@test "cannot query header line" {
    run -4 miniDB --table some-entries --query '# KEY'
    assert_equal ${#lines[@]} 0
}

