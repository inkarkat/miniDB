#!/usr/bin/env bats

load fixture
load canned_databases

@test "existing key can be queried specifying a single column by number" {
    assert_equal "$(miniDB --table multiline-schema --query foo --columns 0)" 'foo'
    assert_equal "$(miniDB --table multiline-schema --query foo --columns 1)" 'The /Foo\ is here'
    assert_equal "$(miniDB --table multiline-schema --query foo --columns 2)" '42'
    assert_equal "$(miniDB --table multiline-schema --query foo --columns 3)" 'with backslash'
}

@test "existing key can be queried specifying a non-existing column by number" {
    assert_equal "$(miniDB --table multiline-schema --query foo --columns 4)" ''
}

@test "existing key can be queried specifying a multiple columns by numbers" {
    assert_equal "$(miniDB --table multiline-schema --query foo --columns '1 2')" 'The /Foo\ is here	42'
    assert_equal "$(miniDB --table multiline-schema --query foo --columns '2 3')" '42	with backslash'
    assert_equal "$(miniDB --table multiline-schema --query foo --columns '1 3')" 'The /Foo\ is here	with backslash'
    assert_equal "$(miniDB --table multiline-schema --query foo --columns '2 0 1 3 0')" '42	foo	The /Foo\ is here	with backslash	foo'
}

@test "existing key can be queried specifying multiple columns containing non-existing ones by numbers" {
    assert_equal "$(miniDB --table multiline-schema --query foo --columns '2 5 7 3')" '42			with backslash'
    assert_equal "$(miniDB --table multiline-schema --query foo --columns '5 2 7')" '	42	'
}
