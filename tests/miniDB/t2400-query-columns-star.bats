#!/usr/bin/env bats

load fixture
load canned_databases

@test "existing key can be queried omitting the key" {
    run -0 miniDB --table multiline-schema --query foo --columns \*
    assert_output 'The /Foo\ is here	42	with backslash'
}

@test "existing multiline record can be queried omitting the key" {
    run -0 miniDB --table multiline-schema --query bar --columns \*
    assert_output - <<'EOF'
A man

walks in\to a	21	with one
newline and \ backslash
EOF
}

@test "existing key with space can be queried omitting the key" {
    run -0 miniDB --table multiline-schema --query 'o O' --columns \*
    assert_output 'An ID with space in it'
}

@test "existing key without columns can be queried" {
    run -0 miniDB --table multiline-schema --query empty --columns \*
    assert_output ''
}
