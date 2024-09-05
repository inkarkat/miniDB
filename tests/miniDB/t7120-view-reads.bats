#!/usr/bin/env bats

load temp_view

@test "the view initially contains the same contents as the table" {
    run miniDB --table "$BATS_TEST_NAME" --view "$viewName" --read-command 'cat {}'
    [ $status -eq 0 ]
    [ "$output" = "$(cat "${XDG_DATA_HOME}/${BATS_TEST_NAME}")" ]
}

@test "the view is unaffected by changes to the table" {
    miniDB --table "$BATS_TEST_NAME" --update 'foo	changed	99'
    miniDB --table "$BATS_TEST_NAME" --delete bar
    miniDB --table "$BATS_TEST_NAME" --update 'new	New entry   11'

    run miniDB --table "$BATS_TEST_NAME" --view "$viewName" --query foo
    [ $status -eq 0 ]
    [ "$output" = 'foo	The Foo is here	42' ]

    run miniDB --table "$BATS_TEST_NAME" --view "$viewName" --query bar
    [ $status -eq 0 ]
    [ "$output" = 'bar	A man walks into a	21' ]

    run miniDB --table "$BATS_TEST_NAME" --view "$viewName" --query new
    [ $status -eq 4 ]
    [ "$output" = '' ]
}

@test "the view is unaffected by dropping the table" {
    miniDB --table "$BATS_TEST_NAME" --drop

    run miniDB --table "$BATS_TEST_NAME" --view "$viewName" --query foo
    [ $status -eq 0 ]
    [ "$output" = 'foo	The Foo is here	42' ]
}
