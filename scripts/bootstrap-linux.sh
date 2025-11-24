#!/usr/bin/env bash
# Bootstraps an Ubuntu/Debian machine for the local LLM + Continue.dev stack.
# Installs Git, Node.js, npm, Python3, Docker Engine, VS Code, Ollama and the Continue CLI.
set -e

echo "[Bootstrap] Updating package lists..."
sudo apt update

echo "[Bootstrap] Installing Git, Node.js, npm, Python3 and curl..."
sudo apt install -y git nodejs npm python3 python3-pip curl

echo "[Bootstrap] Installing Docker Engine..."
sudo apt install -y ca-certificates gnupg
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo usermod -aG docker "$USER"

echo "[Bootstrap] Installing Visual Studio Code..."
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > /tmp/packages.microsoft.gpg
sudo install -o root -g root -m 644 /tmp/packages.microsoft.gpg /etc/apt/trusted.gpg.d/
echo "deb [arch=$(dpkg --print-architecture)] https://packages.microsoft.com/repos/code stable main" | sudo tee /etc/apt/sources.list.d/vscode.list > /dev/null
sudo apt update
sudo apt install -y code

echo "[Bootstrap] Installing Ollama..."
curl -fsSL https://ollama.com/install.sh | sh

echo "[Bootstrap] Installing Continue CLI..."
sudo npm install -g @continuedev/cli

echo "[Bootstrap] Done.  You may need to log out and back in for Docker group changes to take effect." 
echo "Copy ./.continue/config.example.json to ~/.continue/config.json and update the paths." 