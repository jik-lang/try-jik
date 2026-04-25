#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=.devcontainer/scripts/jik-release.sh
. "$SCRIPT_DIR/jik-release.sh"

tmpdir="$(mktemp -d)"
trap 'rm -rf "$tmpdir"' EXIT

download_file "$JIK_TARBALL_URL" "$tmpdir/$JIK_TARBALL"

mkdir -p /opt/jik "$tmpdir/extract"
tar -xzf "$tmpdir/$JIK_TARBALL" -C "$tmpdir/extract"

shopt -s nullglob
entries=("$tmpdir/extract"/*)

if [ "${#entries[@]}" -eq 1 ] && [ -d "${entries[0]}" ]; then
    cp -a "${entries[0]}"/. /opt/jik/
else
    cp -a "$tmpdir/extract"/. /opt/jik/
fi

chmod +x /opt/jik/jik
