#!/usr/bin/env bats

load canned_databases

@test "multiple actions print usage error" {
    run miniDB --table some-entries --query foo --update "fox	blah	blah"
    [ $status -eq 2 ]
    [ "${lines[0]}" = 'ERROR: Only one of --update, --query allowed.' ]
    [ "${lines[2]%% *}" = 'Usage:' ]
}

@test "invalid base-type prints usage error" {
    run miniDB --base-type doesNotExist --table whatever --query foo
    [ $status -eq 2 ]
    [ "${lines[0]}" = 'ERROR: Invalid base-type "doesNotExist".' ]
    [ "${lines[2]%% *}" = 'Usage:' ]
}

@test "invalid table with slash prints usage error" {
    run miniDB --table not/allowed --query foo
    [ $status -eq 2 ]
    [ "${lines[0]}" = 'ERROR: TABLE must not contain slashes.' ]
    [ "${lines[2]%% *}" = 'Usage:' ]
}
