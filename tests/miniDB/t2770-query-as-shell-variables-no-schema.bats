#!/usr/bin/env bats

load fixture
load canned_databases

@test "a table that uses the default schema uses counted COL variables" {
    run -0 miniDB --table one-entry --query foo --as-shell-variables
    assert_output - <<'EOF'
COL0=foo
COL1=The\ Foo\ is\ here
COL2=42
EOF
}

@test "a table that uses the default schema cannot be queried by name with it" {
    run -2 miniDB --table one-entry --query foo --columns COLUMN --as-shell-variables
    assert_output 'ERROR: Cannot resolve named columns from the table one-entry, as no schema is defined there. Use indices or pass a --schema SCHEMA.'
}
