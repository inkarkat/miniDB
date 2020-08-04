#!/usr/bin/env bats

load temp_database

@test "run a simple read command on table" {
    initialize_table "$BATS_TEST_NAME" from one-entry

    run miniDB --table "$BATS_TEST_NAME" tail -n 1 {}
    [ $status -eq 0 ]
    [ "$output" = 'foo	The Foo is here	42' ]
}

@test "run a simple write command on table" {
    initialize_table "$BATS_TEST_NAME" from one-entry

    run miniDB --table "$BATS_TEST_NAME" sed -i '2y/o/x/' {}
    [ $status -eq 0 ]
    [ "$output" = "" ]
    assert_table_row "$BATS_TEST_NAME" \$ 'fxx	The Fxx is here	42'
}

@test "run a write command-line on table" {
    initialize_table "$BATS_TEST_NAME" from one-entry

    run miniDB --table "$BATS_TEST_NAME" --command "sed -i '2y/o/x/' {}; tail -n 1 {}"
    [ $status -eq 0 ]
    [ "$output" = 'fxx	The Fxx is here	42' ]
    assert_table_row "$BATS_TEST_NAME" \$ 'fxx	The Fxx is here	42'
}

@test "run a read command-line on table" {
    initialize_table "$BATS_TEST_NAME" from one-entry

    run miniDB --table "$BATS_TEST_NAME" --read-command 'tail -n 1 {}'
    [ $status -eq 0 ]
    [ "$output" = 'foo	The Foo is here	42' ]
}

@test "run two command-lines on table" {
    initialize_table "$BATS_TEST_NAME" from one-entry

    run miniDB --table "$BATS_TEST_NAME" --command "sed -i '2y/o/x/' {}" --command "tail -n 1 {}"
    [ $status -eq 0 ]
    [ "$output" = 'fxx	The Fxx is here	42' ]
    assert_table_row "$BATS_TEST_NAME" \$ 'fxx	The Fxx is here	42'
}

@test "run combined simple command and command-line on table" {
    initialize_table "$BATS_TEST_NAME" from one-entry

    run miniDB --table "$BATS_TEST_NAME" --command "sed -i '2y/o/x/' {}" tail -n 1 {}
    [ $status -eq 0 ]
    [ "$output" = 'fxx	The Fxx is here	42' ]
    assert_table_row "$BATS_TEST_NAME" \$ 'fxx	The Fxx is here	42'
}

@test "command-line failure is returned" {
    initialize_table "$BATS_TEST_NAME" from one-entry

    run miniDB --table "$BATS_TEST_NAME" --command "(exit 42)"
    [ $status -eq 42 ]
    [ "$output" = '' ]
}

@test "run a write command-line on table with a reconfigured marker, leaving any {} intact" {
    initialize_table "$BATS_TEST_NAME" from one-entry

    export MINIDB_FILE_MARKER=@@
    run miniDB --table "$BATS_TEST_NAME" --command "sed -i '2y/fo/{}/' @@; tail -n 1 @@"
    [ $status -eq 0 ]
    [ "$output" = '{}}	The F}} is here	42' ]
    assert_table_row "$BATS_TEST_NAME" \$ '{}}	The F}} is here	42'
}

@test "run a combined write command-line and simple command on table with a reconfigured marker, leaving any {} intact" {
    initialize_table "$BATS_TEST_NAME" from one-entry

    export MINIDB_FILE_MARKER=@@
    run miniDB --table "$BATS_TEST_NAME" --command "sed -i '2y/fo/{}/' @@" -- tail -n 1 @@
    [ $status -eq 0 ]
    [ "$output" = '{}}	The F}} is here	42' ]
    assert_table_row "$BATS_TEST_NAME" \$ '{}}	The F}} is here	42'
}
