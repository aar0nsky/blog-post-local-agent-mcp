# Environment setup: Windows 11, macOS and Ubuntu/Debian

This guide walks you through setting up a complete local AI development environment across Windows 11, macOS and Ubuntu/Debian Linux.  The goal is to get **Ollama**, **Continue.dev**, **VS Code**, **Docker** and the recommended **MCP servers** running on your machine.  If you follow the steps below you’ll end up with the same environment described in the accompanying blog post.

## Prerequisites

Regardless of platform, you’ll need:

* **Git** – used to clone this repository and manage your projects.
* **Docker** – to run MCP servers in isolated containers.
* **Ollama** – for local LLM inference.
* **VS Code** – your primary IDE.
* **Node.js** and **Python 3** – some MCP servers are distributed via npm or Python.
* **Continue.dev** – both the VS Code extension and the CLI.

Most steps below use official installers or package managers.  Whenever possible we prefer cross‑platform scripts (for example the Ollama installation script works on Linux and macOS).  On Windows, we rely on **winget** because it’s available on all modern versions of Windows 11.

### Recommended hardware

While you can experiment with smaller models on lower‑end hardware, we recommend at least **16 GB of system RAM** and **8 GB of dedicated GPU VRAM**.  Quantized 8–9 B models fit comfortably into an 8 GB VRAM GPU, and our example machine (Intel Core i7‑12700H, 31.9 GB RAM, RTX 6650 M) runs the stack with plenty of headroom.  See the blog’s “Example Dev Machine” section for details.

## Choosing models from Hugging Face

Ollama isn’t limited to its built‑in model library—you can run any **GGUF** model published on the Hugging Face Hub.  The Hub hosts tens of thousands of checkpoints, including quantised versions of many open‑source models.  On a model’s page, choose **ollama** from the **Use this model** dropdown and copy the snippet it generates:

```bash
ollama run hf.co/{username}/{repository}
```

Running this command will download the model and start it locally.  To select a particular quantisation scheme (for example `q4_k_m` or `iq3_m`), append it after a colon:

```bash
ollama run hf.co/bartowski/Llama-3.2-3B-Instruct-GGUF:iq3_m
```

**Model sizing tips:** 8–9 B parameter models quantised to 4 bits require roughly **8 GB of VRAM**, while 13 B models need about **12 GB**.  Benchmarks place **Nemotron‑9B** and **Qwen3‑8B** among the top coding models, so they’re good starting points.

If you prefer full control, you can download GGUF files manually.  Download the `.gguf` file from the model’s *Files and versions* tab, create a `Modelfile` pointing at the local file and run `ollama create <your-model-name>`.  This method lets you specify a system prompt, chat template and sampling parameters.

---

## Windows 11 setup

### 1. Install Git, Node.js and Python

Use `winget` to install dependencies from an elevated PowerShell prompt (right‑click **PowerShell** → “Run as Administrator”):

```powershell
winget install -e --id Git.Git
    winget install -e --id OpenJS.NodeJS    # Node.js LTS
    winget install -e --id Python.Python.3.9 # Python 3
```

Winget will prompt you to accept licence agreements.  After installation, restart your terminal to make sure `node` and `python` are on your `%PATH%`.

### 2. Install Docker Desktop

Download and run the **Docker Desktop for Windows** installer.  Accept the defaults and ensure **WSL 2 integration** is enabled.  You may need to reboot after installation.  Once installed, verify Docker is running by opening a new PowerShell window and running:

```powershell
docker version
```

If you see version information for both the client and server, Docker is ready.

### 3. Install Ollama

1. Download `ollama-setup.exe` from Ollama’s Windows releases.  Run the installer and accept the default options.
2. After installation, open PowerShell and run `ollama -v` to verify it’s in your PATH.
3. To download a model, run `ollama pull nemotron-9b:q4_k_m`.  Models are stored under `%USERPROFILE%\.ollama\models`; set the `OLLAMA_MODELS` environment variable to change this location.

### 4. Install Visual Studio Code

Download `VSCodeUserSetup-x64-{version}.exe` from code.visualstudio.com and run it.  The installer adds `code` to your `%PATH%`; restart PowerShell if needed.

### 5. Install the Continue extension

Open VS Code and navigate to the Extensions panel (`Ctrl+Shift+X`).  Search for **“Continue – AI Pair Programmer”** and click **Install**.  You should see a new “Continue” icon on the activity bar once installation completes.

### 6. Install Continue CLI

Install the CLI globally using npm:

```powershell
npm install -g @continuedev/cli
```

Verify installation with:

```powershell
continue --help
```

### 7. Configure Continue

Copy the example config from this repo:

```powershell
New-Item -ItemType Directory -Force -Path "$env:USERPROFILE\.continue"
Copy-Item -Path ".\.continue\config.example.json" -Destination "$env:USERPROFILE\.continue\config.json" -Force
```

Edit `config.json` to ensure the `ollamaBaseUrl` points to `http://localhost:11434` and the `mcpServers` path points into this repository.  See the comments in `config.example.json` for details.

### 8. Start MCP servers

From the repository root, start the default set of MCP servers:

