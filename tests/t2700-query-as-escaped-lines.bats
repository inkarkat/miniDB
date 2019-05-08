#!/usr/bin/env bats

load canned_databases

@test "plain single-line key can be queried as escaped lines" {
    [ "$(miniDB --table multiline-schema --query \* --as-escaped-lines)" = '*
Looks like a placeholder to me
0' ]
}

@test "single-line record with backslash can be queried as escaped lines" {
    [ "$(miniDB --table multiline-schema --query foo --as-escaped-lines)" = 'foo
The /Foo\\ is here
42
with backslash' ]
}

@test "multi-line record with backslash can be queried as escaped lines" {
    [ "$(miniDB --table multiline-schema --query bar --as-escaped-lines)" = 'bar
A man\n\nwalks in\\to a
21
with one\nnewline and \\ backslash' ]
}

@test "record with just a key can be queried as escaped lines" {
    [ "$(miniDB --table multiline-schema --query empty --as-escaped-lines)" = 'empty' ]
}
