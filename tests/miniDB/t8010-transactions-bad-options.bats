#!/usr/bin/env bats

load fixture
load usage
load temp_database

assert_tx_error_message()
{
    assert_line -n 0 'ERROR: --transactional cannot be combined with --no-transaction or the --start-read-transaction|--start-write-transaction|--upgrade-to-write-transaction|--within-transaction|--end-transaction|--abort-write-transaction set, and only one from the set can be given.'
}

@test "conflicting (non-)transaction actions print usage error" {
    run -2 miniDB --start-read-transaction T --table some-entries --query foo
    assert_multiple_actions_error
    assert_line -n 2 -e '^Usage:'
}

@test "conflicting (no-)transaction actions print usage error" {
    run -2 miniDB --no-transaction --transactional --table some-entries --query foo --update "fox	blah	blah"
    assert_tx_error_message
    assert_line -n 2 -e '^Usage:'

    run -2 miniDB --start-read-transaction T --no-transaction --table some-entries --query foo --update "fox	blah	blah"
    assert_tx_error_message
    assert_line -n 2 -e '^Usage:'
}

@test "conflicting transaction actions print usage error" {
    run -2 miniDB --transactional --start-read-transaction T --table some-entries --query foo --update "fox	blah	blah"
    assert_tx_error_message
    assert_line -n 2 -e '^Usage:'
}

@test "two start actions from the transaction set print usage error" {
    run -2 miniDB --start-write-transaction T --start-read-transaction T --table some-entries --query foo --update "fox	blah	blah"
    assert_tx_error_message
    assert_line -n 2 -e '^Usage:'
}

@test "start and upgrade actions from the transaction set print usage error" {
    run -2 miniDB --start-read-transaction T --upgrade-to-write-transaction T --table some-entries --query foo --update "fox	blah	blah"
    assert_tx_error_message
    assert_line -n 2 -e '^Usage:'
}

@test "start and within actions from the transaction set print usage error" {
    run -2 miniDB --start-write-transaction T --within-transaction T --table some-entries --query foo --update "fox	blah	blah"
    assert_tx_error_message
    assert_line -n 2 -e '^Usage:'
}

@test "within and end actions from the transaction set print usage error" {
    run -2 miniDB --end-transaction T --within-transaction T --table some-entries --query foo --update "fox	blah	blah"
    assert_tx_error_message
    assert_line -n 2 -e '^Usage:'
}

@test "OWNER-ID starting with * prints usage error" {
    run -2 miniDB --start-read-transaction '*foo' --table some-entries
    assert_line -n 0 'ERROR: OWNER-ID must not start with *.'
    assert_line -n 2 -e '^Usage:'

    run -2 miniDB --start-read-transaction '*' --table some-entries
    assert_line -n 0 'ERROR: OWNER-ID must not start with *.'
    assert_line -n 2 -e '^Usage:'
}

@test "OWNER-ID containing * elsewhere works" {
    miniDB --start-read-transaction 'f**' --table some-entries
}
