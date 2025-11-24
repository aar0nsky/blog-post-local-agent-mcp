# Maintenance and upgrades

Keeping your local AI development environment healthy ensures that you benefit from performance improvements and security fixes.  This guide covers how to upgrade Docker containers, Ollama, Continue.dev and your MCP server configuration without breaking your existing projects.

## Updating Docker images

MCP servers are packaged as Docker containers.  To update them to the latest available versions, run the following commands from the root of this repository:

```bash
# Pull the latest tags for all services defined in docker-compose.mcp.yaml
docker compose -f docker/docker-compose.mcp.yaml pull

# Recreate containers with the new images
docker compose -f docker/docker-compose.mcp.yaml up -d --build
```

These commands stop and recreate only the containers defined in the `docker/docker-compose.mcp.yaml` file.  If you’ve added additional services to your own compose files, update those similarly.

### Adding a new MCP server

1. **Add the service to Docker Compose** – edit `docker/docker-compose.mcp.yaml` and add a new service definition.  Use either a pre‑built image (e.g. `mcp/fetch`) or build from a custom Dockerfile.
2. **Reference it in your YAML configs** – add the new server under `.continue/mcpServers/server-master.yaml` and whichever agent‑specific files (`agent-dev.yaml`, `agent-docs.yaml`, etc.) make sense.  Use the same `command` and `args` you used in your compose file or specify a `url` if the server is running remotely.
3. **Synchronise JSON config** – update `.continue/mcpServers.json` to mirror your YAML changes.  This ensures tools that read JSON can load the same server list.
4. **Update your Continue config** – if you’ve created a per‑project `.continue/config.json`, ensure the `mcpServers` key points to the updated YAML or JSON file.  Restart the Continue extension or CLI for changes to take effect.

## Updating Ollama and models

Ollama updates frequently.  On Windows and macOS, check for updates in the Ollama UI or download the latest installer from [ollama.com](https://ollama.com).  On Linux, rerun the installation script:

```bash
curl -fsSL https://ollama.com/install.sh | sh
```

To update a model, simply pull the latest tag:

```bash
ollama pull nemotron-9b:q4_k_m
```

You can list installed models with `ollama list` and remove unused models with `ollama rm model-name` to reclaim disk space.  Models live in `%USERPROFILE%\.ollama\models` on Windows or `~/.ollama/models` on Unix.  If you need to store models on a different drive, set `OLLAMA_MODELS` in your environment.

## Updating Continue

### VS Code extension

Open the Extensions panel in VS Code and look for an update button next to **Continue – AI Pair Programmer**.  Click **Update** and reload the window when prompted.  Alternatively, update all extensions at once via the command palette.

### CLI

Update the CLI using npm:

```bash
npm update -g @continuedev/cli
```

Verify the version with `continue --version`.

## Troubleshooting common issues

| Problem | Possible causes & solutions |
| ------- | --------------------------- |
| **MCP server fails to start** | Check that Docker Desktop or the Docker daemon is running.  Run `docker compose ps` to see container status.  Ports may be in use; adjust the service’s `ports:` mapping in `docker-compose.mcp.yaml`. |
| **Out‑of‑memory errors when running models** | 8–9 B models require about 8 GB VRAM.  If you see OOM errors, switch to a smaller model (e.g. `llama3:instruct-8b`) or use a lower‑bit quantization variant. |
| **Continue can’t find MCP servers** | Ensure your `~/.continue/config.json` has the correct `mcpServers` path and that the YAML/JSON file lists the servers you started.  Restart VS Code after changing configuration. |
| **Docker network connectivity issues** | On Windows, WSL2 occasionally resets network interfaces.  Restart Docker Desktop or your machine.  On Linux, check that the `docker` group membership took effect after installation. |

## Changing storage locations

If you need to relocate models, containers or configuration files, update the respective environment variables and paths:

* **Ollama models** – set `OLLAMA_MODELS` to the absolute path of the directory where you want models stored.
* **Docker data** – follow Docker’s documentation to move the default `~/.docker` directory or adjust the location via Docker Desktop’s settings.
* **Continue configuration** – by default, Continue reads `~/.continue/config.json`.  You can instead commit a `.continue/config.json` file to your project and pass `--config` to the CLI to override the location.

## Keeping this repository up to date

This repository is designed to be extended.  If new MCP servers emerge or new best practices appear, update the documentation and scripts accordingly.  When you contribute, follow the same OS‑specific conventions used throughout the docs and maintain backwards compatibility whenever possible.
