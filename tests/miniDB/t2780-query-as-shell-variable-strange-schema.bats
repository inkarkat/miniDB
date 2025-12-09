#!/usr/bin/env bats

load fixture
load canned_databases

@test "querying shell variables from a table with strange irregular schema names works as they are normalized" {
    run -0 miniDB --table strange-schema --query foo --as-shell-variables
    assert_output - <<'EOF'
WHAT_a_KEY0=foo
a__mysterious__description__=The\ Foo\ here\ is\ missing
_2funny_hat=abracadabra
EOF
}
