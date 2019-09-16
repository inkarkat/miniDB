#!/usr/bin/env bats

load temp_database

setup()
{
    TX=Trans1
}

@test "aborting a read transaction causes error" {
    initialize_table "$BATS_TEST_NAME" from one-entry
    miniDB --start-read-transaction "$TX" --table "$BATS_TEST_NAME"
    miniDB --within-transaction "$TX" --table "$BATS_TEST_NAME" --query foo
    run miniDB --abort-write-transaction "$TX" --table "$BATS_TEST_NAME"
    [ $status -eq 2 ]
    [ "$output" = "ERROR: Not in a write transaction." ]
}
