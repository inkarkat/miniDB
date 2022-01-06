#!/usr/bin/env bats

load temp_database

@test "increment an existing number in numeric column" {
    initialize_table "$BATS_TEST_NAME" from some-entries

    miniDB --table "$BATS_TEST_NAME" --update 'foo' --column "2++"
    assert_table_row "$BATS_TEST_NAME" 2 "foo	The Foo is here	43"
}
