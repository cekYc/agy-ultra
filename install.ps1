<#
.SYNOPSIS
    GeminiUltra 1-Click Installer for Windows (Google Antigravity)
.DESCRIPTION
    Installs or updates the GeminiUltra multi-agent swarm skill globally into:
    $HOME\.gemini\config\skills\gemini-ultra
#>

$ErrorActionPreference = "Stop"

$RepoUrl = "https://github.com/cekYc/GeminiUltra.git"
$GlobalSkillsDir = Join-Path $HOME ".gemini\config\skills"
$TargetDir = Join-Path $GlobalSkillsDir "gemini-ultra"

Write-Host ""
Write-Host "===========================================================" -ForegroundColor Cyan
Write-Host "   [*] Installing GeminiUltra for Google Antigravity       " -ForegroundColor Cyan
Write-Host "   Powered by Gemini 3.8 Flash (High Reasoning)            " -ForegroundColor DarkCyan
Write-Host "===========================================================" -ForegroundColor Cyan
Write-Host ""

# Ensure global skills folder exists
if (-not (Test-Path $GlobalSkillsDir)) {
    Write-Host "[1/3] Creating global skills directory..." -ForegroundColor Yellow
    New-Item -ItemType Directory -Force -Path $GlobalSkillsDir | Out-Null
} else {
    Write-Host "[1/3] Verified global skills directory: $GlobalSkillsDir" -ForegroundColor Green
}

# Determine if running locally from cloned repo or via remote web script
$CurrentScriptDir = $PSScriptRoot
$LocalSourceDir = Join-Path $CurrentScriptDir ".agents\skills\gemini-ultra"

if ($CurrentScriptDir -and (Test-Path $LocalSourceDir)) {
    Write-Host "[2/3] Installing from local repository..." -ForegroundColor Yellow
    if (Test-Path $TargetDir) {
        Remove-Item -Recurse -Force $TargetDir
    }
    Copy-Item -Recurse -Force $LocalSourceDir $TargetDir
} else {
    Write-Host "[2/3] Downloading latest GeminiUltra release from GitHub..." -ForegroundColor Yellow
    $TempDir = Join-Path $env:TEMP "GeminiUltra-Install-$(Get-Random)"
    try {
        if (Get-Command git -ErrorAction SilentlyContinue) {
            git clone --depth 1 $RepoUrl $TempDir --quiet
        } else {
            # Fallback if git is not in PATH: Download zip
            $ZipPath = Join-Path $env:TEMP "gemini-ultra.zip"
            Invoke-WebRequest -Uri "https://github.com/cekYc/GeminiUltra/archive/refs/heads/main.zip" -OutFile $ZipPath
            Expand-Archive -Path $ZipPath -DestinationPath $TempDir -Force
            Remove-Item $ZipPath -Force
            $TempDir = Join-Path $TempDir "GeminiUltra-main"
        }

        $DownloadedSource = Join-Path $TempDir ".agents\skills\gemini-ultra"
        if (Test-Path $TargetDir) {
            Remove-Item -Recurse -Force $TargetDir
        }
        Copy-Item -Recurse -Force $DownloadedSource $TargetDir
    } finally {
        if (Test-Path $TempDir) {
            Remove-Item -Recurse -Force $TempDir -ErrorAction SilentlyContinue
        }
    }
}

Write-Host "[3/3] Validating installation..." -ForegroundColor Yellow
$SkillFile = Join-Path $TargetDir "SKILL.md"
if (Test-Path $SkillFile) {
    Write-Host ""
    Write-Host "[OK] GeminiUltra successfully installed!" -ForegroundColor Green
    Write-Host "Installed at: $TargetDir" -ForegroundColor Gray
    Write-Host ""
    Write-Host "How to use:" -ForegroundColor Cyan
    Write-Host "   1. Open Google Antigravity (IDE or CLI)." -ForegroundColor White
    Write-Host "   2. Type in chat: /ultra <your task here>" -ForegroundColor Yellow
    Write-Host "   3. Enjoy multi-agent high-effort reasoning!" -ForegroundColor White
    Write-Host ""
} else {
    Write-Error "Failed to install GeminiUltra. Please verify network access or run manually."
}
