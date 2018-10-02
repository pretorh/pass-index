#!/usr/bin/env bash

NAME="pass-index v0.0.1"
INDEX_NAME=.index
UUIDGEN=${PASS_INDEX_UUID_GENERATOR-uuidgen}
GETOPT=${GETOPT?file must be sources by pass or GETOPT env var set}

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
    local args errs opt_generate_length=0
    args="$($GETOPT -o g: -l generate: -n "$NAME" -- "$@")"
    errs=$?
    eval set -- "$args"
    while true; do case $1 in
        -g|--generate) opt_generate_length="$2"; shift 2 ;;
        --) shift; break ;;
    esac done
    [ $errs -ne 0 ] && _cmd_passindex_fail "[-g COUNT|--generate=COUNT]"

    local name id
    read -r -p "enter name: " name
    id="$($UUIDGEN)"

    _cmd_passindex_update_index "$id" "$name"
    if [ "$opt_generate_length" -gt 0 ] ; then
        pass generate "$id" "$opt_generate_length"
    else
        pass insert "$id"
    fi
}

cmd_passindex_show() {
    local args errs opt_clip=""
    args="$($GETOPT -o c -l clip -n "$NAME" -- "$@")"
    errs=$?
    eval set -- "$args"
    while true; do case $1 in
        -c|--clip) opt_clip="--clip"; shift ;;
        --) shift; break ;;
    esac done
    [ $errs -ne 0 ] && _cmd_passindex_fail "[-c|--clip]"

    local name id
    read -r -p "enter name: " name
    id="$(pass show $INDEX_NAME | grep "$name" | awk -F ' ' '{print $1}')"

    pass show "$id" "$opt_clip"
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
