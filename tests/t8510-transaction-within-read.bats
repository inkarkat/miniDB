#!/usr/bin/env bats

load temp_database

setup()
{
    initialize_table "$BATS_TEST_NAME" from one-entry
    clear_lock "$BATS_TEST_NAME"
    export NOW=1568635000
}

@test "when inside a current read transaction, writes cause an error" {
    miniDB --start-read-transaction Trans1 --table "$BATS_TEST_NAME"
    let NOW+=1
    run miniDB --within-transaction Trans1 --table "$BATS_TEST_NAME" --update "foo	A Foo has been updated	43"
    [ $status -eq 2 ]
    [ "$output" = "ERROR: Not in a write transaction." ]
}
