#!/usr/bin/env bash
source tests/setup/helpers.sh

init_password_store
    cat << EOF |
system1
original-password
original-password
EOF
PASS_INDEX_UUID_GENERATOR="echo uuid1" pass index create

opens_password_in_editor() {
  echo "system1" | EDITOR="editor-cat-write" pass index edit 2>>"$LOG_FILE" \
    | grep "original-password" >>"$LOG_FILE" || fail "did not find the password in the edited file"
}

update_password_from_editor_result() {
  export FAKE_EDITOR_NEW_TEXT="updated-password"
  echo "system1" | EDITOR="editor-cat-write" pass index edit >>"$LOG_FILE" 2>&1

  echo "system1" | pass index show \
    | grep "updated-password" >>"$LOG_FILE" || fail "new password not set after editor command"
}

run opens_password_in_editor
run update_password_from_editor_result
