#!/usr/bin/env bats

load fixture
load canned_databases

@test "multi-line record can be queried omitting the key as shell variables" {
    run -0 miniDB --table multiline-schema --query foobar --columns \* --as-shell-variables
    assert_output - <<'EOF'
DESCRIPTION=$'The\n"original"\n\none'
COUNT=1
NOTES=with\ multiple\ and\ empty\ lines
EOF
}

@test "columns from multi-line record can be queried as shell variables" {
    run -0 miniDB --table multiline-schema --query bar --columns 'DESCRIPTION 3' --as-shell-variables
    assert_output - <<'EOF'
DESCRIPTION=$'A man\n\nwalks in\\to a'
NOTES=$'with one\nnewline and \\ backslash'
EOF
}
