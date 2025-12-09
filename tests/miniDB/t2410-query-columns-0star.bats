#!/usr/bin/env bats

load fixture
load canned_databases

@test "existing key can be queried with 0*" {
    run -0 miniDB --table multiline-schema --query foo --columns 0\*
    assert_output 'foo	The /Foo\ is here	42	with backslash'
}

@test "existing multiline record can be queried with 0*" {
    run -0 miniDB --table multiline-schema --query bar --columns 0\*
    assert_output - <<'EOF'
bar	A man

walks in\to a	21	with one
newline and \ backslash
EOF
}

@test "existing key with space can be queried with 0*" {
    run -0 miniDB --table multiline-schema --query 'o O' --columns 0\*
    assert_output 'o O	An ID with space in it'
}

@test "existing key without columns can be queried" {
    run -0 miniDB --table multiline-schema --query empty --columns 0\*
    assert_output 'empty	'
}
