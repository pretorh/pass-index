#!/usr/bin/env bash
source tests/setup/helpers.sh

can_encrypt_and_decrypt_with_the_test_key() {
    echo "hello" \
        | gpg --encrypt -r "$GPG_ID" "${GPG_OPTS[@]}" \
        | gpg --decrypt "${GPG_OPTS[@]}" 2>"$LOG_FILE" \
        | grep "hello" >"$LOG_FILE"
}

run can_encrypt_and_decrypt_with_the_test_key
