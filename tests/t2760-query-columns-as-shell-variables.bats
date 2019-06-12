#!/usr/bin/env bats

load canned_databases

@test "multi-line record can be queried omitting the key as shell variables" {
    run miniDB --table multiline-schema --query foobar --columns \* --as-shell-variables

    [ $status -eq 0 ]
    [ "$output" = "DESCRIPTION=\$'The\\n\"original\"\\n\\none'
COUNT=1
NOTES=with\\ multiple\\ and\\ empty\\ lines" ]
}

@test "columns from multi-line record can be queried as shell variables" {
    run miniDB --table multiline-schema --query bar --columns 'DESCRIPTION 3' --as-shell-variables

    [ $status -eq 0 ]
    [ "$output" = "DESCRIPTION=\$'A man\\n\\nwalks in\\\\to a'
NOTES=\$'with one\\nnewline and \\\\ backslash'" ]
}
