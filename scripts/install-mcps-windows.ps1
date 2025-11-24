<#
    Installs MCP servers for Windows.  Run after completing bootstrap-windows.ps1.
    This script installs npm-based MCP servers and pulls Docker images where needed.
    It also reminds you to set environment variables for servers that require tokens.
#>

Write-Host "[MCP Install] Installing npm-based MCP servers..." -ForegroundColor Cyan

if (-not (Get-Command npm -ErrorAction SilentlyContinue)) {
  Write-Error "npm is not available. Please install Node.js before running this script."
  exit 1
}

# Install all relevant MCP servers via npm.  Replace packages with the latest names if they change.
npm install -g xray-mcp @modelcontextprotocol/server-github @playwright/mcp mcp-sqlite mcp-docs-search snyk-mcp sentry-mcp oxylabs-mcp @upstash/context7-mcp @modelcontextprotocol/server-sequential-thinking

# Pull Docker images for fetch/filesystem/git servers (these will also be pulled when running docker compose up)
docker pull mcp/fetch
docker pull mcp/filesystem
docker pull mcp/git

Write-Host "[MCP Install] Installation complete." -ForegroundColor Green
Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host "  1. Set environment variables for servers that need them (GITHUB_TOKEN, SNYK_TOKEN, SENTRY_AUTH_TOKEN, OXYLABS_USERNAME/PASSWORD/API_KEY)."
Write-Host "  2. Start the servers with: docker compose -f docker\docker-compose.mcp.yaml up -d"
Write-Host "  3. Update your .continue/mcpServers YAML files to point to any new servers you have installed."