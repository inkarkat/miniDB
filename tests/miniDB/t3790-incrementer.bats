#!/usr/bin/env bats

load temp_database

@test "increment sole column from zero to 20" {
    initialize_table "$BATS_TEST_NAME" from one-entry

    for ((i = 1; i <= 20; i++))
    do
	miniDB --table "$BATS_TEST_NAME" --update 'sequences' --column 1++
	assert_table_row "$BATS_TEST_NAME" 3 "sequences	$i" \
	    || { printf 'Increment to %d failed' "$i"; dump_table "$BATS_TEST_NAME"; return 1; }
    done
}
