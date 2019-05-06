#!/bin/bash

export XDG_CONFIG_HOME="$BATS_TMPDIR"

clean_table()
{
    rm -f "${XDG_CONFIG_HOME}/${1:?}"
}

initialize_table()
{
    [ "$2" = from ] || exit 2
    cp -f "${BATS_TEST_DIRNAME}/databases/${3:?}" "${XDG_CONFIG_HOME}/${1:?}"
}

dump_table()
{
    sed >&3 -e 's/^/#/' -- "${XDG_CONFIG_HOME}/${1:?}"
}

assert_table_row()
{
    [ "$(sed -n -e "${2:?}p" "${XDG_CONFIG_HOME}/${1:?}")" = "${3?}" ]
}
