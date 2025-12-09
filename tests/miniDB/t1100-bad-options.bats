#!/usr/bin/env bats

load usage
load canned_databases

@test "multiple actions print usage error" {
    run -2 miniDB --table some-entries --query foo --update "fox	blah	blah"
    assert_multiple_actions_error
    assert_line -n 2 -e '^Usage:'
}

@test "invalid base-type prints usage error" {
    run -2 miniDB --base-type doesNotExist --table whatever --query foo
    assert_line -n 0 'ERROR: Invalid base-type "doesNotExist".'
    assert_line -n 2 -e '^Usage:'
}

@test "invalid table with slash prints usage error" {
    run -2 miniDB --table not/allowed --query foo
    assert_line -n 0 'ERROR: TABLE must not contain slashes.'
    assert_line -n 2 -e '^Usage:'
}
