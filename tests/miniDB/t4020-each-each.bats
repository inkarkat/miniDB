#!/usr/bin/env bats

load canned_databases

@test "iterating over a single-entry table multiple times" {
    run miniDB --schema 'KEY TEXT NUMBER' --table one-entry --each 'printf "%s-%s-%s\\n" "$KEY" "$NUMBER" "$TEXT"' --each 'printf "%s (%s)\\n" "$NUMBER" "$KEY"'

    [ $status -eq 0 ]
    [ "${#lines[@]}" -eq 2 ]
    [ "${lines[0]}" = 'foo-42-The Foo is here' ]
    [ "${lines[1]}" = '42 (foo)' ]
}

@test "iterating over a table multiple times" {
    run miniDB --schema 'KEY TEXT NUMBER' --namespace dev --table db --each 'printf "%s-%s-%s\\n" "$KEY" "$NUMBER" "$TEXT"' --each 'printf "%s (%s)\\n" "$NUMBER" "$KEY"'

    [ $status -eq 0 ]
    [ "${#lines[@]}" -eq 6 ]
    [ "${lines[0]}" = 'foo-41-The Foo may have been there' ]
    [ "${lines[1]}" = 'bar-0-A man walks into a' ]
    [ "${lines[2]}" = 'test-123-Testing' ]
    [ "${lines[3]}" = '41 (foo)' ]
    [ "${lines[4]}" = '0 (bar)' ]
    [ "${lines[5]}" = '123 (test)' ]
}
