# Makefile for local LLM dev stack

.PHONY: setup mcps-up mcps-down poc

# Determine OS for bootstrap scripts
UNAME_S := $(shell uname -s)

# Setup environment on host
setup:
	@if [ "$(UNAME_S)" = "Linux" ]; then \
		bash scripts/bootstrap-linux.sh; \
		bash scripts/install-mcps-ubuntu.sh; \
	elif [ "$(UNAME_S)" = "Darwin" ]; then \
		bash scripts/bootstrap-macos.sh; \
		bash scripts/install-mcps-macos.sh; \
	else \
		powershell -ExecutionPolicy Bypass -File scripts/bootstrap-windows.ps1; \
		powershell -ExecutionPolicy Bypass -File scripts/install-mcps-windows.ps1; \
	fi

# Start MCP servers defined in docker-compose.mcp.yaml
mcps-up:
	docker compose -f docker/docker-compose.mcp.yaml up -d

# Stop MCP servers
mcps-down:
	docker compose -f docker/docker-compose.mcp.yaml down

# Run the proof-of-concept workflow (prints instructions)
poc:
	@echo "Starting MCP servers...";
	docker compose -f docker/docker-compose.mcp.yaml up -d;
	@echo "\nProof‑of‑Concept ready.  Open VS Code, navigate to examples/poc-local-ai-workflow and follow docs/poc-demo.md for the workflow.";