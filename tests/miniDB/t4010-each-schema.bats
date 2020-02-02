#!/usr/bin/env bats

load canned_databases

@test "iterating over a table that has a schema uses it" {
    run miniDB --table multiline-schema --each 'printf "%s-%s\\n" "$ID" "$COUNT"'

    [ $status -eq 0 ]
    [ "${#lines[@]}" -eq 6 ]
    [ "${lines[0]}" = 'foo-42' ]
}

@test "passed schema overrides when iterating over a table that has a schema" {
    run miniDB --schema 'FIRST SECOND THIRD FOURTH' --table multiline-schema --each 'printf "%s-%s-%s-%s\\n" "$FIRST" "$THIRD" "$ID" "$COUNT"'

    [ $status -eq 0 ]
    [ "${#lines[@]}" -eq 6 ]
    [ "${lines[0]}" = 'foo-42--' ]
}

@test "columns can be addressed via COL array if no schema passed nor in table" {
    run miniDB --namespace dev --table db --each 'printf "%s-%s-%s-%s\\n" "${COL[0]}" "${COL[2]}" "$KEY" "$COLUMN"'

    [ $status -eq 0 ]
    [ "${#lines[@]}" -eq 3 ]
    [ "${lines[0]}" = 'foo-41--' ]
}
