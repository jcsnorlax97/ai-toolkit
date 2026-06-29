param(
    [string] $InstallDir = (Join-Path $HOME ".local\bin"),

    [switch] $AddToUserPath,

    [switch] $VerifyOnly,

    [switch] $Remove
)

$ErrorActionPreference = "Stop"

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$scriptsRoot = Split-Path -Parent $scriptDir
$cliPath = Join-Path $scriptsRoot "skills.ps1"
$shimPath = Join-Path $InstallDir "skills.cmd"
$marker = "ai-agent-library skills shim"
$acceptedMarkers = @($marker, "agentic-engineering-skills skills shim")

function Path-ContainsInstallDir {
    $userPath = [Environment]::GetEnvironmentVariable("Path", "User")
    if (-not $userPath) {
        return $false
    }

    $parts = $userPath -split ';' | Where-Object { $_ }
    return ($parts | Where-Object { $_.TrimEnd('\') -ieq $InstallDir.TrimEnd('\') }).Count -gt 0
}

function Test-Shim {
    if (-not (Test-Path -LiteralPath $shimPath)) {
        throw "Missing shim: $shimPath"
    }

    $content = [System.IO.File]::ReadAllText($shimPath, [System.Text.Encoding]::UTF8)
    $hasAcceptedMarker = ($acceptedMarkers | Where-Object { $content -like "*$_*" }).Count -gt 0
    if (-not $hasAcceptedMarker -or $content -notlike "*$cliPath*") {
        throw "Shim exists but does not point at this repo: $shimPath"
    }

    if (-not (Path-ContainsInstallDir)) {
        throw "Install dir is not in the user PATH: $InstallDir"
    }

    Write-Output "shim ok: $shimPath"
}

if ($Remove) {
    if (-not (Test-Path -LiteralPath $shimPath)) {
        Write-Output "skip missing shim: $shimPath"
        exit 0
    }

    $content = [System.IO.File]::ReadAllText($shimPath, [System.Text.Encoding]::UTF8)
    $hasAcceptedMarker = ($acceptedMarkers | Where-Object { $content -like "*$_*" }).Count -gt 0
    if (-not $hasAcceptedMarker -or $content -notlike "*$cliPath*") {
        throw "Refusing to remove non-matching shim: $shimPath"
    }

    if ($VerifyOnly) {
        Write-Output "would remove shim: $shimPath"
        exit 0
    }

    [System.IO.File]::Delete($shimPath)
    Write-Output "removed shim: $shimPath"
    exit 0
}

if ($VerifyOnly) {
    Test-Shim
    exit 0
}

if (-not (Test-Path -LiteralPath $InstallDir)) {
    New-Item -ItemType Directory -Path $InstallDir | Out-Null
}

$shim = @"
@echo off
REM $marker
powershell -NoProfile -ExecutionPolicy Bypass -File "$cliPath" %*
"@

$encoding = [System.Text.UTF8Encoding]::new($false)
[System.IO.File]::WriteAllText($shimPath, $shim, $encoding)
Write-Output "installed shim: $shimPath"

if ($AddToUserPath) {
    $userPath = [Environment]::GetEnvironmentVariable("Path", "User")
    if (-not (Path-ContainsInstallDir)) {
        $nextPath = if ($userPath) { "$userPath;$InstallDir" } else { $InstallDir }
        [Environment]::SetEnvironmentVariable("Path", $nextPath, "User")
        Write-Output "added to user PATH: $InstallDir"
        Write-Output "open a new terminal before running: skills list"
    } else {
        Write-Output "PATH already contains: $InstallDir"
    }
} elseif (-not (Path-ContainsInstallDir)) {
    Write-Output "PATH does not contain: $InstallDir"
    Write-Output "rerun with -AddToUserPath, or add the directory manually."
}
