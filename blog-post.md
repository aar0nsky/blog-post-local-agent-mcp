# Developers are ditching gemini‑cli, Copilot and Claude‑CLI for this more powerful alternative with no monthly fee

The last two years saw a flurry of command‑line AI assistants.  Tools like **gemini‑cli**, **GitHub Copilot** and **Claude‑CLI** bring context‑aware code generation, refactoring and research directly into your terminal.  But they come with trade‑offs: you’re sending your code to someone else’s servers, you’re paying monthly subscription fees, and you’re limited to whatever feature set those providers expose.

In this post I’ll show you why a **purely local** stack built on **Ollama**, **Continue.dev** and **Model Context Protocol (MCP)** servers can match or even exceed the capabilities of paid assistants—without sending your code off your machine or paying recurring fees.

## Why local LLMs are finally good enough

Large language models are no longer the exclusive domain of cloud providers.  With advances in quantization and efficient architectures, you can now run high‑quality models locally on commodity hardware.  For example, memory breakdowns show that 8–9 B parameter models fit comfortably into 8 GB of VRAM when quantized to 4 bits.  In fact, benchmarks rank **NVIDIA’s Nemotron Nano 9B** and **Qwen3 8B** at the top of coding performance, meaning you can get world‑class coding assistance on a single machine.  If you have a little more headroom—say 12 GB VRAM—you can even step up to 13 B models for larger contexts.

Running models locally isn’t just about hardware.  Tools like **Ollama** make it trivial to download and run quantized models.  On Linux you can install Ollama with a single script (`curl -fsSL https://ollama.com/install.sh | sh`); on macOS you drag the app into your Applications folder; and on Windows you install a native executable that exposes the `ollama` CLI.  Once installed, Ollama spins up a lightweight server at `http://localhost:11434`, so you can pull models like `nemotron-9b` and interact with them via REST or the `ollama` command.

## Architecture overview: Ollama + Continue + MCP servers + VS Code

At the heart of this stack are three components:

1. **Ollama** for local model execution.  It downloads quantized models, manages GPU/CPU inference and exposes a simple API.
2. **Continue.dev** (VS Code extension and CLI) for agentic workflows.  Continue embeds a chat‑based AI assistant directly in VS Code, with commands to run `continue` from the terminal.  Installing the CLI is as easy as `npm i -g @continuedev/cli`.
3. **Model Context Protocol (MCP) servers**.  MCP is a specification for tool endpoints that LLMs can call for context.  Servers wrap common tasks—fetching web pages, reading files, running git commands, querying databases—and present a simple JSON interface.  By plugging MCP servers into Continue, your AI can access everything from your filesystem to online documentation without manual copy‑pasting.

Together with **VS Code**, these components form a self‑contained development environment.  You write code in your editor, talk to Continue’s chat assistant to refactor or explore APIs, and behind the scenes Continue calls local MCP servers to fetch documentation, inspect the git history or search your project.  No data leaves your machine.

## Example Dev Machine: Real‑World Specs

To prove that you don’t need a data‑centre to run this setup, here are the specs of a real development laptop used while writing this guide:

| Component | Specification |
| --------- | ------------ |
| **OS** | Windows 11 (build 22631) |
| **CPU** | Intel Core i7‑12700H (14 cores) |
| **RAM** | 31.9 GB physical memory |
| **GPU** | NVIDIA GeForce RTX 6650 M – 8 GB dedicated VRAM + 16 GB shared |
| **Storage** | 1 TB NVMe SSD |
| **Example LLM model** | `nemotron-9b` quantized using the `Q4_K_M` variant |

This configuration comfortably runs 8 B–9 B models in Ollama while leaving room for your IDE and Docker containers.  The GPU’s 8 GB VRAM means even large context windows fit without swapping.  We recommend at least 16 GB system RAM and 8 GB VRAM for a smooth experience; if you have less, consider using smaller 3–5 B models.

