#!/usr/bin/env bash
# Installs MCP servers on macOS.  Requires Node.js and npm installed via bootstrap.
set -e

echo "[MCP Install] Installing npm-based MCP servers..."

# Install servers globally; update package names as needed
npm install -g xray-mcp @modelcontextprotocol/server-github @playwright/mcp mcp-sqlite mcp-docs-search snyk-mcp sentry-mcp oxylabs-mcp @upstash/context7-mcp @modelcontextprotocol/server-sequential-thinking

echo "[MCP Install] Pulling Docker images for core servers..."
docker pull mcp/fetch
docker pull mcp/filesystem
docker pull mcp/git

echo "[MCP Install] Installation complete."
cat <<'INFO'
Next steps:
  1. Set environment variables required by certain servers:
       - GITHUB_TOKEN for GitHub server
       - SNYK_TOKEN for Snyk server
       - SENTRY_AUTH_TOKEN for Sentry server
       - OXYLABS_USERNAME, OXYLABS_PASSWORD/OXYLABS_API_KEY for Oxylabs server
  2. Start servers with: docker compose -f docker/docker-compose.mcp.yaml up -d
  3. Update your .continue/mcpServers YAML files to include new servers.
INFO