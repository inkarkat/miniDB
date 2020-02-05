#!/usr/bin/env bats

load usage
load temp_database

@test "command action with no table prints message and usage instructions" {
    run miniDB --command 'true'
    [ $status -eq 2 ]

    [ "${lines[0]}" = 'ERROR: No TABLE passed.' ]
    [ "${lines[2]%% *}" = 'Usage:' ]
}

@test "conflicting (non-)command actions print usage error" {
    run miniDB --table some-entries --truncate --command 'true'
    [ $status -eq 2 ]
    assert_multiple_actions_error
    [ "${lines[2]%% *}" = 'Usage:' ]
}

@test "conflicting non-command action and simple command print usage error" {
    run miniDB --table some-entries --query foo 'true'
    [ $status -eq 2 ]
    assert_multiple_actions_error
    [ "${lines[2]%% *}" = 'Usage:' ]
}
