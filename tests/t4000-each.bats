#!/usr/bin/env bats

load canned_databases

@test "iterating over a single-entry table printing the record" {
    [ "$(miniDB --schema 'KEY TEXT NUMBER' --table one-entry --each 'printf "[%s] " "$KEY" "$NUMBER" "$TEXT"')" = '[foo] [42] [The Foo is here] ' ]
}

@test "iterating over a table printing the records" {
    run miniDB --schema 'KEY TEXT NUMBER' --namespace dev --table db --each 'printf "[%s] " "$KEY" "$NUMBER" "$TEXT"; echo'
    [ $status -eq 0 ]
    [ "${lines[0]}" = "[foo] [41] [The Foo may have been there] " ]
    [ "${lines[1]}" = "[bar] [0] [A man walks into a] " ]
    [ "${lines[2]}" = "[test] [123] [Testing] " ]
}
