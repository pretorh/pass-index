#!/usr/bin/env bash
source tests/setup/helpers.sh

pass init $GPG_ID

extention_is_loadable() {
    pass uuid
}

can_show_password_for_an_item_named_on_stdin() {
    echo "test-uuid example.com" | pass add index --echo
    echo "password for test" | pass add test-uuid --echo

    echo "example.com" | pass uuid show | grep "^password for test$"
}

run extention_is_loadable
run can_show_password_for_an_item_named_on_stdin
