#!/usr/bin/env bash
source tests/setup/helpers.sh

pass_store_intialized_correctly() {
    pass init $GPG_ID
    echo "password to insert" | pass add test_init --echo
    pass show test_init | grep "password to insert"
}

run pass_store_intialized_correctly