## Selecting models from Hugging Face and installing them with Ollama

Ollama ships with a curated list of models, but the Hugging Face Hub hosts tens of thousands of **GGUF** checkpoints.  Thanks to recent updates you can run **any** of these models directly in Ollama.  To get started, enable **Ollama** under your Local Apps settings on Hugging Face and, on a model page, choose **ollama** from the **Use this model** dropdown.  Hugging Face generates a command like:

```bash
ollama run hf.co/{username}/{repository}
```

Running this command will download the model and start a local server.  To choose a specific quantization scheme—say you prefer 4‑bit Q4_K_M or 8‑bit IQ3_M—append the quant tag after a colon:

```bash
ollama run hf.co/bartowski/Llama-3.2-3B-Instruct-GGUF:iq3_m
```

This instructs Ollama to pick the selected quantization from the GGUF files.  When selecting a model, match the parameter count to your hardware.  Memory breakdowns show that 8–9 B parameter models quantized to 4 bits fit comfortably into 8 GB of VRAM, while 13 B models need around 12 GB.  Benchmarks rank **Nemotron‑9B** and **Qwen3‑8B** among the best coding models, so those are safe bets for an 8 GB GPU.  For example:

```bash
ollama run hf.co/mlabonne/Meta-Llama-3.1-8B-Instruct-abliterated-GGUF:q4_k_m
```

If you prefer full control, you can download a GGUF file manually from the model’s **Files and versions** tab, create a `Modelfile` pointing at the local file and then import it into Ollama with `ollama create <modelname>`.  This process lets you customise the **system prompt**, sampling parameters and chat template.  The Daniel Miessler article linked above shows a complete example of writing a Modelfile and creating a local model.

## Step‑by‑step: from blank machine to local AI pair‑programmer

Setting up your environment is straightforward.  Full instructions are in [`docs/environment-setup.md`](docs/environment-setup.md); here’s the high‑level flow:

1. **Install prerequisites** – Git, Docker, Node.js, Python and VS Code.  On Windows you can use `winget` to install Node (`winget install -e --id OpenJS.NodeJS`) and Python (`winget install -e --id Python.Python.3.9`).  On macOS and Ubuntu use Homebrew or `apt` to install these packages.
2. **Install Ollama** – run the platform‑appropriate installer.  After installation, verify with `ollama -v` and start the service if needed; it will listen at `http://localhost:11434`.
3. **Pull a model** – for example, `ollama pull nemotron-9b:q4_k_m` downloads a quantized 9B model that fits in 8 GB VRAM.  Test it with `ollama run nemotron-9b` to ensure inference works.
4. **Install Continue** – install the VS Code extension via the marketplace and the CLI via npm (`npm i -g @continuedev/cli`).  Launch VS Code and verify that you can open the Continue side panel.
5. **Set up MCP servers** – run `docker compose -f docker/docker-compose.mcp.yaml up -d` to start local servers like Fetch, Filesystem, Git and SQLite.  Then copy `.continue/config.example.json` to your Continue configuration and update the `mcpServers` path.
6. **Start coding** – open your project in VS Code, call up Continue with `Ctrl+Shift+A` (or click its icon), and ask it to refactor a function or fetch API documentation.  Because everything runs locally, responses are fast and privacy‑preserving.

## MCP servers as “superpowers”: top picks for local development

MCP servers are plug‑and‑play microservices that expose context to your AI.  When you ask Continue to “Refactor the database layer” or “Fetch the latest FastAPI documentation,” it calls one or more MCP servers.  Here are a few high‑value servers you should consider enabling (a more complete list lives in [`docs/mcp-servers-guide.md`](docs/mcp-servers-guide.md)):

