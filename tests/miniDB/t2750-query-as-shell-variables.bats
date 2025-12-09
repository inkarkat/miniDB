#!/usr/bin/env bats

load fixture
load canned_databases

@test "plain single-line key can be queried as shell variables" {
    run -0 miniDB --table multiline-schema --query \* --as-shell-variables

    assert_output - <<'EOF'
ID=\*
DESCRIPTION=Looks\ like\ a\ placeholder\ to\ me
COUNT=0
NOTES=''
EOF
}

@test "single-line record with backslash can be queried as shell variables" {
    run -0 miniDB --table multiline-schema --query foo --as-shell-variables

    assert_output - <<'EOF'
ID=foo
DESCRIPTION=The\ /Foo\\\ is\ here
COUNT=42
NOTES=with\ backslash
EOF
}

@test "multi-line record with backslash can be queried as shell variables" {
    run -0 miniDB --table multiline-schema --query bar --as-shell-variables

    assert_equal "$output" "ID=bar
DESCRIPTION=$'A man\\n\\nwalks in\\\\to a'
COUNT=21
NOTES=$'with one\\nnewline and \\\\ backslash'"
}

@test "record with just a key can be queried as shell variables" {
    run -0 miniDB --table multiline-schema --query empty --as-shell-variables

    assert_output - <<'EOF'
ID=empty
DESCRIPTION=''
COUNT=''
NOTES=''
EOF
}
