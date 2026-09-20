
# Install Business Investigator Skill for Codex on Windows.
# Run from PowerShell.
#
# This script creates a directory junction:
#   ~/.agents/skills/business-investigator
#       -> <repository>/skills/business-investigator
#
# It does not overwrite an existing installation.

$ErrorActionPreference = "Stop"

$skillName = "business-investigator"

# Resolve repository root from this script's location.
$repoRoot = Split-Path -Parent $PSScriptRoot

# Source skill directory inside Git repository.
$skillSource = Join-Path $repoRoot "skills\$skillName"

# Codex user-level skills directory.
$skillsHome = Join-Path $HOME ".agents\skills"

# Installation destination.
$skillTarget = Join-Path $skillsHome $skillName

Write-Host ""
Write-Host "Installing Codex Skill: $skillName" -ForegroundColor Cyan

# 1. Validate source.
$skillFile = Join-Path $skillSource "SKILL.md"

if (-not (Test-Path -LiteralPath $skillFile -PathType Leaf)) {
    Write-Error "SKILL.md not found: $skillFile"
    exit 1
}

# 2. Create user skills directory.
if (-not (Test-Path -LiteralPath $skillsHome -PathType Container)) {
    New-Item -ItemType Directory -Path $skillsHome -Force |
        Out-Null
}

# 3. Do not overwrite an existing installation.
if (Test-Path -LiteralPath $skillTarget) {
    Write-Host ""
    Write-Host "Skill destination already exists:" -ForegroundColor Yellow
    Write-Host $skillTarget

    Write-Host ""
    Write-Host "Installation skipped. Check the existing directory."
    exit 0
}

# 4. Create directory junction.
New-Item `
    -ItemType Junction `
    -Path $skillTarget `
    -Target $skillSource | Out-Null

# 5. Verify installation.
$installedSkillFile = Join-Path $skillTarget "SKILL.md"

if (-not (Test-Path -LiteralPath $installedSkillFile -PathType Leaf)) {
    Write-Error "Installation verification failed."
    exit 1
}

Write-Host ""
Write-Host "Skill installed successfully!" -ForegroundColor Green

Write-Host ""
Write-Host "Source:"
Write-Host "  $skillSource"

Write-Host ""
Write-Host "Installed at:"
Write-Host "  $skillTarget"

Write-Host ""
Write-Host "Open a new Codex session and invoke:"
Write-Host '  $business-investigator' -ForegroundColor Cyan