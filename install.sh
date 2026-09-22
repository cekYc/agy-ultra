#!/usr/bin/env bash
#
# GeminiUltra 1-Click Installer for macOS / Linux (Google Antigravity)
# Powered by Gemini 3.8 Flash (High Reasoning)
#
set -euo pipefail

REPO_URL="https://github.com/cekYc/GeminiUltra.git"
GLOBAL_SKILLS_DIR="$HOME/.gemini/config/skills"
TARGET_DIR="$GLOBAL_SKILLS_DIR/gemini-ultra"

echo ""
echo -e "\033[1;36m===========================================================\033[0m"
echo -e "\033[1;36m   🚀 Installing GeminiUltra for Google Antigravity        \033[0m"
echo -e "\033[0;36m   Powered by Gemini 3.8 Flash (High Reasoning)            \033[0m"
echo -e "\033[1;36m===========================================================\033[0m"
echo ""

# Ensure target directory exists
echo -e "\033[1;33m[1/3] Preparing global skills directory...\033[0m"
mkdir -p "$GLOBAL_SKILLS_DIR"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd || echo "")"
LOCAL_SOURCE="$SCRIPT_DIR/.agents/skills/gemini-ultra"

if [ -n "$SCRIPT_DIR" ] && [ -d "$LOCAL_SOURCE" ]; then
    echo -e "\033[1;33m[2/3] Installing from local repository...\033[0m"
    rm -rf "$TARGET_DIR"
    cp -r "$LOCAL_SOURCE" "$TARGET_DIR"
else
    echo -e "\033[1;33m[2/3] Downloading latest GeminiUltra release from GitHub...\033[0m"
    TMP_DIR=$(mktemp -d)
    trap 'rm -rf "$TMP_DIR"' EXIT
    git clone --depth 1 "$REPO_URL" "$TMP_DIR" --quiet
    rm -rf "$TARGET_DIR"
    cp -r "$TMP_DIR/.agents/skills/gemini-ultra" "$TARGET_DIR"
fi

echo -e "\033[1;33m[3/3] Validating installation...\033[0m"
if [ -f "$TARGET_DIR/SKILL.md" ]; then
    echo ""
    echo -e "\033[1;32m✅ GeminiUltra successfully installed!\033[0m"
    echo -e "\033[0;37m📁 Installed at: $TARGET_DIR\033[0m"
    echo ""
    echo -e "\033[1;36m💡 How to use:\033[0m"
    echo -e "   1. Open Google Antigravity (IDE or CLI)."
    echo -e "   2. Type in chat: \033[1;33m/ultra <your task here>\033[0m"
    echo -e "   3. Enjoy multi-agent high-effort reasoning!"
    echo ""
else
    echo -e "\033[1;31m❌ Installation failed. Please check network connectivity.\033[0m" >&2
    exit 1
fi
