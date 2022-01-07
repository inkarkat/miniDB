#!/usr/bin/env bats

load temp_database

@test "update with query of a single column by number" {
    initialize_table "$BATS_TEST_NAME" from multiline-schema

    [ "$(miniDB --table "$BATS_TEST_NAME" --update foo --column COUNT++ --columns 0)" = 'foo' ]
    [ "$(miniDB --table "$BATS_TEST_NAME" --update foo --column COUNT++ --columns 1)" = 'The /Foo\ is here' ]
    [ "$(miniDB --table "$BATS_TEST_NAME" --update foo --column COUNT++ --columns 2)" = '44' ]
    [ "$(miniDB --table "$BATS_TEST_NAME" --update foo --column COUNT++ --columns 3)" = 'with backslash' ]
}

@test "update with query of a non-existing column by number" {
    initialize_table "$BATS_TEST_NAME" from multiline-schema

    [ "$(miniDB --table "$BATS_TEST_NAME" --update foo --column COUNT++ --columns 4)" = '' ]
}

@test "update with query of a multiple columns by numbers" {
    initialize_table "$BATS_TEST_NAME" from multiline-schema

    [ "$(miniDB --table "$BATS_TEST_NAME" --update foo --column COUNT++ --columns '1 2')" = 'The /Foo\ is here	42' ]
    [ "$(miniDB --table "$BATS_TEST_NAME" --update foo --column COUNT++ --columns '2 3')" = '43	with backslash' ]
    [ "$(miniDB --table "$BATS_TEST_NAME" --update foo --column COUNT++ --columns '1 3')" = 'The /Foo\ is here	with backslash' ]
    [ "$(miniDB --table "$BATS_TEST_NAME" --update foo --column COUNT++ --columns '2 0 1 3 0')" = '45	foo	The /Foo\ is here	with backslash	foo' ]
}

@test "update with query of multiple columns containing non-existing ones by numbers" {
    initialize_table "$BATS_TEST_NAME" from multiline-schema

    [ "$(miniDB --table "$BATS_TEST_NAME" --update foo --column COUNT++ --columns '2 5 7 3')" = '42			with backslash' ]
    [ "$(miniDB --table "$BATS_TEST_NAME" --update foo --column COUNT++ --columns '5 2 7')" = '	43	' ]
}
