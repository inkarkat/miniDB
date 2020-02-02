#!/usr/bin/env bats

@test "unescape plain output argument" {
    readonly output="Just some plain text."
    [ "$(miniDB --unescape "$output")" = "$output" ]
}

@test "unescape output with newlines and backslashes passed as argument" {
    [ "$(miniDB --unescape 'A man\n\nwalks in\\to a "bar" with a\n/Foo\\ sign')" = 'A man

walks in\to a "bar" with a
/Foo\ sign' ]
}

@test "unescape output with newlines and backslashes passed via stdin" {
    [ "$(printf '%s\n' 'A man\n\nwalks in\\to a "bar" with a\n/Foo\\ sign' | miniDB --unescape -)" = 'A man

walks in\to a "bar" with a
/Foo\ sign' ]
}

@test "unescape output with newlines and backslashes passed via stdin omitting the -" {
    [ "$(printf '%s\n' 'A man\n\nwalks in\\to a "bar" with a\n/Foo\\ sign' | miniDB --unescape)" = 'A man

walks in\to a "bar" with a
/Foo\ sign' ]
}
