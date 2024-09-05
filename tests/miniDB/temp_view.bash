#!/bin/bash

load view_cleanup

temp_view_setup()
{
    initialize_table "$BATS_TEST_NAME" from some-entries
    viewName="$(miniDB --table "$BATS_TEST_NAME" --create-view)"
}

setup()
{
    temp_view_setup
}
