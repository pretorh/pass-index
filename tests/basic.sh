#!/usr/bin/env bash
source tests/setup/helpers.sh

# initialize a pass store with some test data
pass init $GPG_ID
cat <<EOF |
test-uuid example.com
uuid2 example.org
EOF
pass add index --multiline
echo "password for test" | pass add test-uuid --echo
echo "password for 2" | pass add uuid2 --echo

extention_is_loadable() {
    pass index
}

can_show_password_for_an_item_named_on_stdin() {
    echo "example.com" | pass index show | grep "^password for test$"
}

show_all_items_when_no_command_specified() {
    output="$(echo "example" | pass index)"
    count="$(echo "$output" | grep -c "example")"
    [ "$count" -eq 2 ] || fail "invalid count: $count" "$output"
}

run extention_is_loadable
run can_show_password_for_an_item_named_on_stdin
run show_all_items_when_no_command_specified
