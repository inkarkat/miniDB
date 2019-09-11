#!/usr/bin/env bats

@test "choose base type data uses XDG_DATA_HOME" {
    export XDG_DATA_HOME="${BATS_TEST_DIRNAME}/databases/dev"
    run miniDB --base-type data --table db --query foo
    [ $status -eq 0 ]
    [ "${#lines[@]}" -eq 1 ]
    [ "${lines[0]}" = 'foo	The Foo may have been there	41' ]
}

@test "choose base type data uses XDG_RUNTIME_DIR" {
    export XDG_RUNTIME_DIR="${BATS_TEST_DIRNAME}/databases/prod"
    run miniDB --base-type runtime --table db --query foo
    [ $status -eq 0 ]
    [ "${#lines[@]}" -eq 1 ]
    [ "${lines[0]}" = 'foo	The Foo has been here	42' ]
}

@test "choose base type cache uses XDG_CACHE_HOME" {
    export XDG_CACHE_HOME="${BATS_TEST_DIRNAME}/databases/prod"
    run miniDB --base-type cache --table db --query foo
    [ $status -eq 0 ]
    [ "${#lines[@]}" -eq 1 ]
    [ "${lines[0]}" = 'foo	The Foo has been here	42' ]
}
