#!/usr/bin/env bats

load fixture
load temp_database

@test "update with a new key and numerical column does not output anything when omitting the key" {
    initialize_table "$BATS_TEST_NAME" from one-entry

    run -0 miniDB --table "$BATS_TEST_NAME" --update 'quux' --column '1=This has been added' --columns \*
    assert_output ''
}

@test "update of an existing key prints the previous columns omitting the key" {
    initialize_table "$BATS_TEST_NAME" from one-entry

    run -0 miniDB --table "$BATS_TEST_NAME" --update "foo	A Foo has been updated	43" --columns \*
    assert_output 'The Foo is here	42'
}

@test "update of an existing key and numeric column prints the previous columns omitting the key" {
    initialize_table "$BATS_TEST_NAME" from one-entry

    run -0 miniDB --table "$BATS_TEST_NAME" --update 'foo' --column "2=77" --columns \*
    assert_output 'The Foo is here	42'
}

@test "increment of existing multiline record prints the previous columns omitting the key" {
    initialize_table "$BATS_TEST_NAME" from multiline-schema

    run -0 miniDB --table "$BATS_TEST_NAME" --update bar --column COUNT++ --columns \*
    assert_output - <<'EOF'
A man

walks in\to a	21	with one
newline and \ backslash
EOF
}

@test "increment of existing key with space prints the previous columns omitting the key" {
    initialize_table "$BATS_TEST_NAME" from multiline-schema

    run -0 miniDB --table "$BATS_TEST_NAME" --update 'o O' --column 2++ --columns \*
    assert_output 'An ID with space in it'
}

@test "update of an existing key without columns prints the previous columns omitting the key" {
    initialize_table "$BATS_TEST_NAME" from multiline-schema

    run -0 miniDB --table "$BATS_TEST_NAME" --update empty --column 'COUNT=000' --column 'NOTES=skipping the description' --columns \*
    assert_output ''
}
