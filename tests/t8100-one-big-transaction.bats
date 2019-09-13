#!/usr/bin/env bats

load temp_database

setup()
{
    TX=Trans1
    ARGS=(--schema "ID SURNAME GIVEN-NAME" --table tx)
    TX_ARGS=("${ARGS[@]}" --within-transaction "$TX")
}

@test "start transaction" {
    clean_table tx
    clear_lock tx

    miniDB "${ARGS[@]}" --start-write-transaction "$TX"
}
@test "one transaction update of a non-existing table with passed schema" {
    miniDB "${TX_ARGS[@]}" --update "P1	Bash	Johnny"

    assert_table_row tx 1 "# ID	SURNAME	GIVEN-NAME"
    assert_table_row tx \$ "P1	Bash	Johnny"
}

@test "one transaction update of an empty table with new keys adds two rows" {
    miniDB "${TX_ARGS[@]}" --update "P2	Bates	Gill"
    miniDB "${TX_ARGS[@]}" --update "P3	Null	Dave"

    assert_table_row tx 1 "# ID	SURNAME	GIVEN-NAME"
    assert_table_row tx 2 "P1	Bash	Johnny"
    assert_table_row tx 3 "P2	Bates	Gill"
    assert_table_row tx 4 "P3	Null	Dave"
}

@test "one transaction query of existing key" {
    run miniDB "${TX_ARGS[@]}" --query P1
    [ $status -eq 0 ]
    [ "$output" = 'P1	Bash	Johnny' ]
}

@test "one transaction query of non-existing key" {
    run miniDB "${TX_ARGS[@]}" --query P0
    [ $status -eq 4 ]
    [ "${#lines[@]}" -eq 0 ]
}

@test "one transaction update of an existing row" {
    miniDB "${TX_ARGS[@]}" --update "P2	Ballmer	Gillian"
    assert_table_row tx 3 "P2	Ballmer	Gillian"
}

@test "one transaction delete of a row" {
    run miniDB "${TX_ARGS[@]}" --delete P2
    assert_table_row tx 3 "P3	Null	Dave"
}

@test "one transaction drop of database" {
    run miniDB "${TX_ARGS[@]}" --drop
    [ $status -eq 0 ]
    [ "${#lines[@]}" -eq 0 ]
    ! table_exists tx
}

@test "end transaction" {
    miniDB "${ARGS[@]}" --end-transaction "$TX"
}
