#!/usr/bin/env bash

NAME="pass-index v0.0.1"
INDEX_NAME=.index

((PASS_INDEX_SILENT)) || echo "$NAME" >&2

if [ "$1" = "show" ] ; then
    read -p "enter name: " -r name
    id="$(pass show $INDEX_NAME | grep "$name" | awk -F ' ' '{print $1}')"
    pass show "$id"
elif [ -z "$1" ] ; then
    pass show $INDEX_NAME | awk -F ' ' '{print $2}'
fi
