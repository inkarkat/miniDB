#!/usr/bin/env bats

load fixture
load view_cleanup

setup()
{
    initialize_table "$BATS_TEST_NAME" from one-entry
    TX=Trans1
    clear_lock "$BATS_TEST_NAME"
    export NOW=1568635000
}

@test "when inside an expired transaction a view creation prints a warning" {
    miniDB --start-write-transaction "$TX" --table "$BATS_TEST_NAME"
    let NOW+=1
    miniDB --within-transaction "$TX" --table "$BATS_TEST_NAME" --query foo

    let NOW+=4
    run -0 miniDB --within-transaction "$TX" --table "$BATS_TEST_NAME" --create-view
    assert_line -n 0 "Warning: Current transaction timed out 2 seconds ago."
    refute_line -n 1 ''
    viewName="${lines[1]}"
}

@test "creating a view after update but before an addition sees the pending state" {
    miniDB --start-write-transaction "$TX" --table "$BATS_TEST_NAME"
    miniDB --within-transaction "$TX" --table "$BATS_TEST_NAME" --update "foo	A Foo has been updated	43"

    viewName="$(miniDB --within-transaction "$TX" --table "$BATS_TEST_NAME" --create-view)"
    miniDB --within-transaction "$TX" --table "$BATS_TEST_NAME" --update "new This has been added	100"

    run -0 miniDB --table "$BATS_TEST_NAME" --view "$viewName" --query foo
    assert_output 'foo	A Foo has been updated	43'

    run -4 miniDB --table "$BATS_TEST_NAME" --view "$viewName" --query new
    assert_output ''

    miniDB --end-transaction "$TX" --table "$BATS_TEST_NAME"
}

@test "creating a view after update but before the rollback sees the update" {
    miniDB --start-write-transaction "$TX" --table "$BATS_TEST_NAME"
    miniDB --within-transaction "$TX" --table "$BATS_TEST_NAME" --update "foo	A Foo has been updated	43"
    viewName="$(miniDB --within-transaction "$TX" --table "$BATS_TEST_NAME" --create-view)"
    miniDB --abort-write-transaction "$TX" --table "$BATS_TEST_NAME"

    run -0 miniDB --table "$BATS_TEST_NAME" --view "$viewName" --query foo
    assert_output 'foo	A Foo has been updated	43'
    assert_table_row "$BATS_TEST_NAME" \$ "foo	The Foo is here	42"
}
