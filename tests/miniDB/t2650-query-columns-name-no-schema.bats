#!/usr/bin/env bats

load canned_databases

@test "existing key can be queried specifying a single column by name without passing a schema" {
    [ "$(miniDB --table multiline-schema --query foo --columns ID)" = 'foo' ]
    [ "$(miniDB --table multiline-schema --query foo --columns DESCRIPTION)" = 'The /Foo\ is here' ]
    [ "$(miniDB --table multiline-schema --query foo --columns COUNT)" = '42' ]
    [ "$(miniDB --table multiline-schema --query foo --columns NOTES)" = 'with backslash' ]
}

@test "specifying a non-existing column by name results in an error without passing a schema" {
    run miniDB --table multiline-schema --query foo --columns DOESNOTEXIST
    [ $status -eq 2 ]
    [ "$output" = 'ERROR: Unknown column DOESNOTEXIST; not an index nor named in schema ID DESCRIPTION COUNT NOTES.' ]
}

@test "a table that uses the default schema cannot be queried by name with it" {
    run miniDB --table one-entry --query foo --columns KEY
    [ $status -eq 2 ]
    [ "$output" = 'ERROR: Cannot resolve named columns from the table one-entry, as no schema is defined there. Use indices or pass a --schema SCHEMA.' ]

    run miniDB --table one-entry --query foo --columns COLUMN
    [ $status -eq 2 ]
    [ "$output" = 'ERROR: Cannot resolve named columns from the table one-entry, as no schema is defined there. Use indices or pass a --schema SCHEMA.' ]

    run miniDB --table one-entry --query foo --columns ...
    [ $status -eq 2 ]
    [ "$output" = 'ERROR: Cannot resolve named columns from the table one-entry, as no schema is defined there. Use indices or pass a --schema SCHEMA.' ]
}

@test "a table in a namespace that uses the default schema cannot be queried by name with it" {
    run miniDB --namespace dev --table db --query foo --columns KEY
    [ $status -eq 2 ]
    [ "$output" = 'ERROR: Cannot resolve named columns from the table dev/db, as no schema is defined there. Use indices or pass a --schema SCHEMA.' ]
}
