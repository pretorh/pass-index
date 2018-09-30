#!/usr/bin/env bash
source tests/setup/helpers.sh

pass_store_intialized_correctly() {
    init_password_store
    echo "password to insert" | pass add test_init --echo
    pass show test_init | grep "password to insert" >"$LOG_FILE"
}

run pass_store_intialized_correctly