```powershell
docker compose -f docker\docker-compose.mcp.yaml up -d
```

Your local AI stack is now ready.  Open a project in VS Code, click the Continue icon and start chatting!

---

## macOS setup

### 1. Install Homebrew, Git, Node.js and Python

Open Terminal and run:

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew update
brew install git node python3
```

### 2. Install Docker Desktop

Download and install Docker Desktop for macOS.  Follow the GUI wizard and grant necessary permissions.  After installation, verify the daemon is running by executing:

```bash
docker version
```

### 3. Install Ollama

On macOS Sonoma or newer, download the `ollama.dmg` from ollama.com and drag **Ollama.app** into the **Applications** folder.  Launch the app once to start the background service.  Open Terminal and run `ollama -v` to confirm the CLI is available.  If `ollama` is not in your `$PATH`, add a symlink:

```bash
sudo ln -s /Applications/Ollama.app/Contents/MacOS/Ollama /usr/local/bin/ollama
```

Pull and test a model:

```bash
ollama pull nemotron-9b:q4_k_m
ollama run nemotron-9b
```

### 4. Install Visual Studio Code

Install VS Code via Homebrew:

```bash
brew install --cask visual-studio-code
```

Alternatively, download the `.dmg` or `.zip` from code.visualstudio.com and drag the app to **Applications**.  To add the `code` CLI, open VS Code and press `Cmd+Shift+P`, then run **Shell Command: Install 'code' command in PATH**.

### 5. Install the Continue extension

Launch VS Code and search for **Continue – AI Pair Programmer** in the marketplace.  Click **Install** and verify that the Continue panel appears.

### 6. Install Continue CLI

Install globally via npm:

```bash
npm install -g @continuedev/cli
```

Verify with `continue --help`.

### 7. Configure Continue

Copy the example configuration into your home directory:

```bash
mkdir -p "$HOME/.continue"
cp ./.continue/config.example.json "$HOME/.continue/config.json"
```

Edit `config.json` and set `ollamaBaseUrl` to `http://localhost:11434`.  Point `mcpServers` to the `mcpServers.json` file in this repo.

### 8. Start MCP servers

Start the containers using Docker Compose:

```bash
docker compose -f docker/docker-compose.mcp.yaml up -d
```

The local AI environment is now running.  Open your project in VS Code, open the Continue panel and start experimenting.

---

## Ubuntu/Debian setup

### 1. Install Git, Node.js and Python

Update your package lists and install dependencies:

```bash
sudo apt update
sudo apt install -y git nodejs npm python3 python3-pip curl
```

If your distribution doesn’t include the latest Node.js LTS, you can install it via NodeSource or nvm.

### 2. Install Docker Engine

Follow Docker’s official instructions to install Docker Engine on Ubuntu.  In summary:

```bash
sudo apt install -y ca-certificates curl gnupg
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo usermod -aG docker $USER
```

Log out and back in to apply the Docker group membership, then verify with `docker run hello-world`.

### 3. Install Ollama

Install via the official script (works on both Linux and macOS):

```bash
curl -fsSL https://ollama.com/install.sh | sh
```

Alternatively, download the tarball and extract it to `/usr/local`.  After installation, run `ollama serve` in one terminal and verify with `ollama -v`.  Pull a model with `ollama pull nemotron-9b:q4_k_m`.

### 4. Install Visual Studio Code

Download the `.deb` package from code.visualstudio.com and install it via apt, or use Microsoft’s repository.  For example:

```bash
sudo apt install -y wget gpg
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
sudo sh -c 'echo "deb [arch=$(dpkg --print-architecture)] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
sudo apt update
sudo apt install -y code
```

Alternatively, install via snap: `sudo snap install --classic code`.

### 5. Install the Continue extension

Open VS Code and search for **Continue – AI Pair Programmer** in the Extensions panel.  Click **Install**.  The extension may prompt you to install additional dependencies on first run.

### 6. Install Continue CLI

Install globally via npm:

```bash
sudo npm install -g @continuedev/cli
```

Verify with `continue --help`.

### 7. Configure Continue

Copy the example config into your home directory:

```bash
mkdir -p "$HOME/.continue"
cp ./.continue/config.example.json "$HOME/.continue/config.json"
```

Edit `config.json` and adjust the `ollamaBaseUrl` and `mcpServers` path as described for other platforms.

### 8. Start MCP servers

Run Docker Compose to start the containers:

```bash
docker compose -f docker/docker-compose.mcp.yaml up -d
```

You’re now ready to use the local AI stack.  Open a project in VS Code, open Continue and start exploring.

---

## Optional: One‑click setup with Dev Containers

If you prefer to avoid installing Node.js, Python and MCP server dependencies on your host OS, you can use a **Dev Container**.  This repository includes a `.devcontainer/devcontainer.json` that defines a Docker image with all prerequisites installed.  To use it:

1. Install the **Dev Containers** extension in VS Code.
2. Open the command palette and select **Reopen in Container**.
3. VS Code will build the container, install dependencies and mount your workspace automatically.

This approach isolates the AI stack from your host machine and ensures consistent versions across different contributors.
