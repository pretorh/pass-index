#!/usr/bin/env bash

NAME="pass-index v0.0.1"

echo "$NAME" >&2

if [ "$1" = "show" ] ; then
    read -p "enter name: " -r name
    id="$(pass show index | grep "$name" | awk -F ' ' '{print $1}')"
    pass show "$id"
elif [ -z "$1" ] ; then
    pass show index
fi
