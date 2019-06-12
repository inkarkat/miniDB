#!/usr/bin/env bats

load canned_databases

@test "plain single-line key can be queried as shell variables" {
    run miniDB --table multiline-schema --query \* --as-shell-variables
    [ $status -eq 0 ]

    [ "$output" = "ID=\*
DESCRIPTION=Looks\\ like\\ a\\ placeholder\\ to\\ me
COUNT=0
NOTES=''" ]
}

@test "single-line record with backslash can be queried as shell variables" {
    run miniDB --table multiline-schema --query foo --as-shell-variables

    [ "$output" = "ID=foo
DESCRIPTION=The\\ /Foo\\\\\\ is\\ here
COUNT=42
NOTES=with\ backslash" ]
}

@test "multi-line record with backslash can be queried as shell variables" {
    run miniDB --table multiline-schema --query bar --as-shell-variables

    [ "$output" = "ID=bar
DESCRIPTION=$'A man\\n\\nwalks in\\\\to a'
COUNT=21
NOTES=$'with one\\nnewline and \\\\ backslash'" ]
}

@test "record with just a key can be queried as shell variables" {
    run miniDB --table multiline-schema --query empty --as-shell-variables

    [ "$output" = "ID=empty
DESCRIPTION=''
COUNT=''
NOTES=''" ]
}
