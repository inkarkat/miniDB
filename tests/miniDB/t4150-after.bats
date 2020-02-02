#!/usr/bin/env bats

load canned_databases

@test "a command is executed after the iteration" {
    run miniDB --namespace dev --table db --each 'printf "%s-%s\\n" "${COL[0]}" "${COL[2]}"' --after 'echo END'

    [ $status -eq 0 ]
    [ "${#lines[@]}" -eq 4 ]
    [ "${lines[0]}" = 'foo-41' ]
    [ "${lines[-1]}" = 'END' ]
}

@test "multiple commands are executed after the iteration, also when one fails" {
    run miniDB --namespace dev --table db --each 'printf "%s-%s\\n" "${COL[0]}" "${COL[2]}"' --after 'echo ---' --after false --after 'echo END'

    [ $status -eq 0 ]
    [ "${#lines[@]}" -eq 5 ]
    [ "${lines[0]}" = 'foo-41' ]
    [ "${lines[-2]}" = '---' ]
    [ "${lines[-1]}" = 'END' ]
}

@test "variables set during iteration can be referenced in the after block" {
    run miniDB --namespace dev --table db --each 'let count+=1; printf "%d: %s\\n" "$count" "${COL[0]}"; lastDescription="${COL[1]}"; [ "$firstId" ] || firstId="${COL[0]}"' --after 'echo "total of $count records"' --after 'echo "first ID: $firstId; last description: $lastDescription"'

    [ $status -eq 0 ]
    [ "${#lines[@]}" -eq 5 ]
    [ "${lines[0]}" = '1: foo' ]
    [ "${lines[1]}" = '2: bar' ]
    [ "${lines[-2]}" = 'total of 3 records' ]
    [ "${lines[-1]}" = 'first ID: foo; last description: Testing' ]
}

@test "after commands are executed after all iterations" {
    run miniDB --namespace dev --table db --each 'echo "${COL[0]}"' --each 'echo "${COL[2]}"' --after 'echo ---' --after 'echo END'

    [ $status -eq 0 ]
    [ "${#lines[@]}" -eq 8 ]
    [ "${lines[0]}" = 'foo' ]
    [ "${lines[-2]}" = '---' ]
    [ "${lines[-1]}" = 'END' ]
}
