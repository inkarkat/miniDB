#!/usr/bin/env bats

load usage
load canned_databases

@test "no arguments prints message and usage instructions" {
    run -2 miniDB
    assert_line -n 0 "ERROR: No action passed: $ACTIONS"
    assert_line -n 2 -e '^Usage:'
}

@test "invalid option prints message and usage instructions" {
    run -2 miniDB --invalid-option
    assert_line -n 0 'ERROR: Unknown option "--invalid-option"!'
    assert_line -n 2 -e '^Usage:'
}

@test "-h prints long usage help" {
    run -0 miniDB -h
    refute_line -n 0 -e '^Usage:'
}

@test "additional arguments print short help" {
    run -2 miniDB --table some-entries --query foo whatIsMore
    assert_multiple_actions_error
    assert_line -n 2 -e '^Usage:'
}

@test "no action prints message and usage instructions" {
    run -2 miniDB --table some-entries
    assert_line -n 0 "ERROR: No action passed: $ACTIONS"
    assert_line -n 2 -e '^Usage:'
}
