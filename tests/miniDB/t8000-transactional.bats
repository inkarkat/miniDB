#!/usr/bin/env bats

load temp_database

setup()
{
    ARGS=(--transactional --schema "ID SURNAME GIVEN-NAME" --table tx)
}

@test "transactional update of a non-existing table with passed schema" {
    clean_table tx

    miniDB "${ARGS[@]}" --update "P1	Bash	Johnny"

    assert_table_row tx 1 "# ID	SURNAME	GIVEN-NAME"
    assert_table_row tx \$ "P1	Bash	Johnny"
}

@test "transactional update of an empty table with new keys adds two rows" {
    miniDB "${ARGS[@]}" --update "P2	Bates	Gill"
    miniDB "${ARGS[@]}" --update "P3	Null	Dave"

    assert_table_row tx 1 "# ID	SURNAME	GIVEN-NAME"
    assert_table_row tx 2 "P1	Bash	Johnny"
    assert_table_row tx 3 "P2	Bates	Gill"
    assert_table_row tx 4 "P3	Null	Dave"
}

@test "transactional query of existing key" {
    run miniDB "${ARGS[@]}" --query P1
    [ $status -eq 0 ]
    [ "$output" = 'P1	Bash	Johnny' ]
}

@test "transactional query of non-existing key" {
    run miniDB "${ARGS[@]}" --query P0
    [ $status -eq 4 ]
    [ "${#lines[@]}" -eq 0 ]
}

@test "transactional update of an existing row" {
    miniDB "${ARGS[@]}" --update "P2	Ballmer	Gillian"
    assert_table_row tx 3 "P2	Ballmer	Gillian"
}

@test "transactional delete of a row" {
    run miniDB "${ARGS[@]}" --delete P2
    assert_table_row tx 3 "P3	Null	Dave"
}

@test "transactional drop of database" {
    run miniDB "${ARGS[@]}" --drop
    [ $status -eq 0 ]
    [ "${#lines[@]}" -eq 0 ]
    ! table_exists tx
}
