#!/usr/bin/env bats

load fixture
load temp_database

@test "update action with no table prints message and usage instructions" {
    run -2 miniDB --update "quux	This has been added	100"
    assert_line -n 0 'ERROR: No TABLE passed.'
    assert_line -n 2 -e '^Usage:'
}

@test "update of a non-existing table initializes it with the passed key and value" {
    [ ! -w /etc ] || skip "Need non-writable /etc directory"

    LC_ALL=C run -1 miniDB --basedir /etc --table testtable --update "key	value"
    assert_output -e "/etc/testtable: Permission denied"$
}

@test "update of a table with an empty key is rejected" {
    initialize_table "$BATS_TEST_NAME" from one-entry

    run -2 miniDB --table "$BATS_TEST_NAME" --update "	The key is empty	0"
    assert_line -n 0 'ERROR: KEY must not be empty.'
}
