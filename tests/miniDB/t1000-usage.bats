#!/usr/bin/env bats

load usage
load canned_databases

@test "no arguments prints message and usage instructions" {
    run miniDB
    [ $status -eq 2 ]
    [ "${lines[0]}" = "ERROR: No action passed: $ACTIONS" ]
    [ "${lines[2]%% *}" = 'Usage:' ]
}

@test "invalid option prints message and usage instructions" {
    run miniDB --invalid-option
    [ $status -eq 2 ]
    [ "${lines[0]}" = 'ERROR: Unknown option "--invalid-option"!' ]
    [ "${lines[2]%% *}" = 'Usage:' ]
}

@test "-h prints long usage help" {
    run miniDB -h
    [ $status -eq 0 ]
    [ "${lines[0]%% *}" != 'Usage:' ]
}

@test "additional arguments print short help" {
    run miniDB --table some-entries --query foo whatIsMore
    [ $status -eq 2 ]
    assert_multiple_actions_error
    [ "${lines[2]%% *}" = 'Usage:' ]
}

@test "no action prints message and usage instructions" {
    run miniDB --table some-entries
    [ $status -eq 2 ]
    [ "${lines[0]}" = "ERROR: No action passed: $ACTIONS" ]
    [ "${lines[2]%% *}" = 'Usage:' ]
}
