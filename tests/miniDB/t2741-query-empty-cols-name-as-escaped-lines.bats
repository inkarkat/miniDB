#!/usr/bin/env bats

load canned_databases

@test "two optional empty values in the middle" {
    [ "$(miniDB --table empty-columns --query opt --columns 'NOTES OPT3 OPT1 VAL' --as-escaped-lines; printf \$)" = 'a note


a value
$' ]
}

@test "all empty optional values" {
    [ "$(miniDB --table empty-columns --query opt --columns 'OPT1 OPT2 OPT3' --as-escaped-lines; printf \$)" = '


$' ]
}
