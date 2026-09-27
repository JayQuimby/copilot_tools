<#
.SYNOPSIS
  Install the Copilot package into a project, or into your user profile.
.EXAMPLE
  .\scripts\install.ps1 -Project C:\code\my-app
  .\scripts\install.ps1 -User
  Add -Force to overwrite files that already exist.
#>
param(
  [string]$Project,
  [switch]$User,
  [switch]$Force
)
$ErrorActionPreference = 'Stop'

$RepoRoot = Split-Path -Parent $PSScriptRoot
$Src = Join-Path $RepoRoot '.github'
$script:Copied = 0; $script:Skipped = 0

if (-not $Project -and -not $User) {
  Write-Error 'Usage: install.ps1 -Project <path> | -User [-Force]'
}

function Copy-One([string]$From, [string]$To) {
  New-Item -ItemType Directory -Force -Path (Split-Path -Parent $To) | Out-Null
  if ((Test-Path $To) -and -not $Force) {
    Write-Host "  skip (exists): $To"; $script:Skipped++
  } else {
    Copy-Item -LiteralPath $From -Destination $To -Force; $script:Copied++
  }
}

function Copy-Tree([string]$FromDir, [string]$ToDir) {
  $base = (Resolve-Path $FromDir).Path
  Get-ChildItem -LiteralPath $FromDir -Recurse -File | ForEach-Object {
    $rel = $_.FullName.Substring($base.Length).TrimStart('\', '/')
    Copy-One $_.FullName (Join-Path $ToDir $rel)
  }
}

if ($Project) {
  if (-not (Test-Path $Project -PathType Container)) { Write-Error "Not a directory: $Project" }
  $Dest = Join-Path (Resolve-Path $Project).Path '.github'
  Write-Host "Installing into $Dest"
  $existing = Join-Path $Dest 'copilot-instructions.md'
  if ((Test-Path $existing) -and -not $Force) {
    Copy-One (Join-Path $Src 'copilot-instructions.md') (Join-Path $Dest 'copilot-instructions.package.md')
    Write-Host '  NOTE: project already has copilot-instructions.md - package version saved as'
    Write-Host '        copilot-instructions.package.md. Merge the two by hand.'
  } else {
    Copy-One (Join-Path $Src 'copilot-instructions.md') $existing
  }
  foreach ($d in 'instructions', 'prompts', 'agents', 'skills') {
    Copy-Tree (Join-Path $Src $d) (Join-Path $Dest $d)
  }
} else {
  $Dest = Join-Path $HOME '.copilot'
  Write-Host "Installing into $Dest (available in every workspace)"
  Copy-Tree (Join-Path $Src 'skills') (Join-Path $Dest 'skills')
  Copy-Tree (Join-Path $Src 'agents') (Join-Path $Dest 'agents')
  Copy-Tree (Join-Path $Src 'instructions') (Join-Path $Dest 'instructions')
  $tmp = New-TemporaryFile
  $header = "---`nname: Operating principles`ndescription: How to work - explore, plan, verify, finish.`napplyTo: `"**`"`n---`n`n"
  Set-Content -LiteralPath $tmp -Value ($header + (Get-Content -Raw (Join-Path $Src 'copilot-instructions.md'))) -NoNewline -Encoding utf8
  Copy-One $tmp.FullName (Join-Path $Dest 'instructions/operating-principles.instructions.md')
  Remove-Item $tmp
  Write-Host '  NOTE: prompt files (/audit-frontend etc.) are per-project. To use them everywhere,'
  Write-Host "        run 'Chat: New Prompt File' -> User and paste them in, or install per project."
}

Write-Host "Done: $script:Copied copied, $script:Skipped skipped."
