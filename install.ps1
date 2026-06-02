param(
    [ValidateSet("codex", "claude", "both")]
    [string]$Target = "both"
)

$ErrorActionPreference = "Stop"

$SkillName = "authorized-apk-ad-cleanup"
$Source = Join-Path $PSScriptRoot $SkillName

if (-not (Test-Path -LiteralPath $Source)) {
    throw "Skill folder not found: $Source"
}

function Install-Skill {
    param([string]$Root)

    $SkillsDir = Join-Path $Root "skills"
    New-Item -ItemType Directory -Force -Path $SkillsDir | Out-Null
    Copy-Item -LiteralPath $Source -Destination $SkillsDir -Recurse -Force
    Write-Host "Installed $SkillName to $SkillsDir"
}

if ($Target -eq "codex" -or $Target -eq "both") {
    Install-Skill (Join-Path $env:USERPROFILE ".codex")
}

if ($Target -eq "claude" -or $Target -eq "both") {
    Install-Skill (Join-Path $env:USERPROFILE ".claude")
}

Write-Host "Done. Start a new Claude or Codex session, then invoke: Use `$authorized-apk-ad-cleanup ..."
