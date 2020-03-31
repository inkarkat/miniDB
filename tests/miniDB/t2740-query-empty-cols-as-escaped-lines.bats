#!/usr/bin/env bats

load canned_databases

@test "no empty values" {
    [ "$(miniDB --table empty-columns --query full --columns \* --as-escaped-lines; printf \$)" = '1
No empty
a value
2
3
a note
4
$' ]
}

@test "a first optional empty value" {
    [ "$(miniDB --table empty-columns --query first --columns \* --as-escaped-lines; printf \$)" = '
Empty first
a value
2
3
a note
4
$' ]
}

@test "two middle optional empty values" {
    [ "$(miniDB --table empty-columns --query middle --columns \* --as-escaped-lines; printf \$)" = '1
Empty 2+3
a value


a note
4
$' ]
}

@test "a last optional empty values" {
    [ "$(miniDB --table empty-columns --query last --columns \* --as-escaped-lines; printf \$)" = '1
Empty last
a value
2
3
a note

$' ]
}

@test "all optional empty values" {
    [ "$(miniDB --table empty-columns --query opt --columns \* --as-escaped-lines; printf \$)" = '
Empty opts
a value


a note

$' ]
}

@test "all empty values" {
    [ "$(miniDB --table empty-columns --query all --columns \* --as-escaped-lines; printf \$)" = '






$' ]
}

@test "no columns does not output anything" {
    [ "$(miniDB --table empty-columns --query none --columns \* --as-escaped-lines; printf \$)" = '$' ]
}
