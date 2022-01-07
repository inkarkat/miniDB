#!/usr/bin/env bats

load temp_database

@test "update with query of a single column by name without passing a schema" {
    initialize_table "$BATS_TEST_NAME" from multiline-schema

    [ "$(miniDB --table "$BATS_TEST_NAME" --update foo --column COUNT++ --columns ID)" = 'foo' ]
    [ "$(miniDB --table "$BATS_TEST_NAME" --update foo --column COUNT++ --columns DESCRIPTION)" = 'The /Foo\ is here' ]
    [ "$(miniDB --table "$BATS_TEST_NAME" --update foo --column COUNT++ --columns COUNT)" = '44' ]
    [ "$(miniDB --table "$BATS_TEST_NAME" --update foo --column COUNT++ --columns NOTES)" = 'with backslash' ]
}

@test "update with a non-existing column by name results in an error without passing a schema" {
    initialize_table "$BATS_TEST_NAME" from multiline-schema

    run miniDB --table "$BATS_TEST_NAME" --update foo --column 1++ --columns DOESNOTEXIST
    [ $status -eq 2 ]
    [ "$output" = 'ERROR: Unknown column DOESNOTEXIST; not an index nor named in schema ID DESCRIPTION COUNT NOTES.' ]
}

@test "update of a table that uses the default schema cannot be queried by name with it" {
    initialize_table "$BATS_TEST_NAME" from one-entry

    run miniDB --table "$BATS_TEST_NAME" --update foo --column 1++ --columns KEY
    [ $status -eq 2 ]
    [[ "$output" =~ ^'ERROR: Cannot resolve named columns from the table '.*', as no schema is defined there. Use indices or pass a --schema SCHEMA.'$ ]]

    run miniDB --table "$BATS_TEST_NAME" --update foo --column 1++ --columns COLUMN
    [ $status -eq 2 ]
    [[ "$output" =~ ^'ERROR: Cannot resolve named columns from the table '.*', as no schema is defined there. Use indices or pass a --schema SCHEMA.'$ ]]

    run miniDB --table "$BATS_TEST_NAME" --update foo --column 1++ --columns ...
    [ $status -eq 2 ]
    [[ "$output" =~ ^'ERROR: Cannot resolve named columns from the table '.*', as no schema is defined there. Use indices or pass a --schema SCHEMA.'$ ]]
}
