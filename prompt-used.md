````markdown
You are an expert developer-docs writer and dev-environment architect.

Your job: **create a complete Git repository (returned as a ZIP)** that contains:
1. A long-form Markdown blog post.
2. The exact prompt I’m giving you now (for reproducibility).
3. Supporting docs and config files for a fully local LLM dev environment using:
   - Docker
   - Ollama
   - VS Code
   - continue.dev VS Code extension
   - continue.dev CLI
   - MCP servers running via Docker, configured via `./.continue/mcpServers/*.yaml` and a JSON MCP config file
   - A master list of MCP servers plus per-agent config files

The repo and blog are centered around the idea:
> **“Developers are ditching gemini-cli, copilot, and claude-cli for this more powerful alternative with no monthly fee”**

This “alternative” is: **a purely local, no-monthly-fee LLM toolchain built on Ollama + Continue + MCP servers**.

---

## 0. Constraints & tools you should use

- You already have an existing repo and guide that sets up a local LLM + Continue.dev environment for Windows, macOS, and Ubuntu.
  - **Extend the existing project without breaking anything**:
    - Reuse the structure, tone, and OS-specific style that is already in the guide.
    - Make changes **ADDITIVE** (don’t remove existing sections unless absolutely necessary).
- Use web search and documentation lookup to ensure **all versions and installation steps are up to date** at the time of generation.
- Support **Windows 11, macOS, and Ubuntu/Debian Linux** in all environment setup steps.
- Assume **purely local LLM usage** (no paid API keys, no remote endpoint requirements).
- When you suggest models, pick **Ollama models that fit in ~8–12GB VRAM** and are well-suited to coding (for example, a strong code-optimized 8B–14B model, latest stable versions).
- Use any helpful MCP servers available in this agent environment (including `context7` if present) for research and code generation, but the final repo must **not depend on cloud-only services**.

---

## 1. Machine specs to include in the blog

In the blog and docs, include a short “Example Dev Machine” section with **my actual specs**. Use this template and fill in details where I’ve left placeholders:

- OS: **Windows 11** (example primary machine)
- CPU: `<FILL_IN_CPU_MODEL>`
- RAM: **31.9 GB** physical
- GPU: **RTX 6650 (8GB dedicated VRAM + 16GB shared)**  
- Storage: `<FILL_IN_STORAGE_INFO>`
- Example LLM model: `<CHOSEN_OLLAMA_MODEL_NAME>` (e.g. an 8B–14B code-capable model), **quantized** variant (e.g. `Q4_K_M` or equivalent; pick a current best-practice quantization for my GPU).

In the blog, clearly explain **why these specs are enough** and what minimum specs you recommend for others.

---

## 2. Repository structure & deliverables

Extend the existing repo so that (at minimum) it includes:

- `README.md`
- `blog-post.md` — the main article.
- `prompt-used.md` — a copy of this full prompt.
- `docs/`
  - `environment-setup.md` — full cross-platform setup steps (extend this if it already exists).
  - `maintenance-and-upgrades.md` — how to keep everything updated & healthy.
  - `mcp-servers-guide.md` — explanation of MCP servers, how they’re wired in, and recommended local dev servers.
  - If the existing project has a primary walkthrough like `docs/guide.md` or a detailed `README.md`, treat that as the **main guide** and extend it (see MCP section below).
- `.continue/`
  - `config.example.json` or `config.example.yaml` — example Continue config pointing to local Ollama & MCP servers.
  - `mcpServers/`
    - `server-master.yaml` — a **master list** of MCP servers we want available in *all* configs (e.g. `fetch`).
    - `agent-dev.yaml` — MCP servers for general dev & refactoring.
    - `agent-docs.yaml` — MCP servers for documentation & API exploration.
    - `agent-swe.yaml` — MCP servers tailored to systems & infra tasks.
    - `default.yaml` — see the **“.continue/mcpServers/default.yaml”** section below.
  - `mcpServers.json` — a JSON version of the MCP servers configuration that mirrors the same set of servers defined in `default.yaml` (including Oxylabs).
- `scripts/`
  - Existing bootstrap scripts (if already present), plus:
    - `bootstrap-windows.ps1`
    - `bootstrap-macos.sh`
    - `bootstrap-linux.sh`
    - `install-mcps-windows.ps1`
    - `install-mcps-macos.sh`
    - `install-mcps-ubuntu.sh`
