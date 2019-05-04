#!/usr/bin/env bats

load canned_databases

@test "a query key that contains a tab character is rejected" {
    run miniDB --table one-entry --query "with	tab"
    [ $status -eq 2 ]
    [ "${lines[0]}" = 'ERROR: KEY cannot contain tab characters.' ]
}
