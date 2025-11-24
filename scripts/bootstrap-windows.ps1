<#
    This script bootstraps a Windows 11 machine for the local LLM + Continue.dev stack.
    It installs Git, Node.js, Python, Docker Desktop, VS Code and Ollama using winget.
    Run from an elevated PowerShell prompt (Run as Administrator).
#>

Write-Host "[Bootstrap] Installing prerequisites via winget..." -ForegroundColor Cyan

# Install Git
winget install -e --id Git.Git -h --accept-package-agreements --accept-source-agreements

# Install Node.js LTS
winget install -e --id OpenJS.NodeJS -h --accept-package-agreements --accept-source-agreements

# Install Python 3
winget install -e --id Python.Python.3.9 -h --accept-package-agreements --accept-source-agreements

# Install Visual Studio Code
winget install -e --id Microsoft.VisualStudioCode -h --accept-package-agreements --accept-source-agreements

# Install Docker Desktop
winget install -e --id Docker.DockerDesktop -h --accept-package-agreements --accept-source-agreements

Write-Host "[Bootstrap] Installing Ollama..." -ForegroundColor Cyan

# Download and run Ollama installer silently
$ollamaInstaller = "$env:TEMP\ollama-setup.exe"
Invoke-WebRequest -Uri "https://ollama.com/download/ollama-setup.exe" -OutFile $ollamaInstaller
Start-Process -FilePath $ollamaInstaller -ArgumentList "/S" -Wait

Write-Host "[Bootstrap] Installing Continue CLI..." -ForegroundColor Cyan

# Install Continue CLI via npm
npm install -g @continuedev/cli

Write-Host "[Bootstrap] Done. Please restart your terminal or machine to finish installation." -ForegroundColor Green
Write-Host "Next, configure Continue by copying ./.continue/config.example.json to $env:USERPROFILE\.continue\config.json and editing the paths." -ForegroundColor Yellow