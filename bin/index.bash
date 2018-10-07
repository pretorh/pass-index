#!/usr/bin/env bash

NAME="pass-index v0.0.1"
INDEX_NAME=.index
UUIDGEN=${PASS_INDEX_UUID_GENERATOR-uuidgen}
GETOPT=${GETOPT?file must be sources by pass or GETOPT env var set}

_passindex_fail() {
    ((PASS_INDEX_SILENT)) || echo -e "$*" >&2
    exit 1
}

_passindex_warn_if_unused_param_set() {
    [ -z "$1" ] && return
    ((PASS_INDEX_SILENT)) || echo "warning: $SUBCOMMAND does not use $2" >&2
}

_passindex_update_index() {
    cat << EOF |
$(pass show $INDEX_NAME 2>/dev/null)
$1 $2
EOF
    pass insert --multiline $INDEX_NAME
}

_passindex_list_names() {
    pass show $INDEX_NAME 2>/dev/null | awk -F ' ' '{print $2}'
}

cmd_passindex_create() {
    local name id
    read -r -p "enter name: " name
    id="$($UUIDGEN)"

    if _passindex_list_names | grep "^$name$" >/dev/null ; then
        _passindex_fail "$name is already in the index"
    fi

    _passindex_update_index "$id" "$name"
    if [ ! -z "$OPT_GENERATE_LENGTH" ] ; then
        cmd="pass generate $id $OPT_GENERATE_LENGTH $OPT_CLIP"
        $cmd
    else
        _passindex_warn_if_unused_param_set "$OPT_GENERATE_LENGTH" "generated length"
        _passindex_warn_if_unused_param_set "$OPT_CLIP" "clip"
        pass insert "$id"
    fi
}

cmd_passindex_show() {
    _passindex_warn_if_unused_param_set "$OPT_GENERATE_LENGTH" "generated length"

    local name id
    read -r -p "enter name: " name
    names=$(_passindex_list_names | grep "$name")
    if [ "$(echo "$names" | wc -l)" -gt 1 ] ; then
        _passindex_fail "multiple names match:\\n$names"
        exit 1
    elif [ -z "$names" ] ; then
        _passindex_fail "no items match"
        exit 1
    fi
    id="$(pass show $INDEX_NAME | grep "$name" | awk -F ' ' '{print $1}')"

    pass show "$id" "$OPT_CLIP"
}

cmd_passindex_list() {
    _passindex_warn_if_unused_param_set "$OPT_CLIP" "clip"
    _passindex_warn_if_unused_param_set "$OPT_GENERATE_LENGTH" "generated length"

    _passindex_list_names
}

_passindex_parse_args() {
    local args errs
    args="$($GETOPT -o cg: -l clip,generate: -n "$NAME" -- "$@")"
    errs=$?
    eval set -- "$args"
    while true; do case $1 in
        -c|--clip)          OPT_CLIP="--clip"; shift ;;
        -g|--generate)      OPT_GENERATE_LENGTH="$2"; shift 2 ;;
        --) shift; break ;;
    esac done
    [ $errs -ne 0 ] && _passindex_fail "[show|create|ls|--version] [-c|--clip] [-g COUNT|--generate=COUNT]"
    SUBCOMMAND=$1
}

SUBCOMMAND=
OPT_GENERATE_LENGTH=
OPT_CLIP=
_passindex_parse_args "$@"

if [ -z "$SUBCOMMAND" ] ; then
    cmd_passindex_list
    exit 0
fi

case "$SUBCOMMAND" in
    show)           shift; cmd_passindex_show ;;
    create)         shift; cmd_passindex_create ;;
    ls)             shift; cmd_passindex_list ;;
    --version)      shift; echo "$NAME" ;;
    *)              _passindex_fail "invalid command '$SUBCOMMAND'" ;
esac
