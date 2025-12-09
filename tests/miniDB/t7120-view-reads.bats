#!/usr/bin/env bats

load fixture
load temp_view

@test "the view initially contains the same contents as the table" {
    run -0 miniDB --table "$BATS_TEST_NAME" --view "$viewName" --read-command 'cat {}'
    assert_output - < "${XDG_DATA_HOME}/${BATS_TEST_NAME}"
}

@test "the view is unaffected by changes to the table" {
    miniDB --table "$BATS_TEST_NAME" --update 'foo	changed	99'
    miniDB --table "$BATS_TEST_NAME" --delete bar
    miniDB --table "$BATS_TEST_NAME" --update 'new	New entry   11'

    run -0 miniDB --table "$BATS_TEST_NAME" --view "$viewName" --query foo
    assert_output 'foo	The Foo is here	42'

    run -0 miniDB --table "$BATS_TEST_NAME" --view "$viewName" --query bar
    assert_output 'bar	A man walks into a	21'

    run -4 miniDB --table "$BATS_TEST_NAME" --view "$viewName" --query new
    assert_output ''
}

@test "the view is unaffected by dropping the table" {
    miniDB --table "$BATS_TEST_NAME" --drop

    run -0 miniDB --table "$BATS_TEST_NAME" --view "$viewName" --query foo
    assert_output 'foo	The Foo is here	42'
}
