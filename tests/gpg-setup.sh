#!/usr/bin/env bash
source tests/setup/helpers.sh

# can encrypt/decrypt with the test key
echo "hello" \
    | gpg --encrypt -r $GPG_ID $GPG_OPTS \
    | gpg --decrypt $GPG_OPTS \
    | grep "hello"
