#!/usr/bin/env bash
#
# GeminiUltra Uninstaller for macOS / Linux
#
set -euo pipefail

TARGET_DIR="$HOME/.gemini/config/skills/gemini-ultra"

if [ -d "$TARGET_DIR" ]; then
    rm -rf "$TARGET_DIR"
    echo -e "\033[1;32m✅ GeminiUltra has been successfully removed from your Antigravity skills.\033[0m"
else
    echo -e "\033[1;33mℹ️ GeminiUltra is not installed in your global skills directory.\033[0m"
fi
