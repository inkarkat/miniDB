#!/usr/bin/env bats

load fixture
load temp_database

@test "untransactional access after transactional one causes error" {
    clean_table tx
    clear_lock tx

    miniDB --transactional --table tx --update "data	random"
    miniDB --transactional --table tx --query "data"

    run -2 miniDB --table tx --query "data"
    assert_output 'This table must be accessed in a transactional manner, using either --transactional or the --start-read-transaction|--start-write-transaction|--upgrade-to-write-transaction|--within-transaction|--end-transaction|--abort-write-transaction set.'
}

@test "explicit no-transaction access after transactional one works" {
    clean_table tx
    clear_lock tx

    miniDB --transactional --table tx --update "data	random"
    miniDB --transactional --table tx --query "data"

    run -0 miniDB --no-transaction --table tx --query "data"
    assert_output 'data	random'
}
