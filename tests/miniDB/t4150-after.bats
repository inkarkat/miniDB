#!/usr/bin/env bats

load fixture
load canned_databases

@test "a command is executed after the iteration" {
    run -0 miniDB --namespace dev --table db --each 'printf "%s-%s\\n" "${COL[0]}" "${COL[2]}"' --after 'echo END'
    assert_equal ${#lines[@]} 4
    assert_line -n 0 'foo-41'
    assert_line -n -1 'END'
}

@test "multiple commands are executed after the iteration, also when one fails" {
    run -0 miniDB --namespace dev --table db --each 'printf "%s-%s\\n" "${COL[0]}" "${COL[2]}"' --after 'echo ---' --after false --after 'echo END'
    assert_equal ${#lines[@]} 5
    assert_line -n 0 'foo-41'
    assert_line -n -2 '---'
    assert_line -n -1 'END'
}

@test "variables set during iteration can be referenced in the after block" {
    run -0 miniDB --namespace dev --table db --each 'let count+=1; printf "%d: %s\\n" "$count" "${COL[0]}"; lastDescription="${COL[1]}"; [ "$firstId" ] || firstId="${COL[0]}"' --after 'echo "total of $count records"' --after 'echo "first ID: $firstId; last description: $lastDescription"'
    assert_equal ${#lines[@]} 5
    assert_line -n 0 '1: foo'
    assert_line -n 1 '2: bar'
    assert_line -n -2 'total of 3 records'
    assert_line -n -1 'first ID: foo; last description: Testing'
}

@test "after commands are executed after all iterations" {
    run -0 miniDB --namespace dev --table db --each 'echo "${COL[0]}"' --each 'echo "${COL[2]}"' --after 'echo ---' --after 'echo END'
    assert_equal ${#lines[@]} 8
    assert_line -n 0 'foo'
    assert_line -n -2 '---'
    assert_line -n -1 'END'
}
