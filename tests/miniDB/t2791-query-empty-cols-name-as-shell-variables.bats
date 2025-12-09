#!/usr/bin/env bats

load fixture
load canned_databases

@test "two optional empty values in the middle" {
    assert_equal "$(miniDB --table empty-columns --query opt --columns 'NOTES OPT3 OPT1 VAL' --as-shell-variables; printf \$)" 'NOTES=a\ note
OPT3='\'\''
OPT1='\'\''
VAL=a\ value
$'
}

@test "all empty optional values" {
    assert_equal "$(miniDB --table empty-columns --query opt --columns 'OPT1 OPT2 OPT3' --as-shell-variables; printf \$)" 'OPT1='\'\''
OPT2='\'\''
OPT3='\'\''
$'
}
