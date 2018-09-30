#!/usr/bin/env bash
set -e

# setup a test gpg home directory and create a secret key
# based on https://gist.github.com/pretorh/0a4a8192e0b8e8c9a7b574ec1c824224
GNUPGHOME=$1
export GNUPGHOME

rm -rf "$GNUPGHOME"
mkdir -pv "$GNUPGHOME"
chmod 700 "$GNUPGHOME"

cat << EOF | gpg --batch --gen-key
Key-Type: RSA
Name-Email: foo@bar.com
Passphrase:passphrase
EOF
