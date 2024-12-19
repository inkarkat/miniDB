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

@test "increment middle column from zero to 20" {
    initialize_table "$BATS_TEST_NAME" from one-entry

    before=90
    after=1
    for ((i = 1; i <= 20; i++))
    do
	miniDB --table "$BATS_TEST_NAME" --update 'sequences' --column 1=$before --column 2++ --column 3=$after
	assert_table_row "$BATS_TEST_NAME" 3 "sequences	$before	$i	$after" \
	    || { printf 'Increment to %d failed' "$i"; dump_table "$BATS_TEST_NAME"; return 1; }
    done
}

@test "staggered increment of two columns from zero to 100 / 10" {
    initialize_table "$BATS_TEST_NAME" from one-entry

    typeset -a multiUpdates=(--column 2++)
    for ((i = 1, j = 1; i <= 100; i++))
    do
	((i % 10)) || { let j+=1; multiUpdates+=(--column 2++); }
	miniDB --table "$BATS_TEST_NAME" --update 'sequences' --column 1++ "${multiUpdates[@]}"
	assert_table_row "$BATS_TEST_NAME" 3 "sequences	$i	$j" \
	    || { printf 'Increment%s to %d %d failed' "${multiUpdates:+ }${multiUpdates[*]}" $i $j; dump_table "$BATS_TEST_NAME"; return 1; }
	multiUpdates=()
    done
}

@test "staggered increment of three columns from zero to 200 / 10 / 20" {
    initialize_table "$BATS_TEST_NAME" from one-entry

    typeset -a multiUpdates=(--column 2++ --column 3++)
    for ((i = 1, j = 1, k = 1; i <= 200; i++))
    do
	((i % 20)) || { let j+=1; multiUpdates+=(--column 2++); }
	((i % 10)) || { let k+=1; multiUpdates+=(--column 3++); }
	miniDB --table "$BATS_TEST_NAME" --update 'sequences' --column 1++ "${multiUpdates[@]}"
	assert_table_row "$BATS_TEST_NAME" 3 "sequences	$i	$j	$k" \
	    || { printf 'Increment%s to %d %d %d failed' "${multiUpdates:+ }${multiUpdates[*]}" $i $j $k; dump_table "$BATS_TEST_NAME"; return 1; }
	multiUpdates=()
    done
}
