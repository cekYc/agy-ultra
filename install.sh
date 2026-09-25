#!/usr/bin/env bash
# Installs the /ultra skill and its three subagents for Google Antigravity.
#
#   bash install.sh                  global:  ~/.gemini/config/skills/ultra + ~/.gemini/config/agents/ultra-*
#   bash install.sh --project DIR    project: DIR/.agents/skills/ultra      + DIR/.agents/agents/ultra-*
#
# Run it from a clone of this repo. When piped from curl it downloads the repo first.
set -euo pipefail

ARCHIVE_URL="https://codeload.github.com/cekYc/GeminiUltra/tar.gz/refs/heads/main"
AGENTS=(ultra-worker ultra-critic ultra-verifier)
USAGE="usage: install.sh [--global | --project DIR]"

case "${1:-}" in
  ""|--global) DEST="$HOME/.gemini/config" ;;
  --project)
    [ -n "${2:-}" ] || { echo "$USAGE" >&2; exit 2; }
    [ -d "$2" ] || { echo "error: not a directory: $2" >&2; exit 2; }
    DEST="$(cd "$2" && pwd -P)/.agents" ;;
  -h|--help) echo "$USAGE"; exit 0 ;;
  *) echo "$USAGE" >&2; exit 2 ;;
esac

SRC=""
if [ -n "${BASH_SOURCE[0]:-}" ] && [ -f "${BASH_SOURCE[0]}" ]; then
  SRC="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)/.agents"
fi
if [ -z "$SRC" ] || [ ! -f "$SRC/skills/ultra/SKILL.md" ]; then
  TMP="$(mktemp -d)"
  trap 'rm -rf "$TMP"' EXIT
  echo "Downloading $ARCHIVE_URL"
  curl -fsSL "$ARCHIVE_URL" | tar -xz -C "$TMP" --strip-components=1
  SRC="$TMP/.agents"
  [ -f "$SRC/skills/ultra/SKILL.md" ] || { echo "error: download has no .agents/skills/ultra/SKILL.md" >&2; exit 1; }
fi

if [ "$SRC" = "$DEST" ]; then
  echo "Source and target are the same ($DEST); nothing to copy."
else
  mkdir -p "$DEST/skills" "$DEST/agents"
  rm -rf "$DEST/skills/ultra"
  cp -R "$SRC/skills/ultra" "$DEST/skills/ultra"
  for a in "${AGENTS[@]}"; do
    rm -rf "$DEST/agents/$a"
    cp -R "$SRC/agents/$a" "$DEST/agents/$a"
  done
fi

# Older releases of this repo installed "gemini-ultra", which also claims /ultra.
if [ -d "$DEST/skills/gemini-ultra" ]; then
  rm -rf "$DEST/skills/gemini-ultra"
  echo "Removed old skill: $DEST/skills/gemini-ultra"
fi

check() { [ -f "$DEST/$1" ] || { echo "error: missing $DEST/$1" >&2; exit 1; }; echo "  $DEST/$1"; }
echo "Installed:"
check skills/ultra/SKILL.md
for a in "${AGENTS[@]}"; do check "agents/$a/agent.md"; done
echo "Open a project in Antigravity and type: /ultra <task>"
