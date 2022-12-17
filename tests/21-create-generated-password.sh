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

can_copy_to_clipboard() {
    echo "passname2" | \
        PASS_INDEX_UUID_GENERATOR="echo uuid2" pass index create --generate 64 --clip 2>"$LOG_FILE"

    clipboard=$(paste_from_clipboard)
    echo "$clipboard" | grep -E "^.{64}$" >>"$LOG_FILE" \
        || fail "password not found in clipboard" "$clipboard"
}

run can_generate_the_password
skip_if "$RUNNING_ON_CI" can_copy_to_clipboard
