#!/usr/bin/env bats

load fixture
load usage
load temp_database

@test "command action with no table prints message and usage instructions" {
    run -2 miniDB --command 'true'

    assert_line -n 0 'ERROR: No TABLE passed.'
    assert_line -n 2 -e '^Usage:'
}

@test "conflicting (non-)command actions print usage error" {
    run -2 miniDB --table some-entries --truncate --command 'true'
    assert_multiple_actions_error
    assert_line -n 2 -e '^Usage:'
}

@test "conflicting non-command action and simple command print usage error" {
    run -2 miniDB --table some-entries --query foo 'true'
    assert_multiple_actions_error
    assert_line -n 2 -e '^Usage:'
}
