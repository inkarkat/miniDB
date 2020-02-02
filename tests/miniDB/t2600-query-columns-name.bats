#!/usr/bin/env bats

load canned_databases

setup()
{
    SCHEMA=(--schema 'ID DESCRIPTION COUNT NOTES')
}

@test "existing key can be queried specifying a single column by name" {
    [ "$(miniDB "${SCHEMA[@]}" --table multiline-schema --query foo --columns ID)" = 'foo' ]
    [ "$(miniDB "${SCHEMA[@]}" --table multiline-schema --query foo --columns DESCRIPTION)" = 'The /Foo\ is here' ]
    [ "$(miniDB "${SCHEMA[@]}" --table multiline-schema --query foo --columns COUNT)" = '42' ]
    [ "$(miniDB "${SCHEMA[@]}" --table multiline-schema --query foo --columns NOTES)" = 'with backslash' ]
}

@test "specifying a non-existing column by name results in an error" {
    run miniDB "${SCHEMA[@]}" --table multiline-schema --query foo --columns DOESNOTEXIST
    [ $status -eq 2 ]
    [ "$output" = 'ERROR: Unknown column DOESNOTEXIST; not an index nor named in schema ID DESCRIPTION COUNT NOTES.' ]
}

@test "specifying one non-existing column by name inside existing columns results in an error" {
    run miniDB "${SCHEMA[@]}" --table multiline-schema --query foo --columns '1 3 COUNT 2 DOESNOTEXIST 7'
    [ $status -eq 2 ]
    [ "$output" = 'ERROR: Unknown column DOESNOTEXIST; not an index nor named in schema ID DESCRIPTION COUNT NOTES.' ]
}

@test "existing key can be queried specifying multiple columns by names" {
    [ "$(miniDB "${SCHEMA[@]}" --table multiline-schema --query foo --columns 'DESCRIPTION COUNT')" = 'The /Foo\ is here	42' ]
    [ "$(miniDB "${SCHEMA[@]}" --table multiline-schema --query foo --columns 'COUNT NOTES')" = '42	with backslash' ]
    [ "$(miniDB "${SCHEMA[@]}" --table multiline-schema --query foo --columns 'DESCRIPTION NOTES')" = 'The /Foo\ is here	with backslash' ]
    [ "$(miniDB "${SCHEMA[@]}" --table multiline-schema --query foo --columns 'COUNT ID DESCRIPTION NOTES ID')" = '42	foo	The /Foo\ is here	with backslash	foo' ]
}

@test "existing key can be queried specifying multiple columns by a mixture of indices and names" {
    [ "$(miniDB "${SCHEMA[@]}" --table multiline-schema --query foo --columns '1 COUNT')" = 'The /Foo\ is here	42' ]
    [ "$(miniDB "${SCHEMA[@]}" --table multiline-schema --query foo --columns 'COUNT 3')" = '42	with backslash' ]
    [ "$(miniDB "${SCHEMA[@]}" --table multiline-schema --query foo --columns '2 ID 1 NOTES 0')" = '42	foo	The /Foo\ is here	with backslash	foo' ]
}
