#!/usr/bin/env bats

load canned_databases

@test "a table that uses the default schema uses counted COL variables" {
    run miniDB --table one-entry --query foo --as-shell-variables

    [ $status -eq 0 ]
    [ "$output" = "COL0=foo
COL1=The\\ Foo\\ is\\ here
COL2=42" ]
}

@test "a table that uses the default schema cannot be queried by name with it" {
    run miniDB --table one-entry --query foo --columns COLUMN --as-shell-variables

    [ $status -eq 2 ]
    [ "$output" = 'ERROR: Cannot resolve named columns from the table one-entry, as no schema is defined there. Use indices or pass a --schema SCHEMA.' ]
}
