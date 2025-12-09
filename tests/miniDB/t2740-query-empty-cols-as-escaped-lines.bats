#!/usr/bin/env bats

load fixture
load canned_databases

@test "no empty values" {
    assert_equal "$(miniDB --table empty-columns --query full --columns \* --as-escaped-lines; printf \$)" '1
No empty
a value
2
3
a note
4
$'
}

@test "a first optional empty value" {
    assert_equal "$(miniDB --table empty-columns --query first --columns \* --as-escaped-lines; printf \$)" '
Empty first
a value
2
3
a note
4
$'
}

@test "two middle optional empty values" {
    assert_equal "$(miniDB --table empty-columns --query middle --columns \* --as-escaped-lines; printf \$)" '1
Empty 2+3
a value


a note
4
$'
}

@test "a last optional empty values" {
    assert_equal "$(miniDB --table empty-columns --query last --columns \* --as-escaped-lines; printf \$)" '1
Empty last
a value
2
3
a note

$'
}

@test "all optional empty values" {
    assert_equal "$(miniDB --table empty-columns --query opt --columns \* --as-escaped-lines; printf \$)" '
Empty opts
a value


a note

$'
}

@test "all empty values" {
    assert_equal "$(miniDB --table empty-columns --query all --columns \* --as-escaped-lines; printf \$)" '






$'
}

@test "no columns does not output anything" {
    assert_equal "$(miniDB --table empty-columns --query none --columns \* --as-escaped-lines; printf \$)" '$'
}
