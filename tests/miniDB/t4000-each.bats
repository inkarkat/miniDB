#!/usr/bin/env bats

load fixture
load canned_databases

@test "iterating over a single-entry table printing the record" {
    assert_equal "$(miniDB --schema 'KEY TEXT NUMBER' --table one-entry --each 'printf "[%s] " "$KEY" "$NUMBER" "$TEXT"')" '[foo] [42] [The Foo is here] '
}

@test "iterating over a table printing the records" {
    run -0 miniDB --schema 'KEY TEXT NUMBER' --namespace dev --table db --each 'printf "[%s] " "$KEY" "$NUMBER" "$TEXT"; echo'
    assert_equal ${#lines[@]} 3
    assert_line -n 0 "[foo] [41] [The Foo may have been there] "
    assert_line -n 1 "[bar] [0] [A man walks into a] "
    assert_line -n 2 "[test] [123] [Testing] "
}
