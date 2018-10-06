#!/usr/bin/env bash
source tests/setup/helpers.sh

init_password_store
setup_test_passwords

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

ls_command_also_shows_password_named_without_keys() {
    output="$(echo "example" | pass index ls)"

    echo "$output" | grep "^example.com$" > "$LOG_FILE" || fail "no line is just the site name" "$output"
    echo "$output" | grep "^example.org$" > "$LOG_FILE" || fail "no line is just the site name" "$output"
    echo "$output" | grep -v "test-uuid" > "$LOG_FILE" || fail "found uuid" "$output"
    echo "$output" | grep -v "uuid2" > "$LOG_FILE" || fail "found uuid" "$output"
}

can_copy_password_to_clipboard() {
    echo "example.com" | pass index show --clip

    pasted="$(paste_from_clipboard)"
    echo "$pasted" | grep "^password for test$" >"$LOG_FILE" \
        || fail "did not copy password to clipboard" "$pasted"
}

run can_show_password_for_an_item_named_on_stdin
run show_all_items_when_no_command_specified
run show_all_items_when_no_command_specified_without_keys
run ls_command_also_shows_password_named_without_keys
run can_copy_password_to_clipboard
