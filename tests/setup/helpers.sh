#!/usr/bin/env bash
set -e
set -o pipefail

TESTS="$(pwd)/tests"

# gpg

GNUPGHOME=./tests/.gpg
GPG_OPTS="--passphrase=passphrase --batch --pinentry-mode loopback"
GPG_ID=foo@bar.com
export GNUPGHOME GPG_OPTS GPG_ID

# pass store

PASSWORD_STORE_DIR=$(mktemp -d -t pass-index-XXXXXXXX)
PASSWORD_STORE_GPG_OPTS=$GPG_OPTS
PASSWORD_STORE_EXTENSIONS_DIR=$TESTS/../bin
PASSWORD_STORE_ENABLE_EXTENSIONS=true
export PASSWORD_STORE_DIR PASSWORD_STORE_GPG_OPTS PASSWORD_STORE_EXTENSIONS_DIR PASSWORD_STORE_ENABLE_EXTENSIONS

# helpers

failed=0
tests_run=0

dump_info() {
    echo "dump:"
    echo "  GPG_OPTS=$GPG_OPTS"
    echo "  GNUPGHOME=$(realpath "$GNUPGHOME")"
    echo "  PASSWORD_STORE_DIR=$PASSWORD_STORE_DIR"
    echo "  PASSWORD_STORE_EXTENSIONS_DIR=$(realpath "$PASSWORD_STORE_EXTENSIONS_DIR")"

    echo "files in store directory:"
    find "$PASSWORD_STORE_DIR" -type f -print0 | xargs -0 -Iname echo "  name"
}

run() {
    pretty_name=${1//_/ }
    tests_run=$((tests_run + 1))

    # run function, fail on first error
    # https://stackoverflow.com/a/33704639/1016377
    set +e
    (set -e; $1)
    error=$?
    set -e

    ((error)) && echo "not ok $tests_run $pretty_name" && failed=1 && return
    echo "ok $tests_run $pretty_name"
}

fail() {
    echo "$1" >&2
    echo -e "$2" >&2
    false
}

finish() {
    ((failed)) && dump_info
    true
}

trap finish EXIT

expected_test_count="$(grep -c "^run " "$0")"
echo "1..$expected_test_count"
