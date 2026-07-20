#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=.devcontainer/scripts/jik-release.sh
. "$SCRIPT_DIR/jik-release.sh"

bash "$SCRIPT_DIR/sync-jik-workspace.sh"
packages_dir="${HOME}/.local/share/jik-packages"

if [ ! -d "$packages_dir/.git" ]; then
    mkdir -p "$(dirname "$packages_dir")"
    git clone https://github.com/jik-lang/jik-packages "$packages_dir"
fi

/opt/jik/jik help
gcc --version
echo "Synced try-jik to ${JIK_REPO}@${JIK_VERSION} and configured JIK_PKG_PATH=${packages_dir}. Open README.md to get started."
