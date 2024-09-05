#!/bin/bash

load temp_database

setup()
{
    initialize_table "$BATS_TEST_NAME" from some-entries
    viewName="$(miniDB --table "$BATS_TEST_NAME" --create-view)"
}

teardown()
{
    miniDB --table "$BATS_TEST_NAME" --drop --view "${viewName:?}"
}
