#!/bin/bash

load temp_database

teardown()
{
    miniDB --table "$BATS_TEST_NAME" --drop --view "${viewName:?}" || :
}
