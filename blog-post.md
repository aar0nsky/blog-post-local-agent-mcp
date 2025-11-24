# Ditch the Monthly Fees: A More Powerful Alternative to Gemini CLI, Copilot & Claude CLI

## The Rise and Limitations of Cloud-Based AI Assistants

Over the past two years, we've witnessed an explosion of command-line AI assistants. Tools like **gemini-cli**, **GitHub Copilot**, and **Claude-CLI** bring context-aware code generation, refactoring, and research directly to your terminal. However, these come with significant trade-offs:

* **Data Privacy:** Your code is sent to external servers.
* **Recurring Costs:** Monthly subscription fees can add up.
* **Feature Limitations:** You're restricted to the features the provider offers.

In this post, I'll demonstrate how a **purely local stack** built on **Ollama**, **Continue.dev**, and the **Model Context Protocol (MCP)** servers can match or even surpass the capabilities of these paid assistants – all without leaving your machine or incurring recurring costs.

## Why Local LLMs Are Now Powerful Enough

Large language models are no longer exclusive to cloud providers. Advancements in quantization and efficient architectures now enable running high-quality models locally on common hardware. For example, memory breakdowns show that 8–9 billion parameter models comfortably fit within 8 GB of VRAM when quantized to 4 bits. Benchmarks consistently rank models like **NVIDIA’s Nemotron Nano 9B** and **Qwen3 8B** at the forefront of coding performance – meaning you can access world-class coding assistance on a single machine. With a little more headroom (around 12 GB VRAM), you can even utilize larger 13 billion parameter models for enhanced context understanding.

Running models locally is made incredibly easy by tools like **Ollama**. With a simple command (on Linux: `curl -fsSL https://ollama.com/install.sh | sh`; on macOS: drag and drop to Applications; on Windows: install the native executable), Ollama downloads and manages quantized models. Once installed, it starts a lightweight server at `http://localhost:11434`, allowing you to interact with models like `nemotron-9b` via REST or the `ollama` command.

## Architecture Overview: The Power of Three

The core of this setup lies in three key components:

1. **Ollama:** This is your local model engine. It downloads quantized models, handles GPU/CPU inference, and provides a straightforward API.
2. **Continue.dev:** A VS Code extension and CLI that embeds a chat-based AI assistant directly within your editor. Continue allows you to interact with your local LLMs through natural language commands and seamlessly integrates with MCP servers. Installation is as simple as `npm i -g @continuedev/cli`.
3. **Model Context Protocol (MCP) Servers:** MCP is a specification that defines how LLMs can access external tools and data. Servers wrap common tasks – fetching web pages, reading files, executing Git commands, querying databases – providing a unified JSON interface. By connecting MCP servers to Continue, your AI can access virtually any resource without manual copy-pasting.

Together with **VS Code**, these components create a powerful, self-contained development environment where you can write code, ask for refactoring suggestions, or explore APIs – all while ensuring your data remains private.

## Real-World Specs: A Proof of Concept

Here are the specifications of a real development laptop used to create this guide, demonstrating that you don't need a data center for this setup:

| Component          | Specification                                  |
| ------------------ | ---------------------------------------------- |
| **OS**              | Windows 11 (build 22631)                        |
| **CPU**             | Intel Core i7-12700H (14 cores)               |
| **RAM**             | 31.9 GB physical memory                       |
| **GPU**              | NVIDIA GeForce RTX 6650M – 8 GB VRAM + 16 GB shared |
| **Storage**          | 1 TB NVMe SSD                                 |
| **Example LLM Model** | `nemotron-9b` (quantized with Q4_K_M)           |

This configuration comfortably runs 8B-9B parameter models in Ollama, leaving ample resources for your IDE and Docker containers. The GPU's 8GB VRAM allows for large context windows without performance issues. We recommend at least 16GB system RAM and 8GB VRAM for a smooth experience; otherwise, consider smaller 3B-5B models.

## Getting Started: Selecting and Installing Models with Ollama

While Ollama provides a selection of pre-packaged models, the Hugging Face Hub offers a vast collection of **GGUF** checkpoints. Recent updates allow you to run virtually any model from Hugging Face directly in Ollama.

1. **Enable Ollama:** In your Local Apps settings on Hugging Face, enable Ollama.
2. **Choose a Model:** On a model's page on the Hub, select "ollama" from the "Use this model" dropdown. This will generate a command like:
   ```bash
   ollama run hf.co/{username}/{repository}
   ```
3. **Specify Quantization:** To choose a specific quantization scheme (e.g., 4-bit Q4_K_M), append the quant tag:
   ```bash
   ollama run hf.co/bartowski/Llama-3.2-3B-Instruct-GGUF:iq3_m
   ```
