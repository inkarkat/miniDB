#!/usr/bin/env bats

load canned_databases

@test "iterating over a table with strange irregular schema names works as they are normalized" {
    run miniDB --table strange-schema --each 'printf "%s-%s-%s\\n" "$WHAT_a_KEY0" "$a__mysterious__description__" "$_2funny_hat"'

    [ $status -eq 0 ]
    [ "${#lines[@]}" -eq 1 ]
    [ "${lines[0]}" = 'foo-The Foo here is missing-abracadabra' ]
}