- `docker/`
  - `docker-compose.mcp.yaml` — brings up the MCP servers we’re using.
  - Any minimal `Dockerfile` or configs needed for local-only MCP servers.
- (See Section 10 for extra automation tooling like devcontainers and task runners.)
- `examples/` — used for the demo / proof-of-concept (see Section 10).

Make sure all filenames and paths in docs are internally consistent, and ensure you DO NOT break any existing structure—only extend it.

At the end, **return the entire repo as a ZIP file** plus a short summary of what’s inside.

---

## 3. Content & writing requirements

### 3.1 Blog post (`blog-post.md`)

Write a **clear, opinionated, technical blog post** with the title (or close variant):

> **Developers are ditching gemini-cli, copilot, and claude-cli for this more powerful alternative with no monthly fee**

The tone:  
- Friendly, pragmatic, aimed at **intermediate to advanced developers**.  
- Explain *why* someone would want a fully local stack:
  - Cost (no monthly fee).
  - Privacy.
  - Customization via MCP servers.
  - Offline usability.
- Avoid trashing other tools; instead use **respectful comparison**:
  - Show how this local stack overlaps with and sometimes exceeds what gemini-cli/copilot/claude-cli workflows can do, especially for:
    - Refactoring large codebases locally.
    - Using custom MCP servers to talk to local services/databases/APIs.
    - Extensible per-project configs.

Include sections such as:
1. **Why local LLMs are finally good enough**
2. **Architecture overview: Ollama + Continue + MCP servers + VS Code**
3. **Example Dev Machine: Real-World Specs**
4. **Step-by-step: from blank machine to local AI pair-programmer**
5. **MCP servers as “superpowers”: top picks for local development**
6. **Workflows you can replace from gemini-cli/copilot/claude-cli**
7. **How to maintain and upgrade this setup safely**
8. **Where to go next: custom agents & project-specific MCP configs**

Use **Markdown**, with:
- Headings (`#`, `##`, etc.)
- Code blocks for commands.
- Tables when comparing tools or MCP servers.
- Links to official docs where relevant.

### 3.2 README (`README.md`)

- Give a concise overview of:
  - What the repo is.
  - What the blog covers.
  - Quickstart steps:
    - “If you’re on Windows, run X; on macOS, run Y; on Linux, run Z.”
    - How to open the project in VS Code and enable Continue.
    - How to bring up MCP servers using Docker Compose.
- Include:
  - A small architecture diagram description in text (no actual image needed, but feel free to describe one).
  - A “What’s in this repo” section linking to `blog-post.md` and `docs/*`.

Reuse the tone and formatting style of the existing guide.

---

## 4. Environment setup docs (`docs/environment-setup.md`)

Write or extend an in-depth guide with **separate sections per OS**.

For each OS (Windows 11, macOS, Ubuntu/Debian):

1. **Prerequisites**
   - Package manager (e.g., `winget`/`choco` on Windows, `brew` on macOS, `apt` on Ubuntu/Debian).
   - Git.
2. **Install Docker**
   - Use official installation methods.
   - Call out any OS-specific gotchas (e.g., WSL2 requirements on Windows).
3. **Install Ollama**
   - Official installation instructions.
   - How to **pull the recommended model(s)** and verify they run.
   - Brief note on quantization, VRAM, and my example machine.
4. **Install VS Code**
   - Official instructions or one-liner via package manager.
5. **Install Continue VS Code extension**
   - From the VS Code marketplace.
   - How to confirm it’s installed & enabled.
6. **Install continue.dev CLI**
   - How to install (e.g., via npm, direct download, or instructions from latest docs).
   - How to verify `continue` works from the terminal.
7. **Configure Continue to talk to Ollama & MCP servers**
   - Provide an example config file (`.continue/config.example.json` or `.yaml`) that:
     - Points to a local Ollama endpoint.
     - Lists MCP server configs loaded from `.continue/mcpServers`.
   - Explain where to place the config on each OS (home directory vs workspace folder).

Use clear subsections like:

- `### Windows 11 setup`
- `### macOS setup`
- `### Ubuntu/Debian setup`

For each command block, label the OS it applies to and match the style already used in the existing guide.

---

## 5. MCP servers & Docker (`docker/` and `.continue/mcpServers/`)

### 5.1 Docker Compose for MCP servers

Create or extend a **minimal `docker-compose.mcp.yaml`** that starts a handful of **local-only MCP servers** suitable for development, such as:

