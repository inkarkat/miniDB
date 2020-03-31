#!/usr/bin/env bats

load canned_databases

@test "no empty values" {
    [ "$(miniDB --table empty-columns --query full --columns \* --as-shell-variables; printf \$)" = 'OPT1=1
DESCRIPTION=No\ empty
VAL=a\ value
OPT2=2
OPT3=3
NOTES=a\ note
OPT4=4
$' ]
}

@test "a first optional empty value" {
    [ "$(miniDB --table empty-columns --query first --columns \* --as-shell-variables; printf \$)" = 'OPT1='\'\''
DESCRIPTION=Empty\ first
VAL=a\ value
OPT2=2
OPT3=3
NOTES=a\ note
OPT4=4
$' ]
}

@test "two middle optional empty values" {
    [ "$(miniDB --table empty-columns --query middle --columns \* --as-shell-variables; printf \$)" = 'OPT1=1
DESCRIPTION=Empty\ 2+3
VAL=a\ value
OPT2='\'\''
OPT3='\'\''
NOTES=a\ note
OPT4=4
$' ]
}

@test "a last optional empty values" {
    [ "$(miniDB --table empty-columns --query last --columns \* --as-shell-variables; printf \$)" = 'OPT1=1
DESCRIPTION=Empty\ last
VAL=a\ value
OPT2=2
OPT3=3
NOTES=a\ note
OPT4='\'\''
$' ]
}

@test "all optional empty values" {
    [ "$(miniDB --table empty-columns --query opt --columns \* --as-shell-variables; printf \$)" = 'OPT1='\'\''
DESCRIPTION=Empty\ opts
VAL=a\ value
OPT2='\'\''
OPT3='\'\''
NOTES=a\ note
OPT4='\'\''
$' ]
}

@test "all empty values" {
    [ "$(miniDB --table empty-columns --query all --columns \* --as-shell-variables; printf \$)" = 'OPT1='\'\''
DESCRIPTION='\'\''
VAL='\'\''
OPT2='\'\''
OPT3='\'\''
NOTES='\'\''
OPT4='\'\''
$' ]
}

@test "no columns prints all schema colums with empty values" {
    [ "$(miniDB --table empty-columns --query none --columns \* --as-shell-variables; printf \$)" = 'OPT1='\'\''
DESCRIPTION='\'\''
VAL='\'\''
OPT2='\'\''
OPT3='\'\''
NOTES='\'\''
OPT4='\'\''
$' ]
}
