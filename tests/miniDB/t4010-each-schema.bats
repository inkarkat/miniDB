#!/usr/bin/env bats

load fixture
load canned_databases

@test "iterating over a table that has a schema uses it" {
    run -0 miniDB --table multiline-schema --each 'printf "%s-%s\\n" "$ID" "$COUNT"'
    assert_equal ${#lines[@]} 6
    assert_line -n 0 'foo-42'
}

@test "passed schema overrides when iterating over a table that has a schema" {
    run -0 miniDB --schema 'FIRST SECOND THIRD FOURTH' --table multiline-schema --each 'printf "%s-%s-%s-%s\\n" "$FIRST" "$THIRD" "$ID" "$COUNT"'
    assert_equal ${#lines[@]} 6
    assert_line -n 0 'foo-42--'
}

@test "columns can be addressed via COL array if no schema passed nor in table" {
    run -0 miniDB --namespace dev --table db --each 'printf "%s-%s-%s-%s\\n" "${COL[0]}" "${COL[2]}" "$KEY" "$COLUMN"'
    assert_equal ${#lines[@]} 3
    assert_line -n 0 'foo-41--'
}
