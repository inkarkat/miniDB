#!/usr/bin/env bats

load fixture
load temp_database

@test "update with query of a single column by name without passing a schema" {
    initialize_table "$BATS_TEST_NAME" from multiline-schema

    assert_equal "$(miniDB --table "$BATS_TEST_NAME" --update foo --column COUNT++ --columns ID)" 'foo'
    assert_equal "$(miniDB --table "$BATS_TEST_NAME" --update foo --column COUNT++ --columns DESCRIPTION)" 'The /Foo\ is here'
    assert_equal "$(miniDB --table "$BATS_TEST_NAME" --update foo --column COUNT++ --columns COUNT)" '44'
    assert_equal "$(miniDB --table "$BATS_TEST_NAME" --update foo --column COUNT++ --columns NOTES)" 'with backslash'
}

@test "update with a non-existing column by name results in an error without passing a schema" {
    initialize_table "$BATS_TEST_NAME" from multiline-schema

    run -2 miniDB --table "$BATS_TEST_NAME" --update foo --column 1++ --columns DOESNOTEXIST
    assert_output 'ERROR: Unknown column DOESNOTEXIST; not an index nor named in schema ID DESCRIPTION COUNT NOTES.'
}

@test "update of a table that uses the default schema cannot be queried by name with it" {
    initialize_table "$BATS_TEST_NAME" from one-entry

    run -2 miniDB --table "$BATS_TEST_NAME" --update foo --column 1++ --columns KEY
    assert_output -e ^'ERROR: Cannot resolve named columns from the table '.*', as no schema is defined there. Use indices or pass a --schema SCHEMA.'$

    run -2 miniDB --table "$BATS_TEST_NAME" --update foo --column 1++ --columns COLUMN
    assert_output -e ^'ERROR: Cannot resolve named columns from the table '.*', as no schema is defined there. Use indices or pass a --schema SCHEMA.'$

    run -2 miniDB --table "$BATS_TEST_NAME" --update foo --column 1++ --columns ...
    assert_output -e ^'ERROR: Cannot resolve named columns from the table '.*', as no schema is defined there. Use indices or pass a --schema SCHEMA.'$
}
