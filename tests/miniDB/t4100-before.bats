#!/usr/bin/env bats

load canned_databases

@test "a command is executed before the iteration" {
    run miniDB --namespace dev --table db --each 'printf "%s-%s\\n" "${COL[0]}" "${COL[2]}"' --before 'echo START'

    [ $status -eq 0 ]
    [ "${#lines[@]}" -eq 4 ]
    [ "${lines[0]}" = 'START' ]
    [ "${lines[1]}" = 'foo-41' ]
}

@test "multiple commands are executed before the iteration, also when one fails" {
    run miniDB --namespace dev --table db --each 'printf "%s-%s\\n" "${COL[0]}" "${COL[2]}"' --before 'echo START' --before false --before 'echo ---'

    [ $status -eq 0 ]
    [ "${#lines[@]}" -eq 5 ]
    [ "${lines[0]}" = 'START' ]
    [ "${lines[1]}" = '---' ]
    [ "${lines[2]}" = 'foo-41' ]
}

@test "variables initialized in the before block can be referenced during iteration" {
    run miniDB --namespace dev --table db --each 'printf "%d: ${P}%s%s%s${S}\\n" "$count" "${COL[0]}" "$sep" "${COL[2]}"; let count+=1' --before 'P=[; S=]' --before 'sep=--' --before 'count=1'

    [ $status -eq 0 ]
    [ "${#lines[@]}" -eq 3 ]
    [ "${lines[0]}" = '1: [foo--41]' ]
    [ "${lines[1]}" = '2: [bar--0]' ]
}

@test "before commands are executed before all iterations" {
    run miniDB --namespace dev --table db --each 'echo "${COL[0]}"' --each 'echo "${COL[2]}"' --before 'echo START' --before 'echo ---'

    [ $status -eq 0 ]
    [ "${#lines[@]}" -eq 8 ]
    [ "${lines[0]}" = 'START' ]
    [ "${lines[1]}" = '---' ]
    [ "${lines[2]}" = 'foo' ]
}
