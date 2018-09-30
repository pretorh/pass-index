#!/usr/bin/env bash
set -e

GNUPGHOME=./tests/.gpg
GPG_OPTS="--passphrase=passphrase --batch --pinentry-mode loopback"
GPG_ID=foo@bar.com
export GNUPGHOME GPG_OPTS GPG_ID
