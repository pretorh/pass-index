#!/usr/bin/env bash

NAME="pass-uuid"

echo "$NAME" >&2

if [ "$1" = "show" ] ; then
    read -p "enter name: " -r name
    id="$(pass show index | grep "$name" | awk -F ' ' '{print $1}')"
    pass show "$id"
fi
