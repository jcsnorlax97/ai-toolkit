param(
    [Parameter(Position = 0)]
    [ValidateSet("list", "show", "apply", "remove", "verify", "shim")]
    [string] $Command = "list",

    [Parameter(Position = 1)]
    [string] $ShimAction = "install",

    [string] $TargetRepo = (Get-Location).Path,

    [string] $Pack = "",

    [string[]] $Tools = @("codex", "claude"),

    [switch] $CreateMissing,

    [switch] $DryRun,

    [string] $InstallDir = "",

    [switch] $AddToUserPath
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

function Resolve-PackNames($Name) {
    if ($Name) {
        if ($Name -eq "all") {
            return @(Get-PackNames)
        }

        $null = Read-PackJson $Name
        return @($Name)
    }

    $packNames = @(Get-PackNames)
    if ($packNames.Count -eq 0) {
        throw "No portable baseline packs found in: $baselinesRoot"
    }
    if ($packNames.Count -eq 1) {
        return @($packNames[0])
    }

    throw "Multiple portable baseline packs are available: $($packNames -join ', '). Pass -Pack <name>."
}

function Normalize-Tools($ToolValues) {
    $allTools = @("codex", "claude", "copilot")
    $normalized = @()
    foreach ($toolValue in $ToolValues) {
        foreach ($tool in ($toolValue -split ",")) {
            $trimmed = $tool.Trim()
            if (-not $trimmed) {
                continue
            }

            if ($trimmed -eq "all") {
                foreach ($toolName in $allTools) {
                    if ($normalized -notcontains $toolName) {
                        $normalized += $toolName
                    }
                }
                continue
            }

            if ($allTools -notcontains $trimmed) {
                throw "Unsupported tool '$trimmed'. Supported tools: $($allTools -join ', '), all"
            }

            if ($normalized -notcontains $trimmed) {
                $normalized += $trimmed
            }
        }
    }

    return $normalized
}

if (@("show", "apply", "remove", "verify") -contains $Command) {
    $Packs = Resolve-PackNames $Pack
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
        foreach ($packName in $Packs) {
            $packInfo = Read-PackJson $packName
            $baselinePath = Join-Path (Get-PackRoot $packName) "baseline.md"
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
            Write-Output ""
        }
    }
    "apply" {
        $applyScript = Join-Path $scriptDir "baselines\apply.ps1"
        foreach ($packName in $Packs) {
            & $applyScript -TargetRepo $TargetRepo -Pack $packName -Tools $Tools -CreateMissing:$CreateMissing -DryRun:$DryRun
        }
    }
    "remove" {
        $removeScript = Join-Path $scriptDir "baselines\remove.ps1"
        foreach ($packName in $Packs) {
            & $removeScript -TargetRepo $TargetRepo -Pack $packName -Tools $Tools -DryRun:$DryRun
        }
    }
    "verify" {
        $verifyScript = Join-Path $scriptDir "baselines\verify.ps1"
        foreach ($packName in $Packs) {
            & $verifyScript -TargetRepo $TargetRepo -Pack $packName -Tools $Tools
        }
    }
    "shim" {
        if (@("install", "verify", "remove") -notcontains $ShimAction) {
            throw "Unknown shim action: $ShimAction. Use install, verify, or remove."
        }

        $shimScript = Join-Path $scriptDir "baselines\install-shim.ps1"
        $shimArgs = @{}
        if ($InstallDir) {
            $shimArgs.InstallDir = $InstallDir
        }
        if ($AddToUserPath) {
            $shimArgs.AddToUserPath = $true
        }
        if ($ShimAction -eq "verify") {
            $shimArgs.VerifyOnly = $true
        }
        if ($ShimAction -eq "remove") {
            $shimArgs.Remove = $true
        }

        & $shimScript @shimArgs
    }
}
