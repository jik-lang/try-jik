#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JIK_DEVCONTAINER_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
JIK_WORKSPACE_DIR="$(cd "$JIK_DEVCONTAINER_DIR/.." && pwd)"

# shellcheck source=.devcontainer/jik-release.env
. "$JIK_DEVCONTAINER_DIR/jik-release.env"

JIK_RELEASE_BASE_URL="https://github.com/${JIK_REPO}/releases/download/${JIK_VERSION}"
JIK_REPO_ARCHIVE_URL="https://github.com/${JIK_REPO}/archive/refs/tags/${JIK_VERSION}.tar.gz"
JIK_TARBALL="jik-${JIK_VERSION}-linux-x64.tar.gz"
JIK_TARBALL_URL="${JIK_RELEASE_BASE_URL}/${JIK_TARBALL}"
JIK_VSIX="jik-language-tools-${JIK_VERSION}.vsix"
JIK_VSIX_URL="${JIK_RELEASE_BASE_URL}/${JIK_VSIX}"
JIK_VSIX_PATH="${JIK_WORKSPACE_DIR}/.devcontainer/extensions/${JIK_VSIX}"

download_file() {
    local url="$1"
    local output_path="$2"

    mkdir -p "$(dirname "$output_path")"
    curl --fail --location --retry 3 --silent --show-error "$url" --output "$output_path"
}

ensure_vsix_asset() {
    if [ -f "$JIK_VSIX_PATH" ]; then
        return
    fi

    download_file "$JIK_VSIX_URL" "$JIK_VSIX_PATH"
}

sync_examples_from_tag() {
    local tmpdir archive_root
    local -a extracted_dirs

    tmpdir="$(mktemp -d)"
    download_file "$JIK_REPO_ARCHIVE_URL" "$tmpdir/repo.tar.gz"

    tar -xzf "$tmpdir/repo.tar.gz" -C "$tmpdir"
    shopt -s nullglob
    extracted_dirs=("$tmpdir"/*/)
    shopt -u nullglob

    if [ "${#extracted_dirs[@]}" -eq 0 ]; then
        echo "failed to determine extracted archive root for ${JIK_REPO}@${JIK_VERSION}" >&2
        rm -rf "$tmpdir"
        return 1
    fi

    archive_root="${extracted_dirs[0]%/}"

    if [ ! -d "$archive_root/examples" ]; then
        echo "examples/ not found in ${JIK_REPO}@${JIK_VERSION}" >&2
        rm -rf "$tmpdir"
        return 1
    fi

    rm -rf "$JIK_WORKSPACE_DIR/examples"
    mkdir -p "$JIK_WORKSPACE_DIR/examples"
    cp -a "$archive_root/examples"/. "$JIK_WORKSPACE_DIR/examples/"
    rm -rf "$tmpdir"
}
