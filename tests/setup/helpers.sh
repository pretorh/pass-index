#!/usr/bin/env bash
set -e
set -o pipefail

TESTS="$(pwd)/tests"

# gpg

GNUPGHOME=./tests/.gpg
GPG_OPTS=("--passphrase=passphrase" "--batch" "--pinentry-mode" "loopback")
GPG_ID=foo@bar.com
export GNUPGHOME GPG_OPTS GPG_ID

# pass store

PASSWORD_STORE_DIR=$(mktemp -d -t pass-index-XXXXXXXX)
PASSWORD_STORE_GPG_OPTS=${GPG_OPTS[*]}
PASSWORD_STORE_EXTENSIONS_DIR=$TESTS/../bin
PASSWORD_STORE_ENABLE_EXTENSIONS=true
PASSWORD_STORE_CLIP_TIME=2
export PASSWORD_STORE_DIR PASSWORD_STORE_GPG_OPTS PASSWORD_STORE_EXTENSIONS_DIR PASSWORD_STORE_ENABLE_EXTENSIONS PASSWORD_STORE_CLIP_TIME

# pass index

PASS_INDEX_SILENT=1
export PASS_INDEX_SILENT

# helpers
LOG_FILE=$PASSWORD_STORE_DIR/tests.log
CLIP_FILE=$PASSWORD_STORE_DIR/clipboard.log
PATH="./tests/fake:$PATH"
RUNNING_ON_CI=""
[ "$CI" ] && RUNNING_ON_CI="running on CI"
export LOG_FILE CLIP_FILE PATH RUNNING_ON_CI

init_password_store() {
    pass init $GPG_ID >"$LOG_FILE"
}

setup_test_passwords() {
    # initialize a pass store with some test data
    cat <<EOF |
test-uuid example.com
uuid2 example.org
EOF
    pass add .index --multiline >"$LOG_FILE"
    echo "password for test" | pass add test-uuid --echo
    echo "password for 2" | pass add uuid2 --echo
}

failed=0
tests_run=0

dump_info() {
    echo "dump:"
    echo "  GPG_OPTS=${GPG_OPTS[*]}"
    echo "  GNUPGHOME=$(realpath "$GNUPGHOME")"
    echo "  PASSWORD_STORE_DIR=$PASSWORD_STORE_DIR"
    echo "  PASSWORD_STORE_EXTENSIONS_DIR=$(realpath "$PASSWORD_STORE_EXTENSIONS_DIR")"

    echo "  logfile:"
    sed  's/^/    /' < "$LOG_FILE"

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

skip() {
    pretty_name=${2//_/ }
    tests_run=$((tests_run + 1))
    echo "not ok $tests_run $pretty_name # TODO $1"
}

skip_if() {
    local reason=$1
    local script=$2

    if [ "$reason" ] ; then
        skip "conditionally skipped: $reason" "$script"
    else
        run "$script"
    fi
}

fail() {
    echo "" >&2
    echo "$1" >&2
    if [ "$2" ] ; then
      echo -e "$2" >&2
    fi
    false
}

paste_from_clipboard() {
    echo "reading from fake clip file $CLIP_FILE" >>"$LOG_FILE"
    if [ -f "$CLIP_FILE" ] ; then
        cat "$CLIP_FILE"
    else
        echo -n ""
    fi
}

finish() {
    ((failed)) && dump_info
    true
}

trap finish EXIT

expected_test_count="$(grep -cE "^(run|skip|skip_if) " "$0")"
echo "1..$expected_test_count"
