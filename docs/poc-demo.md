# Proof‑of‑Concept: Local AI Workflow Demo

This proof‑of‑concept (PoC) shows how a local AI stack built with **Ollama**, **Continue** and **MCP servers** can help you refactor and improve a small codebase.  The demo project lives in `examples/poc-local-ai-workflow` and contains a deliberately messy Flask application.

## Scenario

The `app.py` file defines two endpoints but mixes business logic, lacks tests and has no error handling.  Your goal is to extract common code into helpers, add unit tests and improve logging, security and monitoring—all without sending any data to the cloud.

## Setup

Follow the steps in the main environment setup guide to install prerequisites and start the MCP servers.  In summary:

1. Pull a model with Ollama, e.g. `ollama pull nemotron-9b:q4_k_m`.
2. Install Continue in VS Code and the CLI.
3. Start the MCP servers:

   ```bash
   docker compose -f docker/docker-compose.mcp.yaml up -d
   ```

4. Copy `.continue/config.example.json` to `~/.continue/config.json` and set `mcpServers` to `.continue/mcpServers/agent-dev.yaml`.

You can run the Flask app manually via:

```bash
cd examples/poc-local-ai-workflow
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
python app.py
```

## Walkthrough

Open `examples/poc-local-ai-workflow` in VS Code and open the Continue chat panel.  Use the following steps to explore different MCP servers:

### 1. Refactor duplicate code (Filesystem MCP)

Ask Continue:

> **“List all functions in this project that duplicate logic.”**

Then:

> **“Extract the duplicated formatting into a helper function called `format_item` in `utils.py` and update the endpoints.”**

Continue uses the Filesystem MCP to read and edit multiple files, proposing a diff.  Review and accept the changes.

### 2. Analyse the codebase (XRAY MCP)

Ask:

> **“Map all functions that call `get_items`.”**

and:

> **“If I change the return type of `get_items` to return an object instead of a dict, what parts of the code will break?”**

XRAY builds an AST and call graph to answer these questions.

### 3. Commit your changes (Git MCP)

Once you’re satisfied, stage the changes and ask:

> **“Generate a conventional commit message summarising the refactor.”**

Continue uses the Git MCP server to look at the diff and craft a message.

### 4. Pull documentation (Fetch/Docs Search MCP)

Suppose you need to add pagination.  Ask:

> **“Fetch the Flask documentation for pagination and summarise how to implement limit and offset.”**

The Fetch server retrieves the relevant page and Continue summarises it.  Alternatively use a docs search server to search multiple doc sets.

### 5. Scan dependencies (Snyk MCP)

Run:

> **“Scan the project’s dependencies for vulnerabilities and suggest upgrades.”**

Make sure you have set your `SNYK_TOKEN` environment variable and installed the Snyk server.

### 6. Inspect errors (Sentry MCP)

Introduce a bug (e.g. divide by zero) and hit the endpoint.  Then ask:

> **“Fetch the latest Sentry error and show the stacktrace.”**

With your Sentry token configured, Continue can display the error and propose a fix.

### 7. Advanced scraping (Oxylabs MCP)

Optionally, demonstrate the Oxylabs server:

> **“Use Oxylabs to scrape the latest Flask release notes and extract the version number and key changes.”**

Configure your Oxylabs credentials beforehand.

## Before vs After

| Aspect | Before | After |
| --- | --- | --- |
| **Code organisation** | Business logic mixed in route handlers | Helper functions in `utils.py` and cleaner handlers |
| **Tests** | None | Basic unit tests added under `tests/` |
| **Logging** | No logging | Added standard Python logging |
| **Error handling** | Exceptions propagate unhandled | Added try/except and error responses |
| **Security/monitoring** | Unscanned dependencies and no monitoring | Snyk scan performed and optional Sentry integration |

This PoC demonstrates that you can refactor, test, document, secure and monitor a project using only local tools.  The combination of Continue and MCP servers lets your AI assistant orchestrate complex workflows while your data never leaves your machine.
