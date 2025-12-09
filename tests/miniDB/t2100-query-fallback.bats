#!/usr/bin/env bats

load fixture
load canned_databases

@test "normal fallback key is used when key does not exist" {
    run -0 miniDB --table some-entries --query notInHere --fallback foxbar
    assert_equal ${#lines[@]} 1
    assert_line -n 0 'foxbar	A variant	2'
}

@test "generic fallback key is used when key does not exist" {
    run -0 miniDB --table some-entries --query notInHere --fallback '*'
    assert_equal ${#lines[@]} 1
    assert_line -n 0 '*	Looks like a placeholder to me	0'
}

@test "non-existing key and non-existing fallback key query fails" {
    run -4 miniDB --table some-entries --query notInHere --fallback alsoNotHere
    assert_equal ${#lines[@]} 0
}

@test "cannot query header line with fallback key" {
    run -4 miniDB --table some-entries --query notInHere --fallback '# KEY'
    assert_equal ${#lines[@]} 0
}
