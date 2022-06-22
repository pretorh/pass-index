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

fail_on_invalid_sub_command() {
    pass index nonsense && fail "expected command to fail" "pass index nonsense"
    pass index uuid2 && fail "expected to fail" "uuid2 exists, should not print it"
    true
}

allow_version() {
    pass index version >"$LOG_FILE" 2>&1
}

run extention_is_loadable
if PASSWORD_STORE_DIR='' PASSWORD_STORE_EXTENSIONS_DIR='' PASSWORD_STORE_ENABLE_EXTENSIONS=false pass index 2>"$LOG_FILE" ; then
    skip index_file_is_named_different_to_not_clash_with_implicit_show_in_pass "test will incorrectly use system-wide index extension and fail"
else
    run index_file_is_named_different_to_not_clash_with_implicit_show_in_pass
fi
run fail_on_invalid_sub_command
run allow_version
