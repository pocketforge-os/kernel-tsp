#!/usr/bin/env bash
# Sign a single artifact with the passphrase-encrypted minisign key.
# Called by .github/workflows/release.yml once per artifact.
#
# Inputs (env):
#   KEY_FILE       — path to the minisign private key file
#   MINISIGN_PASS  — the passphrase
#   ARTIFACT       — path to the file to sign
#   TAG            — the release tag (used as trusted-comment tag)
#
# Produces $ARTIFACT.minisig alongside the artifact.

set -e -o pipefail

: "${KEY_FILE:?KEY_FILE must be set}"
: "${MINISIGN_PASS:?MINISIGN_PASS must be set}"
: "${ARTIFACT:?ARTIFACT must be set}"
: "${TAG:?TAG must be set}"

# minisign -S prompts for the passphrase on a TTY; expect(1) feeds it via env.
# The passphrase is never on argv or in ps output — it lives in the env var
# passed to expect's Tcl runtime.
expect >/dev/null <<'EXPECT_EOF'
log_user 0
set timeout 30
spawn -noecho minisign -S -s $env(KEY_FILE) -m $env(ARTIFACT) -t "PocketForge kernel-tsp $env(TAG)"
expect "Password*"
send -- "$env(MINISIGN_PASS)\r"
expect eof
catch wait result
exit [lindex $result 3]
EXPECT_EOF
