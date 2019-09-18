#!/usr/bin/env bats

load temp_database

@test "untransactional access after transactional one causes error" {
    clean_table tx
    clear_lock tx

    miniDB --transactional --table tx --update "data	random"
    miniDB --transactional --table tx --query "data"

    run miniDB --table tx --query "data"
    [ $status -eq 2 ]
    [ "$output" = "This table must be accessed in a transactional manner, using either --transactional or the --start-read-transaction|--start-write-transaction|--upgrade-to-write-transaction|--within-transaction|--end-transaction|--abort-write-transaction set." ]
}
