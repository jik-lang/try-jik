#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=.devcontainer/scripts/jik-release.sh
. "$SCRIPT_DIR/jik-release.sh"

ensure_vsix_asset
code --install-extension "$JIK_VSIX_PATH" --force
