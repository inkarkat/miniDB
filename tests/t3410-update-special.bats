#!/usr/bin/env bats

load temp_database

@test "add with columns that start and end with space" {
    initialize_table "$BATS_TEST_NAME" from one-entry
    update=' key 	 one value 	 two value '
    miniDB --table "$BATS_TEST_NAME" --update "$update"

    result="$(miniDB --table "$BATS_TEST_NAME" --query ' key ')"

    [ "$result" = "$update" ]
}

@test "update with columns that start and end with space" {
    initialize_table "$BATS_TEST_NAME" from one-entry
    update1=' key 	 one value 	 two value '
    update2=' key 	 changed value 	 changed value '
    miniDB --table "$BATS_TEST_NAME" --update "$update1"
    miniDB --table "$BATS_TEST_NAME" --update "$update2"
    result="$(miniDB --table "$BATS_TEST_NAME" --query ' key ')"

    [ "$result" = "$update2" ]
}