- A **fetch/HTTP MCP server**.
- A **filesystem/project MCP server** (read-only or clearly documented).
- A **Git MCP server** that can operate locally.
- Any other top open-source MCP servers that:
  - Work locally.
  - Have straightforward Docker setups.
  - Are useful for local software development (e.g., interacting with local DB, running linters, etc.).

Make sure every service in Docker Compose:
- Has a clear `image` or `build` definition.
- Exposes ports & env vars needed to be referenced by the MCP `server*.yaml` configs.

### 5.2 MCP config files

Create or extend the following YAML configs in `.continue/mcpServers/`:

- `server-master.yaml`  
  - Contains a **master list of “always-on” MCP servers**, including:
    - A `fetch`-style HTTP client MCP server.
    - Any other servers you deem essential for *every* agent (e.g., read-only filesystem, search, etc.).
- `agent-dev.yaml`
  - Tailored for:
    - Reading/writing code locally.
    - Making HTTP calls (e.g., to local test services).
    - Querying local dev DBs (if you include a DB MCP).
- `agent-docs.yaml`
  - Tailored for documentation tasks:
    - Fetching docs from HTTP endpoints.
    - Searching docs repos.
- `agent-swe.yaml`
  - Tailored for system-level / infra / SRE-type tasks:
    - Interacting with Docker.
    - Inspecting logs (if you include such MCPs).
    - Making HTTP calls to local services.

In `docs/mcp-servers-guide.md`, explain:
- What each MCP server does.
- When you’d use `agent-dev` vs `agent-docs` vs `agent-swe`.
- How to **wire them into Continue** (with example snippets from `.continue/config.example.*` and `.continue/mcpServers.json`).

---

## 6. Maintenance & upgrades (`docs/maintenance-and-upgrades.md`)

Document how to keep this environment healthy and current:

- How to **update Docker images**:
  - `docker compose -f docker/docker-compose.mcp.yaml pull`  
  - `docker compose -f docker/docker-compose.mcp.yaml up -d --build`
- How to **update Ollama** and refresh models.
- How to **update Continue** in VS Code and the CLI.
- How to:
  - Add a new MCP server to Docker Compose.
  - Register it in `server-master.yaml` and one of the agent-specific YAMLs.
  - Update `.continue/mcpServers/default.yaml` and `.continue/mcpServers.json`.
- Common troubleshooting tips:
  - Port conflicts.
  - Model OOM (out-of-memory) on smaller GPUs.
  - Continue failing to see MCP servers (misconfigured URLs, etc.).

---

## 7. Top MCP servers to recommend

In `docs/mcp-servers-guide.md` and in the blog, recommend **top MCP servers for local development**. Use up-to-date info from the official awesome MCP server lists and repo docs to pick a **small, high-value set**, for example:

