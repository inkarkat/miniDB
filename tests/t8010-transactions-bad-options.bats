#!/usr/bin/env bats

load temp_database

@test "conflicting (non-)transaction actions print usage error" {
    run miniDB --start-read-transaction T --table some-entries --query foo
    [ $status -eq 2 ]
    [ "${lines[0]}" = 'ERROR: Only one of --update, --delete, --drop, --each, --query[-keys], --unescape, --start-read-transaction, --start-write-transaction, --upgrade-to-write-transaction, --within-transaction, --end-transaction, --abort-write-transaction allowed.' ]
    [ "${lines[2]%% *}" = 'Usage:' ]
}
@test "conflicting transaction actions print usage error" {
    run miniDB --transactional --start-read-transaction T --table some-entries --query foo --update "fox	blah	blah"
    [ $status -eq 2 ]
    [ "${lines[0]}" = 'ERROR: --transactional cannot be combined with the --start-read-transaction|--start-write-transaction|--upgrade-to-write-transaction|--within-transaction|--end-transaction|--abort-write-transaction set, and only one from the set can be given.' ]
    [ "${lines[2]%% *}" = 'Usage:' ]
}

@test "two start actions from the transaction set print usage error" {
    run miniDB --start-write-transaction T --start-read-transaction T --table some-entries --query foo --update "fox	blah	blah"
    [ $status -eq 2 ]
    [ "${lines[0]}" = 'ERROR: --transactional cannot be combined with the --start-read-transaction|--start-write-transaction|--upgrade-to-write-transaction|--within-transaction|--end-transaction|--abort-write-transaction set, and only one from the set can be given.' ]
    [ "${lines[2]%% *}" = 'Usage:' ]
}

@test "start and upgrade actions from the transaction set print usage error" {
    run miniDB --start-read-transaction T --upgrade-to-write-transaction T --table some-entries --query foo --update "fox	blah	blah"
    [ $status -eq 2 ]
    [ "${lines[0]}" = 'ERROR: --transactional cannot be combined with the --start-read-transaction|--start-write-transaction|--upgrade-to-write-transaction|--within-transaction|--end-transaction|--abort-write-transaction set, and only one from the set can be given.' ]
    [ "${lines[2]%% *}" = 'Usage:' ]
}

@test "start and within actions from the transaction set print usage error" {
    run miniDB --start-write-transaction T --within-transaction T --table some-entries --query foo --update "fox	blah	blah"
    [ $status -eq 2 ]
    [ "${lines[0]}" = 'ERROR: --transactional cannot be combined with the --start-read-transaction|--start-write-transaction|--upgrade-to-write-transaction|--within-transaction|--end-transaction|--abort-write-transaction set, and only one from the set can be given.' ]
    [ "${lines[2]%% *}" = 'Usage:' ]
}

@test "within and end actions from the transaction set print usage error" {
    run miniDB --end-transaction T --within-transaction T --table some-entries --query foo --update "fox	blah	blah"
    [ $status -eq 2 ]
    [ "${lines[0]}" = 'ERROR: --transactional cannot be combined with the --start-read-transaction|--start-write-transaction|--upgrade-to-write-transaction|--within-transaction|--end-transaction|--abort-write-transaction set, and only one from the set can be given.' ]
    [ "${lines[2]%% *}" = 'Usage:' ]
}
