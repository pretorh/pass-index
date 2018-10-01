#!/usr/bin/env bash

NAME="pass-index v0.0.1"
INDEX_NAME=.index
UUIDGEN=${PASS_INDEX_UUID_GENERATOR-uuidgen}

_cmd_passindex_fail() {
    ((PASS_INDEX_SILENT)) || echo "$*" >&2
    exit 1
}

_cmd_passindex_update_index() {
    cat << EOF |
$(pass show $INDEX_NAME 2>/dev/null)
$1 $2
EOF
    pass insert --multiline $INDEX_NAME
}

cmd_passindex_create() {
    local name id
    read -r -p "enter name: " name
    id="$($UUIDGEN)"
    _cmd_passindex_update_index "$id" "$name"
    pass insert "$id"
}

cmd_passindex_show() {
    local name id
    read -r -p "enter name: " name
    id="$(pass show $INDEX_NAME | grep "$name" | awk -F ' ' '{print $1}')"
    pass show "$id"
}

cmd_passindex_list() {
    pass show $INDEX_NAME | awk -F ' ' '{print $2}'
}

if [ -z "$1" ] ; then
    cmd_passindex_list
    exit 0
fi

case "$1" in
    show)           shift; cmd_passindex_show "$@" ;;
    create)         shift; cmd_passindex_create "$@" ;;
    ls)             shift; cmd_passindex_list "$@" ;;
    --version)      shift; echo "$NAME" ;;
    *)              _cmd_passindex_fail "invalid command '$1'" ;
esac
