# MCP servers guide

Model Context Protocol (MCP) servers are small services that provide context to large language models.  Continue.dev can call these servers to perform tasks such as fetching web pages, reading files, analysing code structures, querying databases or scanning dependencies.  By running MCP servers locally you avoid leaking data to third‑party services while still giving your AI assistant rich capabilities.

This guide describes the core servers configured in this repository, explains why you might choose each one and shows example prompts you can use within Continue.  It also explains how to wire these servers into Continue via the YAML and JSON configuration files found in `.continue/mcpServers/`.

## Server categories

The servers are organised into three agent groupings:

* **agent‑dev** – used for everyday development: reading/writing code, inspecting git history, searching the filesystem and querying local databases.
* **agent‑docs** – focused on documentation and research: fetching web pages, scraping docs and searching API references.
* **agent‑swe** – tailored for system and infrastructure tasks: running shells, inspecting containers, monitoring logs and scanning dependencies.

All agents inherit from **server‑master**, which lists servers that should always be available (Fetch, Filesystem, Git).  You can customise or extend these YAML files to suit your projects.

## Recommended MCP servers

Below are the servers we recommend enabling for local development.  For each server we provide a short description, example prompts and notes on installation.  See `docker/docker-compose.mcp.yaml` for the Docker Compose definitions and `.continue/mcpServers/*.yaml` for how these servers are referenced from Continue.

### Fetch

* **Description:** Fetches a URL and extracts HTML into clean Markdown.  This is ideal for pulling API docs, blog posts or code samples into your AI’s context.  The Docker image is `mcp/fetch`, which you can run via `docker run -i --rm mcp/fetch`.
* **Example prompts:**
  - “Fetch the Flask quickstart guide and summarise the configuration section.”
  - “Retrieve the GitHub README for `psf/requests`.”
* **Installation notes:** The `fetch` server is a Docker image, so no host dependencies are required beyond Docker itself.  It is already included in `docker/docker-compose.mcp.yaml`.

### Filesystem

* **Description:** Gives the model read/write access to your project directory.  It enables multi‑file refactoring, search and editing operations.  The Docker version (`mcp/filesystem`) runs in a container and mounts your project directory as a volume.
* **Example prompts:**
  - “Find all TODO comments in the repository and list the file names.”
  - “Write unit tests for `utils.py` and create a new `tests/test_utils.py` file.”
* **Installation notes:** You don’t need to install anything on the host.  In `default.yaml` we mount your project directory into the container.  Replace `/ABSOLUTE/PATH/TO/YOUR/PROJECT` in the YAML with your local path.

### Git

* **Description:** Wraps common git operations such as `status`, `diff`, `commit` and `log`.  This allows your AI assistant to generate commit messages, summarise changes or explore branches without leaving VS Code.
* **Example prompts:**
  - “Show me the diff for the last commit.”
  - “Generate a conventional commit message for the staged changes.”
* **Installation notes:** The `mcp/git` Docker image mounts your repository directory.  Ensure the `--mount` path in `default.yaml` points to the root of your project.

### XRAY (Code Intelligence)

* **Description:** Performs deep static analysis of your codebase.  XRAY builds abstract syntax trees (ASTs) and call graphs so that the model can perform operations like “map,” “find” and “impact.”
* **Example prompts:**
  - “Map all functions that call `saveUser`.”
  - “Find the definition of `calculate_checksum` and list its callers.”
  - “If I change the return type of `getUserById`, what parts of the code will break?”
* **Installation notes:** XRAY is not distributed as a container.  Install it globally via npm: `npm install -g xray-mcp`.  On Windows use PowerShell and `npm -g`; on macOS and Linux you can run the same command.  The executable `xray-mcp` must be on your `PATH`; `default.yaml` assumes this.

### GitHub

* **Description:** Integrates with GitHub repositories, issues and pull requests.  Your AI assistant can fetch issue descriptions, summarise PRs or cross‑reference code.
* **Example prompts:**
  - “Fetch open issues labelled bug in this repository.”
  - “Summarise the latest pull request in `owner/repo`.”
