#!/usr/bin/env bash
source tests/setup/helpers.sh

# initialize a pass store with some test data
init_password_store
cat <<EOF |
test-uuid example.com
uuid2 example.org
EOF
pass add .index --multiline >"$LOG_FILE"
echo "password for test" | pass add test-uuid --echo
echo "password for 2" | pass add uuid2 --echo

extention_is_loadable() {
    pass index >"$LOG_FILE"
}

index_file_is_named_different_to_not_clash_with_implicit_show_in_pass() {
    if PASSWORD_STORE_ENABLE_EXTENSIONS='' pass index 2>"$LOG_FILE" ; then
        fail "expected command to fail" "but 'pass index' passed"
    fi
}

can_show_password_for_an_item_named_on_stdin() {
    echo "example.com" | pass index show \
        | grep "^password for test$" >"$LOG_FILE"
}

show_all_items_when_no_command_specified() {
    output="$(echo "example" | pass index)"
    count="$(echo "$output" | grep -c "example")"
    [ "$count" -eq 2 ] || fail "invalid count: $count" "$output"
}

show_all_items_when_no_command_specified_without_keys() {
    output="$(echo "example" | pass index)"

    # the line is just the password's name
    echo "$output" | grep "^example.com$" > "$LOG_FILE" || fail "no line is just the site name" "$output"
    echo "$output" | grep "^example.org$" > "$LOG_FILE" || fail "no line is just the site name" "$output"

    # and the keys are not specified anywhere
    echo "$output" | grep -v "test-uuid" > "$LOG_FILE" || fail "found uuid" "$output"
    echo "$output" | grep -v "uuid2" > "$LOG_FILE" || fail "found uuid" "$output"
}

run extention_is_loadable
run index_file_is_named_different_to_not_clash_with_implicit_show_in_pass
run can_show_password_for_an_item_named_on_stdin
run show_all_items_when_no_command_specified
run show_all_items_when_no_command_specified_without_keys
