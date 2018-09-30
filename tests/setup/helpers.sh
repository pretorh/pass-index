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
    name="$(echo "$1" | sed -s 's|_| |g')"

    # run function, fail on first error
    # https://stackoverflow.com/a/33704639/1016377
    set +e
    (set -e; $1)
    error=$?
    set -e

    ((error)) && echo "[FAIL]: $name" && failed=1 && return
    echo "[PASS] $name"
}

finish() {
    ((failed)) && dump_info
    exit $failed
}

trap finish EXIT