* **Installation notes:** The GitHub MCP server is installed via npm: `npm install -g @modelcontextprotocol/server-github`.  It requires a [GitHub personal access token](https://github.com/settings/tokens) stored in the `GITHUB_TOKEN` environment variable.  See the install scripts for setting this variable.

### Playwright / Browser

* **Description:** Provides a headless browser via Playwright, allowing the agent to navigate pages, scrape dynamic content or run simple end‑to‑end flows.
* **Example prompts:**
  - “Open `https://fastapi.tiangolo.com/` and extract the navigation sidebar.”
  - “Fill out the login form on a local dev site and capture the resulting page title.”
* **Installation notes:** Install via npm: `npm install -g @playwright/mcp`.  The first run may download browser binaries.  On macOS and Linux you might need to run with `sudo` or set execution permissions.

### Database (SQLite example)

* **Description:** Exposes a SQLite database to your model.  The example uses the `mcp-sqlite` package to query `./data/dev.db`.  You can adapt this to PostgreSQL or MySQL by switching to other MCP servers.
* **Example prompts:**
  - “List all tables in the database.”
  - “Select the latest 10 records from the `users` table.”
* **Installation notes:** Install via npm: `npm install -g mcp-sqlite`.  The server accepts the path to your `.db` file as an argument (see `default.yaml`).

### Everything Search

* **Description:** A Windows‑only server that wraps the [Everything](https://www.voidtools.com/) search engine.  It provides lightning‑fast file search across your entire drive.
* **Example prompts:**
  - “Find all files named `.env` anywhere on the C: drive.”
  - “Search for files modified today in the Documents folder.”
* **Installation notes:** Install the Python package (requires Python 3) and ensure the Everything HTTP server is running.  In Windows, you can install Everything from `voidtools.com` and enable the HTTP service.  Our example uses `python -m src.mcp_server_everything_search` and environment variables to configure host and port.  See `install-mcps-windows.ps1`.

### Snyk (security scanning)

* **Description:** Uses [Snyk](https://snyk.io/) to scan your dependencies for vulnerabilities.  Integrating this into your workflow lets your AI assistant surface security issues and propose fixes.
* **Example prompts:**
  - “Scan the project for vulnerabilities and summarise the top issues.”
  - “Suggest upgrades for packages with high‑severity vulnerabilities.”
* **Installation notes:** The official Snyk MCP server is published on npm.  Install with `npm install -g @snyk/mcp-server` (replace with the actual package name once available) and authenticate via the `SNYK_TOKEN` environment variable.  You may need to sign up for a free Snyk account to obtain a token.

### Sentry (error monitoring)

* **Description:** Connects to [Sentry](https://sentry.io/) to fetch error events and link them back to code.  This helps you correlate runtime errors with code changes.
* **Example prompts:**
  - “Fetch the latest error from Sentry for the production environment.”
  - “Show the stacktrace for error ID `abc123`.”
* **Installation notes:** Install the Sentry MCP via npm (once available) and set the `SENTRY_AUTH_TOKEN` environment variable.  You must have a Sentry project with API access.

### Docs / API Search

* **Description:** Provides a generic interface for searching documentation sets or API references.  Some packages index MDN, Python docs or local docs so the agent can quickly answer questions.
* **Example prompts:**
  - “Search the Python requests library for how to set a timeout.”
  - “Find documentation for the `docker compose` command.”
* **Installation notes:** Many flavours of docs search servers exist.  Choose one from the MCP catalog and follow its installation instructions.  For example, `npm install -g mcp-docs-search` (replace with actual package name).  These servers typically require an index or rely on external APIs.

### Oxylabs

* **Description:** [Oxylabs](https://github.com/oxylabs/oxylabs-mcp) offers a powerful scraping server that uses residential proxies to retrieve websites reliably.  It can access pages that block regular fetchers and handle CAPTCHAs.
* **Example prompts:**
  - “Scrape the latest blog posts from `news.ycombinator.com` and extract the top titles.”
  - “Download the contents of a dynamic page that requires JS rendering.”
* **Installation notes:** Follow the instructions in the Oxylabs MCP repository to install.  Usually this involves pulling a Docker image or installing via npm.  You must provide your Oxylabs credentials via environment variables (`OXYLABS_USERNAME`, `OXYLABS_PASSWORD` or `OXYLABS_API_KEY`).

### Context7

* **Description:** Context7 is a documentation‑aware MCP server.  It pulls the **latest** documentation for libraries and frameworks directly from their official sources, ensuring your AI assistant doesn’t hallucinate outdated APIs.  By using Upstash’s service, Context7 returns cleaned and summarised docs that are ready to insert into your model’s context.
* **Example prompts:**
  - “Use Context7 to fetch the latest FastAPI authentication docs and summarise the recommended workflow.”
  - “Pull the pandas `DataFrame` API documentation and list the most commonly used methods.”
* **Installation notes:** Context7 is published on npm; you can run it on demand with `npx -y @upstash/context7-mcp` or install it globally with `npm install -g @upstash/context7-mcp`.  Node.js 18 or newer is required.  No tokens are needed; the server runs locally and fetches docs via Upstash.

### Sequential Thinking

* **Description:** Sequential Thinking provides a chain‑of‑thought API that helps your model break down complex problems into manageable steps.  When you send it a “thought,” the server returns a structured suggestion for the next step and keeps a history so you can revisit or revise previous thoughts.  This is especially useful for multi‑stage tasks like designing a feature, planning a project or debugging a complicated issue.
* **Example prompts:**
  - “I’m planning to migrate our database from SQLite to PostgreSQL.  Use Sequential Thinking to outline the high‑level steps and ask me for more details when needed.”
  - “Continue the refactor from earlier—what should I tackle next?”
* **Installation notes:** You can run Sequential Thinking via npm or Docker.  To run via npm, execute `npx -y @modelcontextprotocol/server-sequential-thinking`; this will download and start the server.  Alternatively, you can run the Docker image with `docker run --rm -i mcp/sequentialthinking`.  Node.js 18+ is recommended if you use the npm version.  The server does not require any API tokens.

## Wiring servers into Continue

Each YAML file under `.continue/mcpServers/` defines a set of servers.  The fields correspond to the `command` and `args` used to start each server and any required environment variables.  For example, the **Fetch** entry in `default.yaml` looks like this:

```yaml
  - name: Fetch MCP server
    command: docker
    args:
      - run
      - -i
      - --rm
      - mcp/fetch
    env: {}
```

Continue reads these definitions at startup and launches the servers on demand.  To use them, ensure your `~/.continue/config.json` or workspace config points the `mcpServers` key at one of the YAML files.  For example:

```json
{
  "ollamaBaseUrl": "http://localhost:11434",
  "mcpServers": "./.continue/mcpServers/agent-dev.yaml"
}
```

You can switch between agent configurations by editing this path.  The JSON version (`mcpServers.json`) mirrors `default.yaml` for tools that prefer JSON.
