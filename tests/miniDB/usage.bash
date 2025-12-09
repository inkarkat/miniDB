#!/bin/bash

load fixture

export ACTIONS='--update, --delete, --truncate, --drop, --[read-]command, --each, --query[-keys], --unescape, --start-read-transaction, --start-write-transaction, --upgrade-to-write-transaction, --within-transaction, --end-transaction, --abort-write-transaction'
assert_multiple_actions_error()
{
    assert_line -n 0 "ERROR: Only one of $ACTIONS allowed."
}
