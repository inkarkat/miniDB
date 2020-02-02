#!/usr/bin/env bats

@test "custom base dir can be passed" {
    run miniDB --basedir "${BATS_TEST_DIRNAME}/databases" --table one-entry --query foo
    [ $status -eq 0 ]
    [ "${#lines[@]}" -eq 1 ]
    [ "${lines[0]}" = 'foo	The Foo is here	42' ]
}

@test "a non-existing base dir is created" {
    local newDir="${BATS_TMPDIR}/new"
    rm -rf "$newDir"
    run miniDB --basedir "$newDir" --table "$BATS_TEST_NAME" --update "key  value"
    [ $status -eq 0 ]
    [ -f "${newDir}/$BATS_TEST_NAME" ]
    rm -rf "$newDir"
}
