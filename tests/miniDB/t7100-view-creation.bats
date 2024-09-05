#!/usr/bin/env bats

load temp_database

@test "create a view of a table and remove it again" {
    initialize_table "$BATS_TEST_NAME" from one-entry

    viewName="$(miniDB --table "$BATS_TEST_NAME" --create-view)"
    [ -n "$viewName" ]
    miniDB --table "$BATS_TEST_NAME" --drop --view "$viewName"
}

@test "dropping a non-existing view returns 1" {
    run miniDB --table "$BATS_TEST_NAME" --view doesNotExist --drop
    [ $status -eq 1 ]
    [ "$output" = "" ]
}

@test "querying a non-existing view returns 1" {
    run miniDB --table "$BATS_TEST_NAME" --view doesNotExist --query foo
    [ $status -eq 1 ]
    [ "$output" = "" ]
}

@test "the view initially contains the same contents as the table" {
    initialize_table "$BATS_TEST_NAME" from some-entries

    viewName="$(miniDB --table "$BATS_TEST_NAME" --create-view)"
    run miniDB --table "$BATS_TEST_NAME" --view "$viewName" --read-command 'cat {}'
    [ $status -eq 0 ]
    [ "$output" = "$(cat "${XDG_DATA_HOME}/${BATS_TEST_NAME}")" ]
    miniDB --table "$BATS_TEST_NAME" --drop --view "$viewName"
}
