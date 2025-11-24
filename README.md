# Local LLM & Continue.dev Development Stack

This repository provides everything you need to set up a fully local AI pair‑programming workflow without paying for Copilot, Gemini, or Claude.  It extends an existing project for configuring **Ollama**, **Continue.dev**, and a curated set of **Model Context Protocol (MCP) servers** on Windows, macOS and Ubuntu.  You’ll find a detailed blog post, step‑by‑step environment setup instructions, scripts for installing dependencies and MCP servers, Docker Compose configurations, and a hands‑on proof‑of‑concept project.

## Getting started

The quickest way to get up and running depends on your platform.  Full instructions live in [`docs/environment-setup.md`](docs/environment-setup.md), but here’s the short version:

| OS | Quickstart |
| --- | --- |
| **Windows 11** | Run `./scripts/bootstrap-windows.ps1` from PowerShell.  This installs Docker Desktop, Git, VS Code, Node.js, Python and Ollama.  Then run `./scripts/install-mcps-windows.ps1` to install optional MCP servers. |
| **macOS** | Run `bash ./scripts/bootstrap-macos.sh`.  This uses Homebrew to install Git, Docker, VS Code, Node.js, Python and Ollama.  Then run `bash ./scripts/install-mcps-macos.sh` for MCP servers. |
| **Ubuntu/Debian** | Run `bash ./scripts/bootstrap-linux.sh` to install Git, Docker Engine, VS Code, Node.js, Python and Ollama via `apt`.  Then run `bash ./scripts/install-mcps-ubuntu.sh` for MCP servers. |

After your base environment is ready:

1. Pull a model in Ollama, e.g. `ollama pull nemotron-9b` (see blog for recommended models).
2. Start the recommended MCP servers with `docker compose -f docker/docker-compose.mcp.yaml up -d`.
3. Copy `.continue/config.example.json` to `~/.continue/config.json` and edit the endpoints to match your environment (see docs).
4. Open this folder in **Visual Studio Code**, ensure the **Continue** extension is installed, and start coding with your local AI!

## What’s in this repository

* **blog-post.md** – an opinionated article titled *“Developers are ditching gemini‑cli, copilot, and claude‑cli for this more powerful alternative with no monthly fee”*.  It explains why a local stack beats paid tools for many developers and walks through the architecture, setup and workflows.
* **prompt-used.md** – a copy of the entire prompt used to generate this repository (for reproducibility).
* **docs/** – detailed documentation:
  * `environment-setup.md` – cross‑platform installation and configuration guide.
  * `maintenance-and-upgrades.md` – how to keep your tooling, models and MCP servers updated.
  * `mcp-servers-guide.md` – descriptions of recommended MCP servers and example prompts.
  * `poc-demo.md` – a walkthrough for the proof‑of‑concept project.
* **.continue/** – example Continue configuration files and per‑agent MCP server lists.
* **scripts/** – bootstrap and MCP‑installation scripts for each OS.
* **docker/** – Docker Compose file for starting local MCP servers.
* **examples/** – a small demo project to demonstrate the power of a local LLM + MCP stack.
* **.devcontainer/** (optional) – devcontainer configuration for one‑click VS Code setup.
* **Makefile** – convenient tasks for setup and starting MCP servers.

## Supercharging Continue.dev with MCP Servers (Free, Power‑User Stack)

This repository embraces the **Model Context Protocol (MCP)** to give your AI assistant superpowers.  MCP servers expose additional context—files, web pages, databases, git history and more—through simple JSON APIs.  By running these servers locally you allow Continue to perform tasks that normally require paid cloud services.

Below is a summary of some key servers.  See [`docs/mcp-servers-guide.md`](docs/mcp-servers-guide.md) for full descriptions, prompts and installation notes.

| MCP server | What it does | Example prompt |
| -----------|-------------|--------------- |
| **Fetch** | Fetch and convert web pages to markdown | “Fetch the Django ORM docs and summarise the query API.” |
| **Filesystem** | Read/write project files, enabling multi‑file refactors | “Search for TODO comments across the repo.” |
| **Git** | Git status, diffs, commits and branches via MCP | “Show the diff for the current branch and summarise changes.” |
| **XRAY** | Deep AST‑based analysis of your code | “Map all callers of `saveUser`.” |
| **GitHub** | Interact with GitHub issues/PRs | “Summarise open issues labelled ‘bug’.” |
| **Playwright** | Headless browser for scraping or UI flows | “Open my local site and extract the login page title.” |
| **Database (SQLite)** | Query a local SQLite database | “List the tables in `dev.db`.” |
| **Everything Search** | Windows‑only fast file search | “Find all `.env` files on drive C.” |
| **Snyk & Sentry** | Security scanning and error monitoring | “Scan my dependencies for vulnerabilities” / “Fetch the last error in production.” |
| **Docs/API search** | Generic docs search across multiple sources | “Search the Python Requests docs for timeout usage.” |
| **Oxylabs** | Proxy‑enabled scraping of websites | “Scrape the latest Flask release notes and summarise changes.” |
| **Context7** | Retrieves up‑to‑date documentation directly from official sources | “Use Context7 to fetch the latest FastAPI auth docs and summarise them.” |
| **Sequential Thinking** | Helps the model break down tasks and maintain its chain of thought | “Plan the migration from SQLite to PostgreSQL in logical steps.” |

### OS‑specific installation notes

Most MCP servers are distributed via Docker images or npm packages.  Our **install scripts** (`scripts/install-mcps-windows.ps1`, `install-mcps-macos.sh`, `install-mcps-ubuntu.sh`) automate installation across platforms:

* **Windows 11:** Uses PowerShell with `winget` and `npm`.  Installs Node.js, Python, Docker and each MCP server.  Instructs the user to set environment variables (`GITHUB_TOKEN`, `SNYK_TOKEN`, `SENTRY_AUTH_TOKEN`, etc.) for servers requiring credentials.
* **macOS:** Uses Homebrew and `npm`.  Installs Node.js, Python and the MCP packages.  Downloads browser binaries for Playwright.
* **Ubuntu/Debian:** Uses `apt` and `npm`.  Installs dependencies and globally installs MCP servers.  Adds the current user to the `docker` group so Docker can run without `sudo`.

After installing, start the servers with `docker compose -f docker/docker-compose.mcp.yaml up -d` or by letting Continue launch them on demand.  Update your `~/.continue/config.json` to point to the YAML or JSON config file that includes these servers.


Check out the blog post and documentation to learn why this stack might be a better fit for you than proprietary AI assistants.  All setup steps are additive, so existing users of the previous version of this project can update without losing any functionality.
