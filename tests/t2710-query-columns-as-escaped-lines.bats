#!/usr/bin/env bats

load canned_databases

@test "multi-line record can be queried omitting the key as escaped lines" {
    [ "$(miniDB --table multiline-schema --query foobar --columns \* --as-escaped-lines)" = 'The\n"original"\n\none
1
with multiple and empty lines' ]
}

@test "columns from multi-line record can be queried as escaped lines" {
    [ "$(miniDB --table multiline-schema --query bar --columns 'DESCRIPTION 3' --as-escaped-lines)" = 'A man\n\nwalks in\\to a
with one\nnewline and \\ backslash' ]
}
