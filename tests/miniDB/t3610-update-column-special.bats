#!/usr/bin/env bats

load temp_database

@test "update of an existing key and numeric columns that start and end with space" {
    initialize_table "$BATS_TEST_NAME" from one-entry
    update1=' with space'
    update2='99  '
    miniDB --table "$BATS_TEST_NAME" --update 'foo' --column "1=$update1" --column "4=$update2"
    result="$(miniDB --table "$BATS_TEST_NAME" --query 'foo' --columns \*)"

    [ "$result" = "$update1	42		$update2" ]
}

@test "update of a new key and numeric columns that start and end with space" {
    initialize_table "$BATS_TEST_NAME" from one-entry
    update1=' with space'
    update2='99  '
    miniDB --table "$BATS_TEST_NAME" --update 'new' --column "1=$update1" --column "4=$update2"
    result="$(miniDB --table "$BATS_TEST_NAME" --query 'new' --columns \*)"

    [ "$result" = "$update1			$update2" ]
}
