#!/usr/bin/env bash
set +e # *not* -e

echo "fake $(basename "$0") (write to $CLIP_FILE)" >&2
read -r value
echo "$value" > "$CLIP_FILE"
