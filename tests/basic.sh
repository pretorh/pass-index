#!/usr/bin/env bash
source tests/setup/helpers.sh

pass init $GPG_ID

extention_is_loadable() {
    pass uuid
}

run extention_is_loadable
