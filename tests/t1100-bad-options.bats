#!/usr/bin/env bats

load canned_databases

@test "multiple actions print usage error" {
    run miniDB --table some-entries --query foo --update "fox	blah	blah"
    [ $status -eq 2 ]
    [ "${lines[0]}" = 'ERROR: Only one of --update, --query allowed.' ]
    [ "${lines[2]%% *}" = 'Usage:' ]
}