4. **Match Model Size to Hardware:** Refer to memory breakdowns to choose models that fit your GPU's VRAM (8GB or 12GB). `Nemotron-9B` and `Qwen3-8B` are highly-rated for coding tasks on an 8GB GPU.

For full control over system prompts, sampling parameters, and chat templates, you can manually download GGUF files from the Hugging Face Hub and create a `Modelfile` to import them into Ollama.

## Step-by-Step: Your Journey to a Local AI Pair-Programmer

Setting up your environment is straightforward. Detailed instructions are in the [environment setup guide](https://github.com/aar0nsky/blog-post-local-agent-mcp/blob/main/docs/environment-setup.md). Here's a high-level overview:

1. **Install Prerequisites:** Ensure you have Git, Docker, Node.js, Python, and VS Code installed (use `winget` on Windows, Homebrew/`apt` on macOS/Ubuntu).
2. **Install Ollama:** Install the platform-specific installer. Verify with `ollama -v` and start the service if needed (it listens on `http://localhost:11434`).
3. **Pull a Model:** Download a model like `ollama pull nemotron-9b:q4_k_m` to get a 9B model that fits in 8GB VRAM. Test with `ollama run nemotron-9b`.
4. **Install Continue:** Install the VS Code extension from the marketplace and the CLI using `npm i -g @continuedev/cli`. Verify the Continue side panel in VS Code.
5. **Set Up MCP Servers:** Run `docker compose -f docker/docker-compose.mcp.yaml up -d` to start essential servers (Fetch, Filesystem, Git, SQLite). Copy `.continue/config.example.json` to your Continue config and update the `mcpServers` path.
6. **Start Coding:** Open your project in VS Code, activate Continue with `Ctrl+Shift+A`, and ask it to refactor or fetch documentation. Everything runs locally, ensuring fast responses and privacy.

## MCP Servers: Unlocking Powerful Capabilities for Local Development

MCP servers are modular microservices that extend the capabilities of your AI. They enable Continue to access and interact with your development environment. Here are some high-value servers to consider:

| Server      | Functionality                                       | Example Prompts                                           |
|-------------|-----------------------------------------------------|-----------------------------------------------------------|
| **Fetch**   | Retrieves content from URLs (API docs, articles).    | "Fetch the API documentation for the payment module."     |
| **Filesystem** | Provides access to your project files.             | "Find all Python files in the `src` directory."           |
| **Git**     | Exposes Git status, diffs, and commit history.      | "Generate a commit message for the latest changes."       |
| **XRAY**    | Performs deep code analysis (call graphs, impact). | "Identify functions that call the database connection."   |
| **SQLite/DB** | Allows querying local databases.                     | "List all users with an order placed in the last week."  |
| **Everything Search** | System-wide file search (Windows).               | "Find all `.js` files containing 'user authentication'."    |
| **Snyk & Sentry** | Integrates security scanning and error monitoring. | "Check for vulnerabilities in our dependencies."           |
| **Oxylabs**  | Powerful web scraping via authenticated proxies.     | "Scrape the latest blog posts from our competitor's site." |

Enable only the servers you need for your workflow.

## Replacing Tasks with Your Local AI Powerhouse

Paid AI assistants excel at summarizing, refactoring, and searching. With this local stack, you can achieve these same tasks privately and without recurring fees:

* **Web Research:** Use the Fetch server to pull content into context and have Continue summarize or extract code examples.
* **Refactoring & Multi-File Edits:** The Filesystem and XRAY servers provide project-wide awareness for refactoring across multiple files.
* **Git Operations:** Generate commit messages, review diffs, and even stage code hunks with the Git server.
* **Database Inspection:** Access your local databases (SQLite) without needing external connections.
* **Security & Error Analysis:** Leverage Snyk and Sentry servers for dependency scanning and error log analysis.

## MCP Servers: Supercharging Your Local AI Workflow

MCP servers are modular components that extend the capabilities of your local LLM. By plugging in servers for common tasks, you give your AI access to a wider range of information and tools without requiring complex integrations or exposing your data.

**Top Picks for Development:**

* **Filesystem:** Access and manipulate project files.
* **Git:** Interact with your version control system.
* **Fetch:** Retrieve information from the web.
* **XRAY:** Perform deep code analysis.

## Getting Started: A Step-by-Step Guide

Setting up your local AI pair-programmer is straightforward:

1. **Install Prerequisites:** Ensure you have Git, Docker, Node.js, Python, and VS Code installed (instructions in [docs/environment-setup.md](https://github.com/aar0nsky/blog-post-local-agent-mcp/blob/main/docs/environment-setup.md)).
2. **Install Ollama:** Follow the platform-specific instructions.
3. **Pull a Model:** Download a quantized model like `nemotron-9b:q4_k_m`.
4. **Install Continue:** Install the VS Code extension and CLI.
5. **Set up MCP Servers:** Start the necessary MCP servers using Docker Compose.
6. **Start Coding:** Open your project in VS Code, invoke Continue, and start asking for help!

## Maintaining and Upgrading Your Local AI Stack

Maintaining your local setup is simple:

* **Docker Updates:** Use `docker compose pull && docker compose up -d`.
* **Ollama Updates:** Refresh your models as needed.
* **Continue Updates:** Update the VS Code extension and CLI.
* **MCP Server Configuration:** Modify the `docker/docker-compose.mcp.yaml` file to add or update servers.

[See the full maintenance guide](https://github.com/aar0nsky/blog-post-local-agent-mcp/blob/main/docs/maintenance-and-upgrades.md) for details.

## Real-World Example: Replacing Common AI Assistant Tasks

Here's how your local stack can replace popular cloud-based AI assistants:

| Task             | Cloud Assistant (e.g., Gemini CLI) | Local Stack (Ollama + Continue + MCP) |
|------------------|-------------------------------------|---------------------------------------|
| Web Research     | `gemini cli whois <url>`            | Fetch MCP server + Continue           |
| Refactoring      | In‑editor code completion and intent‑based refactors (e.g., GitHub Copilot offers in‑IDE suggestions and small refactor hints; cloud assistants can propose edits but often need additional tooling to apply multi‑file changes) | Filesystem + XRAY + Continue         |
| Git Operations   | Commit/PR message generation, diff summarisation and reviewer suggestions (common in GitHub/Copilot tooling and other cloud assistants with SCM integrations) | Git MCP server + Continue              |
| Database Queries | Claude (with database connection)    | SQLite MCP server + Continue          |
| Security Scan    | Copilot                             | Snyk MCP server + Continue            |

Beyond these direct replacements, agents + MCP servers enable higher‑level workflows that show the real power of a local stack. Here are additional examples you can run locally:

| Agent Task | What it does | Benefit |
|------------|--------------|---------|
| Automated PR Triage | An agent reads a pull request, runs unit tests in an isolated environment (via a test MCP), lints changed files, and posts a summary with a recommended label and reviewers. | Saves reviewer time, catches obvious breakages before human review.
| Dependency Upgrade Bot | Agent inspects `requirements.txt`/`package.json`, proposes selective upgrades, runs tests in a sandbox, and opens a draft PR with changelog summary. | Keeps dependencies secure and up to date with minimal manual effort.
| Release Notes Generator | Agent aggregates merged PRs, parses commit messages and changelogs, and generates a human‑friendly `CHANGELOG.md` entry. | Speeds up releases and ensures consistent changelogs.
| Local Canary & Rollback Assistant | Agent runs a small benchmark or smoke tests against the current branch in a disposable container, compares results to `main`, and suggests rollback steps if regressions appear. | Reduces risk of shipping regressions; automates basic performance checks.
| Security Triage & Patch Suggestor | Agent runs Snyk scans, matches findings to known fixes, creates a patch branch, and suggests code edits or dependency pinning. | Shortens the time from vulnerability discovery to remediation.
| Multi‑file Refactor Planner | Agent uses XRAY to map impact, proposes a staged refactor (with diffs), and can apply changes across multiple files via the Filesystem MCP. | Makes large refactors safer and auditable.
| Documentation Bot | Agent inspects public APIs and examples, extracts docstrings and usage examples, and updates `docs/` or generates `README` sections. | Keeps docs in sync with code and lowers friction for contributors.
| CI Flakiness Diagnoser | Agent analyses flaky test patterns over time (via test results stored in SQLite), groups failures by root cause, and suggests which tests to quarantine or fix. | Improves CI signal-to-noise and developer productivity.

Many of these workflows combine multiple MCP servers (Filesystem, Git, Fetch, SQLite, a test runner MCP, Snyk) and can be wired into Continue as agents or scheduled tasks. Because everything runs locally, sensitive code never leaves your environment and you keep full control over automation.

## Ready to Take Control?

This post has shown you a powerful alternative to subscription-based AI assistants. By building your own local stack with Ollama, Continue.dev, and MCP servers, you gain privacy, control, and cost savings.

**Explore the documentation to get started:** [docs/index.md](https://github.com/aar0nsky/blog-post-local-agent-mcp/blob/main/docs/index.md)

**Further exploration:**

* **Write Custom MCP Servers:** Extend the capabilities of your AI.
* **Project-Specific Configurations:** Tailor your setup for individual projects.
* **PoC Demo:** See the local stack in action with a practical example.
```