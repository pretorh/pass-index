#!/usr/bin/env bash
source tests/setup/helpers.sh

init_password_store
echo "passname1" | pass index create

updates_the_index_file() {
    pass show .index | grep "^uuid1 passname1$" >"$LOG_FILE"
}

run updates_the_index_file