| Server | What it does | Example prompts |
| ------ | ------------ | --------------- |
| **Fetch** | Fetches a URL and extracts it as markdown.  Use it to pull API docs, blog posts or StackOverflow pages. | “Fetch the FastAPI authentication section and summarise it” |
| **Filesystem** | Provides read/write access to your project files.  Enables multi‑file refactoring and code search via Continue. | “Search for all TODO comments and list their line numbers” |
| **Git** | Exposes git status, diffs and commit history.  Useful for generating commit messages or exploring changes. | “Show me the diff for the last commit and suggest a summary” |
| **XRAY** | Performs deep, AST‑based analysis of your codebase to build call graphs and impact reports. | “Map all functions that call `saveUser`” |
| **SQLite/DB** | Lets the AI query a local database (SQLite by default).  Great for exploring schema or running safe queries. | “List the schema of the `users` table in `dev.db`” |
| **Everything Search** | On Windows, hooks into the Everything search engine for system‑wide file search. | “Find all `.env` files on my system” |
| **Snyk and Sentry** | Integrate security scans and error monitoring into your workflow. | “Scan dependencies for vulnerabilities” or “Show me the stacktrace from yesterday’s error log” |
| **Oxylabs** | Provides powerful, authenticated web scraping via proxies. | “Scrape the latest release notes for Django and extract major changes” |

Because each server runs in its own container or process, you can enable only the ones you need.  For example, if you primarily do back‑end development, you might enable Filesystem, Git, SQLite and Fetch.  If you work on infrastructure, add Snyk, Sentry and Everything Search.

## Workflows you can replace from gemini‑cli/Copilot/Claude‑CLI

Paid AI assistants shine when you need to summarise web pages, refactor code or search docs.  With the local stack, you can achieve the same workflows while keeping your code private and your wallet untouched:

* **Web research** – Instead of running `gemini cli whois <url>`, use the Fetch MCP server to pull content into your context.  Continue can summarise or extract code examples directly from the fetched markdown.
* **Refactoring and multi‑file edits** – The Filesystem and XRAY MCP servers give your model awareness of your whole project.  Ask Continue: “Refactor the logging code into its own module” and watch it propose changes across multiple files.
* **Git operations** – Generate commit messages or review diffs via the Git MCP server.  Continue can even stage hunks of code for you.
* **Database inspection** – For CLI tools like Claude that allow database connections, our SQLite MCP server provides similar capabilities without leaving your local environment.
* **Security scanning and error triage** – Snyk and Sentry MCP servers integrate directly with your dependencies and logs, much like Copilot’s vulnerability detection or Claude’s error tracing.

With these tools, you’re no longer limited to a vendor’s curated feature set—you control which servers are available, and you can even write your own MCP servers for custom workflows.

## How to maintain and upgrade this setup safely

A key advantage of owning your stack is that you control when and how it is upgraded.  The companion document [`docs/maintenance-and-upgrades.md`](docs/maintenance-and-upgrades.md) covers updating Docker images (`docker compose pull && docker compose up -d --build`), refreshing Ollama models and updating Continue itself.  It also explains how to add new MCP servers to `docker/docker-compose.mcp.yaml`, register them in `.continue/mcpServers` and keep your configuration in sync.

## Where to go next: custom agents & project‑specific MCP configs

This repository is just a starting point.  Once you’re comfortable with local LLMs and MCP servers, consider:

* **Writing your own MCP server** – wrap your build system, test runner or internal API in a simple JSON interface so your AI can interact with it.
* **Creating per‑project MCP configs** – the `.continue/mcpServers/agent‑dev.yaml` file shows how to group servers by use case.  You can create your own YAML files for each project or team, enabling only the servers that make sense.
* **Exploring the PoC demo** – the `examples/poc-local-ai-workflow` directory contains a small service with intentional issues.  Follow [`docs/poc-demo.md`](docs/poc-demo.md) to see how the local stack helps you refactor and improve the project.

By the end of this post you should have a clear path away from expensive cloud‑based assistants.  A self‑hosted LLM, Continue.dev and a handful of MCP servers empower you to build sophisticated AI workflows entirely on your own machine.  Dive into the docs to get started!
