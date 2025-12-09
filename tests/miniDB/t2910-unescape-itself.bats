#!/usr/bin/env bats

load fixture
load canned_databases

@test "unescape column query via argument" {
    assert_equal "$(miniDB --unescape "$(miniDB --table multiline-schema --query bar --columns 1 --as-escaped-lines)")" 'A man

walks in\to a'
}

@test "unescape column query via piping" {
    assert_equal "$(miniDB --table multiline-schema --query bar --columns 1 --as-escaped-lines | miniDB --unescape)" 'A man

walks in\to a'
}
