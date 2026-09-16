#!/usr/bin/env pwsh
# Install the rolling-wave-planning skill family into an agent skills directory,
# or check an existing install. See -Help.
param(
  [string]$SkillsDir = '',
  [switch]$Claude,
  [switch]$Check,
  [switch]$DryRun,
  [switch]$Force,
  [switch]$Help
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

if ($Help) {
  @'
setup.ps1 - install the rolling-wave-planning skill family.

Usage: pwsh -File setup.ps1 [options]

  -SkillsDir <path>  Skills directory to link into (default: $HOME/.agents/skills).
  -Claude            Also link the six entries into $HOME/.claude/skills.
  -Check             Report state only, change nothing. Exit 0 if all six resolve.
  -DryRun            Print what would be done, change nothing.
  -Force             Replace a symlink or junction that points elsewhere. Never deletes
                     a real file or directory.
  -Help              This message.

Exit codes: 0 ok, 1 an entry is unresolved or skipped, 2 not a rolling-wave-planning repo.
'@
  exit 0
}

$homeDir = if ($env:HOME) { $env:HOME } else { $env:USERPROFILE }
if (-not $SkillsDir) { $SkillsDir = Join-Path $homeDir '.agents/skills' }

# The six skills-directory entries and their path inside the repo ('' = the repo root).
$entries = @(
  @{ Name = 'rolling-wave-planning';       Rel = '' },
  @{ Name = 'pre-rolling-wave-planning';   Rel = 'skills/pre-rolling-wave-planning' },
  @{ Name = 'human-assisted-verification'; Rel = 'skills/human-assisted-verification' },
  # `mentor-documentation-system` is a bundle, not a skill: it has no SKILL.md of its own,
  # only a README and the two nested skills that are entries in their own right. It is
  # linked so that paths inside it stay reachable, and it resolves on the directory alone.
  @{ Name = 'mentor-documentation-system'; Rel = 'skills/mentor-documentation-system'; Bundle = $true },
  @{ Name = 'human-engineering-docs';      Rel = 'skills/mentor-documentation-system/skills/human-engineering-docs' },
  @{ Name = 'senior-mentor';               Rel = 'skills/mentor-documentation-system/skills/senior-mentor' }
)

$script:Problems = 0
$script:NotALink = 0
$script:WarnedJunction = $false

function Normalize([string]$p) {
  if (-not $p) { return '' }
  $n = $p -replace '\\', '/'
  if ($n.Length -gt 1) { $n = $n.TrimEnd('/') }
  return $n
}

function Get-Entry([string]$p) {
  try { return Get-Item -LiteralPath $p -Force -ErrorAction Stop } catch { return $null }
}

function Test-IsLink([string]$p) {
  $item = Get-Entry $p
  if (-not $item) { return $false }
  return [bool]$item.LinkTarget
}

# Physical absolute path, following the link chain on the last component.
function Resolve-Physical([string]$p) {
  $cur = $p
  for ($i = 0; $i -lt 40; $i++) {
    $item = Get-Entry $cur
    if (-not $item) { break }
    $lt = $item.LinkTarget
    if (-not $lt) { break }
    if ([System.IO.Path]::IsPathRooted($lt)) { $cur = $lt }
    else { $cur = Join-Path (Split-Path -Parent $cur) $lt }
  }
  try { return Normalize ([System.IO.Path]::GetFullPath($cur)) } catch { return Normalize $cur }
}

# Path of $target relative to directory $start, or $target when only the root is shared.
function Get-RelPath([string]$target, [string]$start) {
  $t = (Normalize $target).Split('/')
  $s = (Normalize $start).Split('/')
  $i = 0
  while ($i -lt $t.Count -and $i -lt $s.Count -and $t[$i] -eq $s[$i]) { $i++ }
  if ($i -le 1) { return (Normalize $target) }
  $up = @()
  if ($s.Count -gt $i) { $up = @('..') * ($s.Count - $i) }
  return (($up + $t[$i..($t.Count - 1)]) -join '/')
}

function Write-Entry([string]$status, [string]$name, [string]$target) {
  Write-Output ("{0}  {1}  ->  {2}" -f $status, $name, $target)
}

function New-Link([string]$path, [string]$targetLink, [string]$targetAbs) {
  # A relative -Target is resolved against the current directory, so create the link
  # from inside its own parent.
  $parent = Split-Path -Parent $path
  $leaf = Split-Path -Leaf $path
  Push-Location -LiteralPath $parent
  try {
    try {
      New-Item -ItemType SymbolicLink -Path $leaf -Target $targetLink | Out-Null
    } catch {
      # Windows without Developer Mode or admin rights refuses symlinks. Junctions work,
      # but only with an absolute target.
      if (-not $IsWindows) { throw }
      New-Item -ItemType Junction -Path $leaf -Target $targetAbs | Out-Null
      if (-not $script:WarnedJunction) {
        Write-Output 'warning: created junctions, not symlinks (no symlink privilege). Junctions load but do not appear in the Claude Code desktop slash menu. Enable Developer Mode or run as administrator for real symlinks.'
        $script:WarnedJunction = $true
      }
    }
  } finally { Pop-Location }
}

# Writes one status line and bumps $script:Problems when the entry was skipped. It must
# not return a value: PowerShell folds a function's output stream into its return value,
# so a caller writing `if (Set-Entry ...)` would swallow the status line.
function Set-Entry([string]$name, [string]$targetAbs, [string]$targetLink, [string]$dir) {
  $path = Join-Path $dir $name
  if (Test-IsLink $path) {
    $cur = Resolve-Physical $path
    if ($cur -eq (Normalize $targetAbs)) { Write-Entry 'ok' $name $targetLink; return }
    if ($Check) { Write-Entry 'skipped: points elsewhere (use -Force)' $name $cur; $script:Problems++; return }
    if ($Force) {
      if ($DryRun) { Write-Entry 'would link' $name $targetLink; return }
      Remove-Item -LiteralPath $path -Force
      New-Link $path $targetLink $targetAbs
      Write-Entry 'replaced' $name $targetLink; return
    }
    Write-Entry 'skipped: points elsewhere (use -Force)' $name $cur; $script:Problems++; return
  }
  if (Test-Path -LiteralPath $path) {
    # -Force must never delete real content, so this state is reported, not resolved.
    Write-Entry 'skipped: exists and is not a link' $name $path
    $script:NotALink = 1; $script:Problems++; return
  }
  if ($Check)  { Write-Entry 'missing' $name $targetLink; $script:Problems++; return }
  if ($DryRun) { Write-Entry 'would link' $name $targetLink; return }
  New-Link $path $targetLink $targetAbs
  Write-Entry 'linked' $name $targetLink
}

$repoDir = Normalize (Split-Path -Parent (Resolve-Physical $PSCommandPath))
if (-not (Test-Path -LiteralPath "$repoDir/SKILL.md") -or
    -not (Test-Path -LiteralPath "$repoDir/skills/pre-rolling-wave-planning/SKILL.md")) {
  [Console]::Error.WriteLine("error: $repoDir is not a rolling-wave-planning repo (SKILL.md or skills/pre-rolling-wave-planning/SKILL.md missing)")
  exit 2
}

if (-not (Test-Path -LiteralPath $SkillsDir)) {
  if ($Check -or $DryRun) { Write-Output "note: skills dir $SkillsDir does not exist" }
  else { New-Item -ItemType Directory -Path $SkillsDir -Force | Out-Null }
}
$SkillsDir = if (Test-Path -LiteralPath $SkillsDir) { Resolve-Physical $SkillsDir } else { Normalize $SkillsDir }

Write-Output "repo:       $repoDir"
Write-Output "skills dir: $SkillsDir"
Write-Output ''

# Relative link targets only when the repo itself lives under the skills dir.
$repoUnderSkills = $repoDir.StartsWith("$SkillsDir/")

foreach ($e in $entries) {
  $targetAbs = if ($e.Rel) { "$repoDir/$($e.Rel)" } else { $repoDir }
  $targetLink = if ($repoUnderSkills) { $targetAbs.Substring($SkillsDir.Length + 1) } else { $targetAbs }
  if (-not $e.Rel -and $repoDir -eq "$SkillsDir/$($e.Name)") {
    Write-Entry 'in place' $e.Name $repoDir
    continue
  }
  Set-Entry $e.Name $targetAbs $targetLink $SkillsDir
}

$resolved = 0
foreach ($e in $entries) {
  $isBundle = $e.ContainsKey('Bundle')
  if (Test-Path -LiteralPath "$SkillsDir/$($e.Name)/SKILL.md") { $resolved++ }
  elseif ($isBundle -and (Test-Path -LiteralPath "$SkillsDir/$($e.Name)" -PathType Container)) { $resolved++ }
}
Write-Output ''
Write-Output "$resolved/$($entries.Count) skills resolve"

if ($Claude) {
  Write-Output ''
  $claudeDir = Normalize (Join-Path $homeDir '.claude/skills')
  $claudeReal = if (Test-Path -LiteralPath $claudeDir) { Resolve-Physical $claudeDir } else { '' }
  if ($claudeReal -eq $SkillsDir) {
    Write-Output "claude dir: $claudeDir resolves to the skills dir, nothing to do"
  } else {
    if (-not $claudeReal -and -not $Check -and -not $DryRun) {
      New-Item -ItemType Directory -Path $claudeDir -Force | Out-Null
      $claudeReal = Resolve-Physical $claudeDir
    }
    Write-Output "claude dir: $claudeDir"
    if ($claudeReal) {
      foreach ($e in $entries) {
        $entryPath = "$SkillsDir/$($e.Name)"
        $physical = Resolve-Physical $entryPath
        if (-not $physical) { $physical = $entryPath }
        $link = Get-RelPath $entryPath $claudeReal
        Set-Entry $e.Name $physical $link $claudeReal
      }
    } else {
      Write-Output "would create $claudeDir and link $($entries.Count) entries"
    }
  }
}

Write-Output ''
Write-Output 'Referenced skills (advice only, never changes the exit code)'
$list = "$repoDir/setup/referenced-skills.txt"
if (-not (Test-Path -LiteralPath $list)) {
  Write-Output "  note: $list not found, skipping"
} else {
  $pluginBlock = $false
  foreach ($line in (Get-Content -LiteralPath $list)) {
    if (-not $line -or $line.StartsWith('#')) { continue }
    if ($line.Trim() -eq '[plugin]') { $pluginBlock = $true; Write-Output ''; continue }
    $parts = @($line -split "`t", 2)
    $sname = $parts[0]
    $shint = if ($parts.Count -gt 1) { $parts[1] } else { '' }
    if ($pluginBlock) { Write-Output "  plugin (check in your harness)  $sname  ($shint)" }
    elseif (Test-Path -LiteralPath "$SkillsDir/$sname/SKILL.md") { Write-Output "  present  $sname" }
    else { Write-Output "  missing  $sname  ($shint)" }
  }
}

Write-Output ''
Write-Output 'Tools'
foreach ($tool in @('agent-browser', 'graphify', 'node', 'npx', 'git')) {
  if (Get-Command $tool -ErrorAction SilentlyContinue) { Write-Output "  on PATH    $tool" }
  else { Write-Output "  not found  $tool" }
}

if ($Check) { if ($resolved -eq $entries.Count) { exit 0 } else { exit 1 } }
if ($script:NotALink -eq 1 -or $script:Problems -gt 0) { exit 1 }
if (-not $DryRun -and $resolved -ne $entries.Count) { exit 1 }
exit 0
