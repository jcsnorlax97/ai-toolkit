param(
    [Parameter(Position = 0)]
    [string] $Command = "list",

    [Parameter(Position = 1)]
    [string] $Name = "",

    [string] $TargetRepo = (Get-Location).Path,

    [string] $Pack = "",

    [string[]] $Tools = @("all"),

    [switch] $CreateMissing,

    [switch] $SkipMissing,

    [switch] $DryRun,

    [string] $InstallDir = "",

    [string] $ShimAction = "",

    [switch] $AddToUserPath
)

$ErrorActionPreference = "Stop"

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$repoRoot = Split-Path -Parent $scriptDir
$baselinesRoot = Join-Path $repoRoot "baselines"
$targetRepoWasProvided = $PSBoundParameters.ContainsKey("TargetRepo")
$toolsWereProvided = $PSBoundParameters.ContainsKey("Tools")

function Show-Usage {
    Write-Output @"
Usage:
  baseline list
  baseline show [pack|all]
  baseline apply <pack|all> [-Tools codex,claude,copilot|all] [-TargetRepo <path>] [-DryRun] [-SkipMissing]
  baseline remove <pack|all> [-Tools codex,claude,copilot|all] [-TargetRepo <path>] [-DryRun]
  baseline verify [pack|all] [-Tools codex,claude,copilot|all] [-TargetRepo <path>]
  baseline apply-all [-Tools codex,claude,copilot|all] [-TargetRepo <path>] [-DryRun] [-SkipMissing]
  baseline shim install|verify|remove [-AddToUserPath] [-InstallDir <path>]
  baseline help

Compatibility:
  -Pack and -Tools are still supported.
  When -Tools is omitted, commands use all supported tools: codex, claude, copilot.
  Missing target instruction files are created unless -SkipMissing is passed.
  -CreateMissing is still accepted for older scripts, but is no longer needed.
"@
}

function Write-FriendlyError($Message) {
    [Console]::Error.WriteLine("baseline: $Message")

    if ($Message -like "Unknown portable baseline pack:*") {
        [Console]::Error.WriteLine("Suggestion: run 'baseline list' to see available packs.")
    } elseif ($Message -like "Multiple portable baseline packs are available:*") {
        [Console]::Error.WriteLine("Suggestion: pass a pack name, for example 'baseline show karpathy-principles'.")
    } elseif ($Message -like "Unsupported tool*") {
        [Console]::Error.WriteLine("Suggestion: use -Tools codex,claude,copilot or -Tools all.")
    } elseif ($Message -like "Both baseline and legacy portable-agent-baseline blocks exist*") {
        [Console]::Error.WriteLine("Suggestion: remove one duplicate managed block manually, then rerun the command.")
    } elseif ($Message -like "Unknown command:*") {
        [Console]::Error.WriteLine("Suggestion: run 'baseline help'.")
    } elseif ($Message -like "Unknown shim action:*") {
        [Console]::Error.WriteLine("Suggestion: use 'baseline shim install', 'baseline shim verify', or 'baseline shim remove'.")
    } elseif ($Message -like "Choose either -SkipMissing or -CreateMissing*") {
        [Console]::Error.WriteLine("Suggestion: omit both to create missing instruction files, or pass -SkipMissing to leave them absent.")
    }
}

function Invoke-BaselineCommand {
    if ($Command -eq "apply-all") {
        $Command = "apply"
        if (-not $Pack) {
            $script:Pack = "all"
        }
    }

    $validCommands = @("list", "show", "apply", "remove", "verify", "shim", "help", "--help", "-h")
    if ($validCommands -notcontains $Command) {
        throw "Unknown command: $Command"
    }

    if (@("help", "--help", "-h") -contains $Command) {
        Show-Usage
        return
    }

    if ($SkipMissing -and $CreateMissing) {
        throw "Choose either -SkipMissing or -CreateMissing, not both."
    }

    if (@("show", "apply", "remove", "verify") -contains $Command) {
        if ($Name -and -not $Pack) {
            $script:Pack = $Name
        }
    }

    if ($Command -eq "shim") {
        if ($Name) {
            $script:ShimAction = $Name
        } elseif (-not $ShimAction) {
            $script:ShimAction = "install"
        }
    }

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

function Get-ToolMap {
    return @{
        claude = "CLAUDE.md"
        codex = "AGENTS.md"
        copilot = ".github\copilot-instructions.md"
    }
}

function Test-BaselineInstalled($ResolvedTargetRepo, $PackName, $ToolName) {
    $toolMap = Get-ToolMap
    if (-not $toolMap.ContainsKey($ToolName)) {
        return $false
    }

    $targetPath = Join-Path $ResolvedTargetRepo $toolMap[$ToolName]
    if (-not (Test-Path -LiteralPath $targetPath)) {
        return $false
    }

    $text = Read-Utf8Text $targetPath
    $escapedPack = [regex]::Escape($PackName)
    return (
        [regex]::IsMatch($text, "<!-- BEGIN baseline:$escapedPack v[^>]+ -->") -or
        [regex]::IsMatch($text, "<!-- BEGIN portable-agent-baseline:$escapedPack v[^>]+ -->")
    )
}

function Format-StatusCell($ToolName, $Installed) {
    $marker = if ($Installed) { "+" } else { " " }
    return ("[{0} {1}]" -f $ToolName, $marker)
}

if (@("show", "apply", "remove", "verify") -contains $Command) {
    if ($Command -eq "verify" -and -not $Pack) {
        $Pack = "all"
    }
    $Packs = Resolve-PackNames $Pack
    $Tools = Normalize-Tools $Tools
}

switch ($Command) {
    "list" {
        $resolvedTarget = (Resolve-Path -LiteralPath $TargetRepo).Path
        $listTools = if ($toolsWereProvided) { Normalize-Tools $Tools } else { @("claude", "codex", "copilot") }

        Write-Output "Available packs  (target: $resolvedTarget)"
        Write-Output ""
        Get-PackNames | ForEach-Object {
            $packName = $_
            $packInfo = Read-PackJson $packName
            $cells = @()
            foreach ($tool in $listTools) {
                $cells += Format-StatusCell $tool (Test-BaselineInstalled $resolvedTarget $packName $tool)
            }
            Write-Output ("{0,-40} v{1,-8} {2}" -f $packInfo.name, $packInfo.version, ($cells -join "  "))
        }
        Write-Output ""
        Write-Output "Legend: [+ applied]  [ absent]"
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
            & $applyScript -TargetRepo $TargetRepo -Pack $packName -Tools $Tools -CreateMissing:$CreateMissing -SkipMissing:$SkipMissing -DryRun:$DryRun
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
            $verifyArgs = @{
                Pack = $packName
                Tools = $Tools
            }
            $currentDir = (Resolve-Path -LiteralPath (Get-Location).Path).Path
            $resolvedRepoRoot = (Resolve-Path -LiteralPath $repoRoot).Path
            if ($targetRepoWasProvided -or ($currentDir -ne $resolvedRepoRoot)) {
                $verifyArgs.TargetRepo = $TargetRepo
            }

            & $verifyScript @verifyArgs
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
}

try {
    Invoke-BaselineCommand
} catch {
    Write-FriendlyError $_.Exception.Message
    exit 1
}
