#!/usr/bin/env bats

load canned_databases

@test "unescape column query via argument" {
    [ "$(miniDB --unescape "$(miniDB --table multiline-schema --query bar --columns 1 --as-escaped-lines)")" = 'A man

walks in\to a' ]
}

@test "unescape column query via piping" {
    [ "$(miniDB --table multiline-schema --query bar --columns 1 --as-escaped-lines | miniDB --unescape)" = 'A man

walks in\to a' ]
}
