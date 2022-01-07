#!/usr/bin/env bats

load canned_databases

@test "a query of updated columns gives an error" {
    run miniDB --table one-entry --query foo --columns \#
    [ $status -eq 2 ]
    [ "$output" = 'ERROR: Updated columns can only be queried in combination with --update.' ]
}