- HTTP/fetch MCP (for calling APIs).
- Filesystem/project MCP.
- Git or GitHub-local MCP (for repo operations).
- Database MCP (Postgres/SQLite or similar) for querying local DBs.
- Everything Search MCP.
- Security and monitoring MCPs (Snyk, Sentry).
- Docs/API search MCPs.
- **Oxylabs MCP** for advanced scraping and data collection (see https://github.com/oxylabs/oxylabs-mcp).

For each recommended MCP, include:
- A short description.
- Why it’s useful in a local dev workflow.
- How it’s wired in via `docker-compose.mcp.yaml` and the `*.yaml` / `.json` MCP configs.

---

## 8. Final output

1. Generate all files listed above with **coherent, consistent content**.
2. Ensure:
   - All paths and filenames referenced in docs actually exist in the repo.
   - All commands are syntactically correct and OS-appropriate.
3. Package the entire repository as a **ZIP file** and include it in your response.
4. Also include a short, human-readable summary of:
   - What’s in the repo.
   - How to get started on each OS in 3–5 bullet points.

Do **not** skip any of the files or docs requested above.

---

## 9. EXTENSION REQUIREMENTS: MCP section, scripts, and default.yaml

You already have an existing repo and guide that sets up a local LLM + Continue.dev environment for Windows, macOS, and Ubuntu.

Your task is to **EXTEND the existing project without breaking anything**:
- Reuse the structure, tone, and OS-specific style that is already in the guide.
- Make changes ADDITIVE (don’t remove existing sections unless absolutely necessary).

### 9.1 Add a new MCP section to the main guide

1. Find the main guide file (for example `docs/guide.md`, `README.md`, or whatever the project uses as the primary walkthrough).
2. Add a **new major section** near the dev-environment / Continue configuration parts:

   > ## Supercharging Continue.dev with MCP Servers (Free, Power-User Stack)

   In this section:
   - Briefly explain what MCP is and why adding MCP servers makes Continue feel closer to paid tools like Copilot/Cursor/Claude Workspace, but local and free.
   - Add one subsection per MCP server listed below:
     - A short “What it does / Why it’s useful”.
     - A bullet list of **example prompts** the user can type into Continue’s agent that explicitly exercise that MCP server.
     - OS-specific installation notes for **Windows 11, macOS, Ubuntu** in the same style as the existing guide (i.e., side-by-side or separate subsections):
       - Windows: use PowerShell and tools like `winget`/`choco` only if they are already used in the guide.
       - macOS: assume Homebrew where appropriate.
       - Ubuntu: use `apt` and standard tools.
   - Make sure each MCP subsection clearly calls out any prerequisites (Docker, Node.js, Python, specific CLIs, services, or tokens).

MCP servers to cover (each gets its own subsection):

1. **Fetch MCP** – HTTP/HTML → clean text/markdown, great for pulling docs and API pages into context.
2. **Filesystem MCP** – read/write project files so the agent can do multi-file edits and refactors.
3. **Git MCP** – git status, diffs, commits, branches via MCP so the agent can manage changes.
4. **XRAY MCP** – deep, AST-based code intelligence (map/find/impact) for large codebases.
5. **GitHub MCP** – integrate with GitHub repos (issues, PRs, code, comments).
6. **Playwright / Browser MCP** – drive a browser for scraping docs, running flows, and basic E2E checks.
7. **Database MCP (SQLite example)** – inspect schema and run safe queries; mention how this can be adapted to Postgres/MySQL.
8. **Everything Search MCP** – fast system-wide search (especially useful on Windows).
9. **Snyk MCP** – security scanning for code and dependencies.
10. **Sentry MCP** – error monitoring + linking production errors back to code and GitHub issues.
11. **Docs / API Search MCP** – generic docs search MCP.
12. **Oxylabs MCP** – proxy-based web scraping & data collection; use https://github.com/oxylabs/oxylabs-mcp as the canonical source of installation and usage instructions.

Follow the existing guide’s formatting conventions (headings, callout boxes, tips, etc.).

---

### 9.2 Add install scripts for all MCP servers (Windows/macOS/Ubuntu)

Create (or extend) a `scripts/` directory if it doesn’t exist and add **one install script per platform**:

- `scripts/install-mcps-windows.ps1`
- `scripts/install-mcps-macos.sh`
- `scripts/install-mcps-ubuntu.sh`

Each script should:

- Install or verify prerequisites:
  - Node.js (LTS)
  - Python 3
  - Docker (and ensure the user knows Docker Desktop / daemon must be running)
  - Any additional tools required by the MCP servers.
- Install or configure **each MCP server listed above** using **official, up-to-date commands from their documentation** (do NOT guess flags; look them up), including:
  - Fetch MCP
  - Filesystem MCP
  - Git MCP
  - XRAY MCP
  - GitHub MCP
  - Playwright / Browser MCP
  - Database MCP (SQLite)
  - Everything Search MCP
  - Snyk MCP
  - Sentry MCP
  - Docs / API Search MCP
  - **Oxylabs MCP** (using instructions from https://github.com/oxylabs/oxylabs-mcp)
- Be idempotent where reasonable (re-running doesn’t break things).
- Include clear comments and `Write-Host`/`echo` messages explaining what is happening.
- For anything requiring credentials (GitHub, Snyk, Sentry, Oxylabs, etc.), instruct the user to set environment variables instead of hardcoding secrets:
  - `GITHUB_TOKEN`
  - `SNYK_TOKEN`
  - `SENTRY_AUTH_TOKEN`
  - `OXYLABS_USERNAME` / `OXYLABS_PASSWORD` or `OXYLABS_API_KEY` (as required by the Oxylabs MCP docs)
  - Any others you need

At the end of each script, print a short “next steps” summary telling the user:
- That the `.continue/mcpServers/default.yaml` and `.continue/mcpServers.json` files exist.
- Which environment variables they still need to set.

Each script must contain **per-OS instructions** using platform-appropriate tools:
- Windows: PowerShell, `winget`/`choco` if the existing guide already uses them.
- macOS: `brew` where appropriate.
- Ubuntu: `apt` and standard tools.

---

### 9.3 Add `.continue/mcpServers/default.yaml` to the project

At the **project root**, create (or update) the file:

`.continue/mcpServers/default.yaml`

Use this structure (you can adjust comments, but keep the same servers):

```yaml
name: Dev Stack
version: 0.0.1
schema: v1

mcpServers:
  # 1) Fetch – HTTP/HTML → clean text
  - name: Fetch MCP server
    command: docker
    args:
      - run
      - -i
      - --rm
      - mcp/fetch
    env: {}

  # 2) Filesystem – project file read/write via Docker
  #    NOTE: The user must replace /ABSOLUTE/PATH/TO/YOUR/PROJECT with their own path.
  - name: Filesystem MCP server
    command: docker
    args:
      - run
      - -i
      - --rm
      - --mount
      - type=bind,src=/ABSOLUTE/PATH/TO/YOUR/PROJECT,dst=/project
      - mcp/filesystem
      - /project
    env: {}

  # 3) Git – local repo operations via Docker
  - name: Git MCP server
    command: docker
    args:
      - run
      - -i
      - --rm
      - --mount
      - type=bind,src=/ABSOLUTE/PATH/TO/YOUR/PROJECT,dst=/repo
      - mcp/git
      - /repo
    env: {}

  # 4) XRAY – deep, AST-based code intelligence
  - name: XRAY Code Intelligence
    # Assumes `xray-mcp` is installed and on PATH
    command: xray-mcp
    args:
      - --root
      - /ABSOLUTE/PATH/TO/YOUR/PROJECT
    env: {}

  # 5) GitHub – GitHub repo/PR/issue integration
  - name: GitHub MCP server
    command: npx
    args:
      - -y
      - "@modelcontextprotocol/server-github"
    env:
      GITHUB_TOKEN: "${GITHUB_TOKEN}"

  # 6) Playwright / Browser – browser automation and scraping
  - name: Playwright Browser MCP server
    command: npx
    args:
      - "@playwright/mcp@latest"
    env: {}

  # 7) Database – SQLite example (user can switch to a different DB)
  - name: SQLite DB MCP server
    command: npx
    args:
      - -y
      - "mcp-sqlite"
      - "./data/dev.db"
    env: {}

  # 8) Everything Search – fast system-wide file search (optional)
  - name: Everything Search MCP server
    command: python
    args:
      - -m
      - src.mcp_server_everything_search
    env:
      EVERYTHING_HTTP_HOST: "127.0.0.1"
      EVERYTHING_HTTP_PORT: "8011"

  # 9) Snyk – security scanning (optional)
  - name: Snyk Security MCP server
    command: "<FILL_FROM_LATEST_SNYK_MCP_DOCS>"
    args: []
    env:
      SNYK_TOKEN: "${SNYK_TOKEN}"

  # 10) Sentry – error monitoring (optional)
  - name: Sentry MCP server
    command: "<FILL_FROM_LATEST_SENTRY_MCP_DOCS_OR_URL>"
    args: []
    env:
      SENTRY_AUTH_TOKEN: "${SENTRY_AUTH_TOKEN}"

  # 11) Docs / API Search – generic docs search MCP
  - name: Docs Search MCP server
    command: "<FILL_FROM_LATEST_DOCS_SEARCH_MCP_DOCS>"
    args: []
    env: {}

  # 12) Oxylabs MCP – proxy-based scraping and data collection
  - name: Oxylabs MCP server
    command: "<FILL_FROM_LATEST_OXYLABS_MCP_DOCS>"
    args: []
    env:
      OXYLABS_USERNAME: "${OXYLABS_USERNAME}"
      OXYLABS_PASSWORD: "${OXYLABS_PASSWORD}"
      OXYLABS_API_KEY: "${OXYLABS_API_KEY}"
```

Also ensure that **the same set of MCP servers, including Oxylabs**, is present in a JSON-based config file at:

* `.continue/mcpServers.json`

For example, create a JSON structure that mirrors `default.yaml` so users who prefer JSON-based configs (or tools that expect JSON) can load the same MCP stack. Reference both `default.yaml` and `mcpServers.json` in the docs and install scripts.

Ensure `default.yaml` and `mcpServers.json` are referenced in your Continue configuration examples and in the “next steps” output from the install scripts.

Do **not** remove or break any existing configs; only extend them.

---

## 10. Extra tooling, automation, and proof-of-concept demo

Based on current best practices for local dev environments and LLM tooling, further improve the DX (developer experience) by:

### 10.1 Devcontainer and task automation

1. **VS Code Devcontainer (optional but preferred if it fits the existing project style)**

   * Add a `.devcontainer/devcontainer.json` (and any supporting files) that:

     * Uses a Docker image (or Dockerfile) with:

       * Node.js LTS
       * Python 3
       * Docker CLI (if feasible)
       * Git
       * Any CLI prerequisites for MCP servers that make sense inside the container.
     * Mounts the project.
     * Optionally runs `scripts/install-mcps-*.sh`/`.ps1` or equivalent during container creation.
   * In `docs/environment-setup.md` and/or the main guide, add a short section:

     * “**Optional: One-click setup with Dev Containers**”
     * Explain how to “Reopen in Container” in VS Code and what’s preconfigured.

2. **Task runner (Makefile or similar)**

   * Add a root-level **`Makefile`** (or `justfile` if more appropriate) with common tasks such as:

     * `make setup` – runs OS-appropriate bootstrap + MCP install instructions (document how to pick the right script).
     * `make mcps-up` – starts MCP servers via `docker-compose.mcp.yaml`.
     * `make mcps-down` – stops MCP servers.
     * `make poc` – runs the PoC demo workflow (see below).
   * Ensure commands are **documented** in `README.md` under a “Common tasks” section.

3. **VS Code workspace recommendations**

   * Add `.vscode/extensions.json` recommending:

     * Continue.dev
     * Docker
     * Markdown tooling (if useful)
   * Optionally add `.vscode/settings.json` for:

     * Suggested default formatter (e.g., Prettier or built-in).
     * Helpful defaults tied to this project (e.g., path to `.continue/config` if relevant).

Where you make design choices (e.g., devcontainer vs no devcontainer, Make vs just), briefly justify them in `docs/maintenance-and-upgrades.md` or `docs/environment-setup.md` so the user understands tradeoffs.

---

### 10.2 Demo / proof-of-concept (PoC) to showcase the stack

Create a small but compelling **demo project** that proves the value of this local MCP-powered setup.

1. **Demo structure**

   * Add an `examples/` folder with something like:

     * `examples/poc-local-ai-workflow/`

       * A small, intentionally messy or partially incomplete codebase (e.g., a simple Node/TypeScript or Python web service).
       * A `README.md` explaining:

         * The scenario (e.g., “refactor this service, add logging, and wire in error handling based on Sentry/Snyk feedback”).
         * How to run the PoC steps.
       * Optional sample data (e.g., `data/dev.db` for the SQLite MCP, or sample logs).

2. **Demo documentation**

   * Add `docs/poc-demo.md` that walks through a realistic workflow showing **how this stack beats just using gemini-cli/copilot/claude-cli**:

     * Example steps:

       1. Use **Filesystem MCP** + Continue to scan and refactor multiple files.
       2. Use **XRAY MCP** to map a feature across the codebase and understand impact of a change.
       3. Use **Git MCP** to stage a clean commit, with an AI-generated commit message.
       4. Use **Docs/API Search MCP** or **Fetch MCP** to pull in API docs relevant to some integration in the sample app.
       5. Optionally:

          * Use **Snyk MCP** to surface a dependency/security issue.
          * Use **Sentry MCP** to correlate a sample error (fake or real) with the code path in the demo.
          * Use **Oxylabs MCP** in a simple example (e.g., scraping a docs page or public site and feeding that into a local coding task).
     * Provide step-by-step **example prompts** for Continue so users can copy/paste them and see the MCPs in action.

   * Include a “Before vs After” section that clearly states:

     * What the code looked like before (messy/incomplete).
     * What it looks like after running through the workflow (refactored, tests added, config improved).

3. **Automation for the PoC**

   * Wire `make poc` (or equivalent task runner command) to:

     * Start MCP services (`make mcps-up`).
     * Provide instructions or echo guidance for:

       * Opening the project in VS Code.
       * Which file to open first.
       * Which prompts to paste into Continue to run the demo.

4. **Call out the PoC in the main blog**

   * In `blog-post.md`, add a section near the end:

     * “**Hands-on: Try the MCP-boosted local stack on a real codebase**”
   * Briefly describe the PoC and link to:

     * `docs/poc-demo.md`
     * `examples/poc-local-ai-workflow/`

This PoC should make it easy for someone to clone the repo, run one or two commands, open VS Code, and then **visually experience** how the MCP stack transforms their workflow, all without paying for Copilot/Cursor/Claude Workspace.

---

````