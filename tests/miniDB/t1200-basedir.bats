#!/usr/bin/env bats

load fixture

@test "custom base dir can be passed" {
    run -0 miniDB --basedir "${BATS_TEST_DIRNAME}/databases" --table one-entry --query foo
    assert_equal ${#lines[@]} 1
    assert_line -n 0 'foo	The Foo is here	42'
}

@test "a non-existing base dir is created" {
    local newDir="${BATS_TMPDIR}/new"
    rm -rf -- "$newDir"
    run -0 miniDB --basedir "$newDir" --table "$BATS_TEST_NAME" --update "key  value"
    assert_file_exists "${newDir}/$BATS_TEST_NAME"
    rm -rf -- "$newDir"
}
