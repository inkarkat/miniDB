#!/usr/bin/env bats

load canned_databases

@test "querying shell variables from a table with strange irregular schema names works as they are normalized" {
    run miniDB --table strange-schema --query foo --as-shell-variables

    [ $status -eq 0 ]
    [ "$output" = "WHAT_a_KEY0=foo
a__mysterious__description__=The\\ Foo\\ here\\ is\\ missing
_2funny_hat=abracadabra" ]
}
