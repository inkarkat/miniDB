#!/usr/bin/env bats

load temp_database

setup()
{
    initialize_table "$BATS_TEST_NAME" from one-entry
    clear_lock "$BATS_TEST_NAME"
    export NOW=1568635000
}

@test "when starting a new read transaction, a previous started read transaction that timed out prints a warning" {
    miniDB --start-read-transaction Trans1 --table "$BATS_TEST_NAME"

    let NOW+=4
    run miniDB --start-read-transaction Trans2 --table "$BATS_TEST_NAME"
    [ "$output" = "Warning: Previous read transaction by Trans1 timed out 1 second ago but did not do any changes." ]
}

@test "when the owner immediately starts another read transaction, this becomes a shared one" {
    miniDB --start-read-transaction Trans1 --table "$BATS_TEST_NAME"
    miniDB --within-transaction Trans1 --table "$BATS_TEST_NAME" --query foo

    miniDB --start-read-transaction Trans1 --table "$BATS_TEST_NAME"
}

@test "when the owner starts another read transaction whose timeout is not longer than the original one, this becomes a shared one" {
    miniDB --transaction-timeout 6 --start-read-transaction Trans1 --table "$BATS_TEST_NAME"
    miniDB --within-transaction Trans1 --table "$BATS_TEST_NAME" --query foo

    let NOW+=1
    miniDB --transaction-timeout 3 --start-read-transaction Trans1 --table "$BATS_TEST_NAME"

    let NOW+=1
    miniDB --transaction-timeout 4 --start-read-transaction Trans1 --table "$BATS_TEST_NAME"
}

@test "when the owner starts another read transaction whose timeout is longer than the original one, this returns 1" {
    miniDB --start-read-transaction Trans1 --table "$BATS_TEST_NAME"
    miniDB --within-transaction Trans1 --table "$BATS_TEST_NAME" --query foo

    let NOW+=1
    run miniDB --start-read-transaction Trans1 --table "$BATS_TEST_NAME"
    [ $status -eq 1 ]
    [ "$output" = "ERROR: Another read transaction by Trans1 is already in progress." ]
}

@test "when the owner starts another read transaction whose timeout is not longer than the original one, this becomes a shared one" {
    miniDB --transaction-timeout 6 --start-read-transaction Trans1 --table "$BATS_TEST_NAME"
    miniDB --within-transaction Trans1 --table "$BATS_TEST_NAME" --query foo

    let NOW+=1
    miniDB --transaction-timeout 3 --start-read-transaction Trans2 --table "$BATS_TEST_NAME"

    let NOW+=1
    miniDB --transaction-timeout 4 --start-read-transaction Trans3 --table "$BATS_TEST_NAME"
}

@test "when the owner starts a read transaction whose timeout is longer then another's one and before another's read one times out, the attempt times out" {
    miniDB --start-read-transaction Trans1 --table "$BATS_TEST_NAME"
    miniDB --within-transaction Trans1 --table "$BATS_TEST_NAME" --query foo

    let NOW+=1
    run miniDB --timeout 1 --start-read-transaction Trans2 --table "$BATS_TEST_NAME"
    [ $status -eq 5 ]
    [ "$output" = "Timed out while another read transaction by Trans1 is in progress." ]
}
