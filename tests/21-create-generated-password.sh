#!/usr/bin/env bash
source tests/setup/helpers.sh

init_password_store
echo "passname1" | \
    PASS_INDEX_UUID_GENERATOR="echo uuid1" \
    pass index create --generate 64

can_generate_the_password() {
    pass show uuid1 | grep -E "^.{64}$" \
        || fail "failed to read uuid1, or it is not 64 characters long"
}

run can_generate_the_password
