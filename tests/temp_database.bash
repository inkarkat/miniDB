#!/bin/bash

export XDG_CONFIG_HOME="$BATS_TMPDIR"

assert_table_row()
{
    [ "$(sed -n -e "${2:?}p" "${XDG_CONFIG_HOME}/${1:?}")" = "${3?}" ]
}
