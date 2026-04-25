#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=.devcontainer/scripts/jik-release.sh
. "$SCRIPT_DIR/jik-release.sh"

sync_examples_from_tag
ensure_vsix_asset
