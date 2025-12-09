#!/usr/bin/env bats

load fixture
load view_cleanup

@test "untransactional view creation after transactional update causes error" {
    viewName=willNotBeCreated
    clean_table tx
    clear_lock tx

    miniDB --transactional --table tx --update "data	random"

    run -2 miniDB --table tx --create-view
    assert_output 'This table must be accessed in a transactional manner, using either --transactional or the --start-read-transaction|--start-write-transaction|--upgrade-to-write-transaction|--within-transaction|--end-transaction|--abort-write-transaction set.'
}

@test "explicit no-transaction view creation after transactional update works" {
    clean_table tx
    clear_lock tx

    miniDB --transactional --table tx --update "data	random"

    viewName=$(miniDB --no-transaction --table tx --create-view)
    assert [ -n "$viewName" ]
}
