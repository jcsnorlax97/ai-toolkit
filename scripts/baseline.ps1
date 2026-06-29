param(
    [Parameter(Position = 0)]
    [ValidateSet("list", "show", "apply", "remove", "verify")]
    [string] $Command = "list",

    [string] $TargetRepo = (Get-Location).Path,

    [string] $Pack = "",

    [string[]] $Tools = @("codex", "claude"),

    [switch] $CreateMissing,

    [switch] $DryRun
)

$ErrorActionPreference = "Stop"

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$repoRoot = Split-Path -Parent $scriptDir
$baselinesRoot = Join-Path $repoRoot "baselines"

function Read-Utf8Text($Path) {
    return [System.IO.File]::ReadAllText($Path, [System.Text.Encoding]::UTF8)
}

function Get-PackRoot($Name) {
    return Join-Path $baselinesRoot $Name
}

function Read-PackJson($Name) {
    $packPath = Join-Path (Get-PackRoot $Name) "pack.json"
    if (-not (Test-Path -LiteralPath $packPath)) {
        throw "Unknown portable baseline pack: $Name"
    }
    return (Read-Utf8Text $packPath | ConvertFrom-Json)
}

function Get-PackNames {
    if (-not (Test-Path -LiteralPath $baselinesRoot)) {
        throw "Missing baselines directory: $baselinesRoot"
    }

    return @(Get-ChildItem -LiteralPath $baselinesRoot -Directory | Where-Object {
        Test-Path -LiteralPath (Join-Path $_.FullName "pack.json")
    } | ForEach-Object {
        $_.Name
    })
}

function Resolve-PackName($Name) {
    if ($Name) {
        $null = Read-PackJson $Name
        return $Name
    }

    $packNames = @(Get-PackNames)
    if ($packNames.Count -eq 0) {
        throw "No portable baseline packs found in: $baselinesRoot"
    }
    if ($packNames.Count -eq 1) {
        return $packNames[0]
    }

    throw "Multiple portable baseline packs are available: $($packNames -join ', '). Pass -Pack <name>."
}

function Normalize-Tools($ToolValues) {
    $normalized = @()
    foreach ($toolValue in $ToolValues) {
        foreach ($tool in ($toolValue -split ",")) {
            $trimmed = $tool.Trim()
            if ($trimmed) {
                $normalized += $trimmed
            }
        }
    }

    return $normalized
}

if ($Command -ne "list") {
    $Pack = Resolve-PackName $Pack
    $Tools = Normalize-Tools $Tools
}

switch ($Command) {
    "list" {
        Get-PackNames | ForEach-Object {
            $packInfo = Read-PackJson $_
            Write-Output "$($packInfo.name) $($packInfo.version) [$($packInfo.status)] - $($packInfo.description)"
        }
    }
    "show" {
        $packInfo = Read-PackJson $Pack
        $baselinePath = Join-Path (Get-PackRoot $Pack) "baseline.md"
        Write-Output "# $($packInfo.name) $($packInfo.version) [$($packInfo.status)]"
        Write-Output ""
        Write-Output $packInfo.description
        Write-Output ""
        Write-Output "Adapters:"
        $packInfo.adapters.PSObject.Properties | ForEach-Object {
            Write-Output "- $($_.Name): $($_.Value)"
        }
        Write-Output ""
        Write-Output (Read-Utf8Text $baselinePath).Trim()
    }
    "apply" {
        $applyScript = Join-Path $scriptDir "apply-baseline.ps1"
        & $applyScript -TargetRepo $TargetRepo -Pack $Pack -Tools $Tools -CreateMissing:$CreateMissing -DryRun:$DryRun
    }
    "remove" {
        $removeScript = Join-Path $scriptDir "remove-baseline.ps1"
        & $removeScript -TargetRepo $TargetRepo -Pack $Pack -Tools $Tools -DryRun:$DryRun
    }
    "verify" {
        $verifyScript = Join-Path $scriptDir "verify-baselines.ps1"
        & $verifyScript -TargetRepo $TargetRepo -Pack $Pack -Tools $Tools
    }
}
