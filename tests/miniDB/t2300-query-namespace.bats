#!/usr/bin/env bats

load fixture
load canned_databases

@test "attempting to open database without corresponding namespace fails" {
    run -1 miniDB --table db --query foo
}

@test "key from database in namespace can be queried" {
    run -0 miniDB --namespace dev --table db --query foo
    assert_equal ${#lines[@]} 1
    assert_line -n 0 'foo	The Foo may have been there	41'
}

@test "key from database in another namespace can be queried" {
    run -0 miniDB --namespace prod --table db --query foo
    assert_equal ${#lines[@]} 1
    assert_line -n 0 'foo	The Foo has been here	42'
}
