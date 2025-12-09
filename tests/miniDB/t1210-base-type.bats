#!/usr/bin/env bats

load fixture

@test "default base type data uses XDG_DATA_HOME" {
    export XDG_DATA_HOME="${BATS_TEST_DIRNAME}/databases/dev"
    run -0 miniDB --table db --query foo
    assert_equal ${#lines[@]} 1
    assert_line -n 0 'foo	The Foo may have been there	41'
}

@test "chosen base type config uses XDG_CONFIG_HOME" {
    export XDG_CONFIG_HOME="${BATS_TEST_DIRNAME}/databases/dev"
    run -0 miniDB --base-type config --table db --query foo
    assert_equal ${#lines[@]} 1
    assert_line -n 0 'foo	The Foo may have been there	41'
}

@test "chosen base type data uses XDG_DATA_HOME" {
    export XDG_DATA_HOME="${BATS_TEST_DIRNAME}/databases/dev"
    run -0 miniDB --base-type data --table db --query foo
    assert_equal ${#lines[@]} 1
    assert_line -n 0 'foo	The Foo may have been there	41'
}

@test "chosen base type runtime uses XDG_RUNTIME_DIR" {
    export XDG_RUNTIME_DIR="${BATS_TEST_DIRNAME}/databases/prod"
    run -0 miniDB --base-type runtime --table db --query foo
    assert_equal ${#lines[@]} 1
    assert_line -n 0 'foo	The Foo has been here	42'
}

@test "chosen base type cache uses XDG_CACHE_HOME" {
    export XDG_CACHE_HOME="${BATS_TEST_DIRNAME}/databases/prod"
    run -0 miniDB --base-type cache --table db --query foo
    assert_equal ${#lines[@]} 1
    assert_line -n 0 'foo	The Foo has been here	42'
}

@test "chosen base type temp uses TMPDIR" {
    export TMPDIR="${BATS_TEST_DIRNAME}/databases/prod"
    run -0 miniDB --base-type temp --table db --query foo
    assert_equal ${#lines[@]} 1
    assert_line -n 0 'foo	The Foo has been here	42'
}
