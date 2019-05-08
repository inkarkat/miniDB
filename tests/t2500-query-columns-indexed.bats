#!/usr/bin/env bats

load canned_databases

@test "existing key can be queried specifying a single column by number" {
    [ "$(miniDB --table multiline-schema --query foo --columns 0)" = 'foo' ]
    [ "$(miniDB --table multiline-schema --query foo --columns 1)" = 'The /Foo\ is here' ]
    [ "$(miniDB --table multiline-schema --query foo --columns 2)" = '42' ]
    [ "$(miniDB --table multiline-schema --query foo --columns 3)" = 'with backslash' ]
}

@test "existing key can be queried specifying a non-existing column by number" {
    [ "$(miniDB --table multiline-schema --query foo --columns 4)" = '' ]
}

@test "existing key can be queried specifying a multiple columns by numbers" {
    [ "$(miniDB --table multiline-schema --query foo --columns '1 2')" = 'The /Foo\ is here	42' ]
    [ "$(miniDB --table multiline-schema --query foo --columns '2 3')" = '42	with backslash' ]
    [ "$(miniDB --table multiline-schema --query foo --columns '1 3')" = 'The /Foo\ is here	with backslash' ]
    [ "$(miniDB --table multiline-schema --query foo --columns '2 0 1 3 0')" = '42	foo	The /Foo\ is here	with backslash	foo' ]
}

@test "existing key can be queried specifying multiple columns containing non-existing ones by numbers" {
    [ "$(miniDB --table multiline-schema --query foo --columns '2 5 7 3')" = '42			with backslash' ]
    [ "$(miniDB --table multiline-schema --query foo --columns '5 2 7')" = '	42	' ]
}
