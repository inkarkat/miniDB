#!/usr/bin/env bats

load fixture
load canned_databases

@test "iterating over a single-entry table multiple times" {
    run -0 miniDB --schema 'KEY TEXT NUMBER' --table one-entry --each 'printf "%s-%s-%s\\n" "$KEY" "$NUMBER" "$TEXT"' --each 'printf "%s (%s)\\n" "$NUMBER" "$KEY"'
    assert_equal ${#lines[@]} 2
    assert_line -n 0 'foo-42-The Foo is here'
    assert_line -n 1 '42 (foo)'
}

@test "iterating over a table multiple times" {
    run -0 miniDB --schema 'KEY TEXT NUMBER' --namespace dev --table db --each 'printf "%s-%s-%s\\n" "$KEY" "$NUMBER" "$TEXT"' --each 'printf "%s (%s)\\n" "$NUMBER" "$KEY"'
    assert_equal ${#lines[@]} 6
    assert_line -n 0 'foo-41-The Foo may have been there'
    assert_line -n 1 'bar-0-A man walks into a'
    assert_line -n 2 'test-123-Testing'
    assert_line -n 3 '41 (foo)'
    assert_line -n 4 '0 (bar)'
    assert_line -n 5 '123 (test)'
}
