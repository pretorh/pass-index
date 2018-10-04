#!/usr/bin/env bash
source tests/setup/helpers.sh

init_password_store
cat << EOF |
passname1
password1
password1
EOF
PASS_INDEX_UUID_GENERATOR='echo uuid1' pass index create

updates_the_index_file() {
    pass show .index | grep "^uuid1 passname1$" >"$LOG_FILE"
}

does_not_create_file_named_based_on_password_name() {
    if pass show passname1 >"$LOG_FILE" 2>&1 ; then
        fail "expected no file named passname"
    fi
}

create_file_based_on_uuid() {
    pass show uuid1 >"$LOG_FILE" || \
        fail "expected a file named based on uuid genetator" "but no file named uuid1"
}

passwords_are_readable_as_normal_pass_files() {
    pass show uuid1 | grep "password1" >"$LOG_FILE" || \
        fail "expected password to be readable from generated filename"
}

default_to_using_uuid_for_ids() {
    cat << EOF |
passname2
password2
password2
EOF
    pass index create

    pass show .index | grep -E "^[0-9A-Fa-f-]{36} passname2$" >"$LOG_FILE" \
        || fail "no uuid found for passname2" "$(pass show .index)"
}

cannot_create_another_entry_if_already_exists() {
    failed=0
    cat << EOF |
passname1
password1
password1
EOF
    pass index create || failed=1
    if [ $failed -eq 0 ] ; then
        fail "allowed to create another entry with the exact same name"
    fi
}

run updates_the_index_file
run does_not_create_file_named_based_on_password_name
run create_file_based_on_uuid
run passwords_are_readable_as_normal_pass_files
run default_to_using_uuid_for_ids
run cannot_create_another_entry_if_already_exists
