#!/usr/bin/env bash
source tests/setup/helpers.sh

init_password_store
setup_test_passwords

extention_is_loadable() {
    pass index >"$LOG_FILE"
}

index_file_is_named_different_to_not_clash_with_implicit_show_in_pass() {
    if PASSWORD_STORE_ENABLE_EXTENSIONS='' pass index 2>"$LOG_FILE" ; then
        fail "expected command to fail" "but 'pass index' passed"
    fi
}

run extention_is_loadable
run index_file_is_named_different_to_not_clash_with_implicit_show_in_pass
