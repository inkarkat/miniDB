#!/usr/bin/env bats

load canned_databases

@test "iteration a non-existing database fails" {
    run miniDB --table doesNotExist --each echo
    [ $status -eq 1 ]
    [ "$output" = "" ]
}
