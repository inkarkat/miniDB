#!/usr/bin/env bats

load fixture
load canned_databases

@test "a command is executed before the iteration" {
    run -0 miniDB --namespace dev --table db --each 'printf "%s-%s\\n" "${COL[0]}" "${COL[2]}"' --before 'echo START'
    assert_equal ${#lines[@]} 4
    assert_line -n 0 'START'
    assert_line -n 1 'foo-41'
}

@test "multiple commands are executed before the iteration, also when one fails" {
    run -0 miniDB --namespace dev --table db --each 'printf "%s-%s\\n" "${COL[0]}" "${COL[2]}"' --before 'echo START' --before false --before 'echo ---'
    assert_equal ${#lines[@]} 5
    assert_line -n 0 'START'
    assert_line -n 1 '---'
    assert_line -n 2 'foo-41'
}

@test "variables initialized in the before block can be referenced during iteration" {
    run -0 miniDB --namespace dev --table db --each 'printf "%d: ${P}%s%s%s${S}\\n" "$count" "${COL[0]}" "$sep" "${COL[2]}"; let count+=1' --before 'P=[; S=]' --before 'sep=--' --before 'count=1'
    assert_equal ${#lines[@]} 3
    assert_line -n 0 '1: [foo--41]'
    assert_line -n 1 '2: [bar--0]'
}

@test "before commands are executed before all iterations" {
    run -0 miniDB --namespace dev --table db --each 'echo "${COL[0]}"' --each 'echo "${COL[2]}"' --before 'echo START' --before 'echo ---'
    assert_equal ${#lines[@]} 8
    assert_line -n 0 'START'
    assert_line -n 1 '---'
    assert_line -n 2 'foo'
}
