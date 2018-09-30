#!/usr/bin/env bash
set -e
set -o pipefail

# gpg

GNUPGHOME=./tests/.gpg
GPG_OPTS="--passphrase=passphrase --batch --pinentry-mode loopback"
GPG_ID=foo@bar.com
export GNUPGHOME GPG_OPTS GPG_ID

# pass store

PASSWORD_STORE_DIR=$(mktemp -d -t pass-uuid-XXXXXXXX)
PASSWORD_STORE_GPG_OPTS=$GPG_OPTS
export PASSWORD_STORE_DIR PASSWORD_STORE_GPG_OPTS

# helpers

failed=0
dump_info() {
    echo "dump:"
    echo "  GPG_OPTS=$GPG_OPTS"
    echo "  GNUPGHOME=$GNUPGHOME"
    echo "  PASSWORD_STORE_DIR=$PASSWORD_STORE_DIR"
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
