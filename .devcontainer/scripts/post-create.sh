#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=.devcontainer/scripts/jik-release.sh
. "$SCRIPT_DIR/jik-release.sh"

bash "$SCRIPT_DIR/sync-jik-workspace.sh"
/opt/jik/jik help
gcc --version
echo "Synced try-jik to ${JIK_REPO}@${JIK_VERSION}. Open README.md to get started."
