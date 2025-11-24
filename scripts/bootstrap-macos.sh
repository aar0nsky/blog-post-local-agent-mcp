#!/usr/bin/env bash
# Bootstraps a macOS machine for the local LLM + Continue.dev stack.
# Installs Homebrew (if missing), Git, Node.js, Python3, Docker Desktop, VS Code,
# Ollama and the Continue CLI.
set -e

echo "[Bootstrap] Checking for Homebrew..."
if ! command -v brew >/dev/null 2>&1; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  echo "export PATH=\"/opt/homebrew/bin:$PATH\"" >> "$HOME/.bash_profile"
  export PATH="/opt/homebrew/bin:$PATH"
fi

echo "[Bootstrap] Updating Homebrew..."
brew update

echo "[Bootstrap] Installing core packages..."
brew install git node python3

echo "[Bootstrap] Installing Visual Studio Code..."
brew install --cask visual-studio-code

echo "[Bootstrap] Installing Docker Desktop..."
brew install --cask docker

echo "[Bootstrap] Installing Ollama..."
if [ ! -d "/Applications/Ollama.app" ]; then
  curl -L "https://ollama.com/download/ollama-macos.dmg" -o /tmp/ollama.dmg
  hdiutil attach /tmp/ollama.dmg -quiet
  cp -R "/Volumes/Ollama/Ollama.app" /Applications/
  hdiutil detach "/Volumes/Ollama" -quiet
fi
if ! command -v ollama >/dev/null 2>&1; then
  sudo ln -s /Applications/Ollama.app/Contents/MacOS/Ollama /usr/local/bin/ollama
fi

echo "[Bootstrap] Installing Continue CLI..."
npm install -g @continuedev/cli

echo "[Bootstrap] Done.  Copy ./.continue/config.example.json to ~/.continue/config.json and adjust paths." 