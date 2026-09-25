#!/usr/bin/env bash
# Removes the /ultra skill and its three subagents.
#
#   bash uninstall.sh                  global:  ~/.gemini/config
#   bash uninstall.sh --project DIR    project: DIR/.agents
set -euo pipefail

USAGE="usage: uninstall.sh [--global | --project DIR]"

case "${1:-}" in
  ""|--global) DEST="$HOME/.gemini/config" ;;
  --project)
    [ -n "${2:-}" ] || { echo "$USAGE" >&2; exit 2; }
    [ -d "$2" ] || { echo "error: not a directory: $2" >&2; exit 2; }
    DEST="$(cd "$2" && pwd -P)/.agents" ;;
  -h|--help) echo "$USAGE"; exit 0 ;;
  *) echo "$USAGE" >&2; exit 2 ;;
esac

# Never delete this repo's own sources.
if [ -n "${BASH_SOURCE[0]:-}" ] && [ -f "${BASH_SOURCE[0]}" ] &&
   [ "$DEST" = "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)/.agents" ]; then
  echo "error: $DEST holds this repo's sources; refusing to delete them" >&2
  exit 1
fi

removed=0
# skills/gemini-ultra is what older releases of this repo installed.
for p in skills/ultra agents/ultra-worker agents/ultra-critic agents/ultra-verifier skills/gemini-ultra; do
  if [ -e "$DEST/$p" ]; then
    rm -rf "$DEST/$p"
    echo "Removed $DEST/$p"
    removed=1
  fi
done
[ "$removed" = 1 ] || echo "Nothing to remove in $DEST"
