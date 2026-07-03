param(
    [Parameter(Position = 0)]
    [string] $Command = "list",

    [Parameter(Position = 1)]
    [string] $Name = "",

    [string] $TargetRepo = (Get-Location).Path,

    [string] $Pack = "",

    [string[]] $Tools = @("claude"),

    [string] $Scope = "project",

    [switch] $DryRun,

    [string] $InstallDir = "",

    [string] $ShimAction = "",

    [switch] $AddToUserPath
)

$ErrorActionPreference = "Stop"

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$repoRoot = Split-Path -Parent $scriptDir
$hooksRoot = Join-Path $repoRoot "hooks"
$targetRepoWasProvided = $PSBoundParameters.ContainsKey("TargetRepo")
$toolsWereProvided = $PSBoundParameters.ContainsKey("Tools")
$scopeWasProvided = $PSBoundParameters.ContainsKey("Scope")

function Show-Usage {
    Write-Output @"
Usage:
  hooks list
  hooks show [pack|all]
  hooks apply <pack|all> [-Tools claude] [-Scope project|user] [-TargetRepo <path>] [-DryRun]
  hooks remove <pack|all> [-Tools claude] [-Scope project|user] [-TargetRepo <path>] [-DryRun]
  hooks verify [pack|all] [-Tools claude] [-Scope project|user] [-TargetRepo <path>]
  hooks shim install|verify|remove [-AddToUserPath] [-InstallDir <path>]
  hooks help

Notes:
  -Tools defaults to claude (the only tool with full hook support).
  -Scope defaults to project (writes to <target-repo>/.claude/settings.json).
  Use -Scope user to write to ~/.claude/settings.json instead.
  Codex hook support is not yet implemented.
  Copilot does not support shell hooks.
"@
}

function Write-FriendlyError($Message) {
    [Console]::Error.WriteLine("hooks: $Message")

    if ($Message -like "Unknown hook pack:*") {
        [Console]::Error.WriteLine("Suggestion: run 'hooks list' to see available packs.")
    } elseif ($Message -like "Multiple hook packs are available:*") {
        [Console]::Error.WriteLine("Suggestion: pass a pack name, for example 'hooks show ensure-vercel-cli'.")
    } elseif ($Message -like "Unsupported tool*") {
        [Console]::Error.WriteLine("Suggestion: use -Tools claude.")
    } elseif ($Message -like "Unknown command:*") {
        [Console]::Error.WriteLine("Suggestion: run 'hooks help'.")
    } elseif ($Message -like "Unknown shim action:*") {
        [Console]::Error.WriteLine("Suggestion: use 'hooks shim install', 'hooks shim verify', or 'hooks shim remove'.")
    } elseif ($Message -like "Unknown scope:*") {
        [Console]::Error.WriteLine("Suggestion: use -Scope project or -Scope user.")
    }
}

function Read-Utf8Text($Path) {
    return [System.IO.File]::ReadAllText($Path, [System.Text.Encoding]::UTF8)
}

function Write-Utf8Text($Path, $Text) {
    $encoding = [System.Text.UTF8Encoding]::new($false)
    $dir = Split-Path -Parent $Path
    if ($dir -and -not (Test-Path -LiteralPath $dir)) {
        New-Item -ItemType Directory -Path $dir -Force | Out-Null
    }
    [System.IO.File]::WriteAllText($Path, $Text, $encoding)
}

function Get-PackRoot($PackName) {
    return Join-Path $hooksRoot $PackName
}

function Read-PackJson($PackName) {
    $packPath = Join-Path (Get-PackRoot $PackName) "pack.json"
    if (-not (Test-Path -LiteralPath $packPath)) {
        throw "Unknown hook pack: $PackName"
    }
    return (Read-Utf8Text $packPath | ConvertFrom-Json)
}

function Get-PackNames {
    if (-not (Test-Path -LiteralPath $hooksRoot)) {
        throw "Missing hooks directory: $hooksRoot"
    }

    return @(Get-ChildItem -LiteralPath $hooksRoot -Directory | Where-Object {
        Test-Path -LiteralPath (Join-Path $_.FullName "pack.json")
    } | ForEach-Object {
        $_.Name
    })
}

function Resolve-PackNames($ResolvedName) {
    if ($ResolvedName) {
        if ($ResolvedName -eq "all") {
            return @(Get-PackNames)
        }

        $null = Read-PackJson $ResolvedName
        return @($ResolvedName)
    }

    $packNames = @(Get-PackNames)
    if ($packNames.Count -eq 0) {
        throw "No hook packs found in: $hooksRoot"
    }
    if ($packNames.Count -eq 1) {
        return @($packNames[0])
    }

    throw "Multiple hook packs are available: $($packNames -join ', '). Pass -Pack <name>."
}

function Normalize-Tools($ToolValues) {
    $supportedTools = @("claude", "codex", "copilot")
    $normalized = @()
    foreach ($toolValue in $ToolValues) {
        foreach ($tool in ($toolValue -split ",")) {
            $trimmed = $tool.Trim()
            if (-not $trimmed) {
                continue
            }

            if ($trimmed -eq "all") {
                foreach ($toolName in $supportedTools) {
                    if ($normalized -notcontains $toolName) {
                        $normalized += $toolName
                    }
                }
                continue
            }

            if ($supportedTools -notcontains $trimmed) {
                throw "Unsupported tool '$trimmed'. Supported tools: $($supportedTools -join ', '), all"
            }

            if ($normalized -notcontains $trimmed) {
                $normalized += $trimmed
            }
        }
    }

    return $normalized
}

function Get-SettingsPath($ToolName, $ResolvedScope, $ResolvedTargetRepo) {
    if ($ToolName -eq "claude") {
        if ($ResolvedScope -eq "user") {
            return Join-Path $HOME ".claude/settings.json"
        } else {
            return Join-Path $ResolvedTargetRepo ".claude/settings.json"
        }
    }
    return $null
}

function Get-HookMarker($PackName) {
    return "# ai-toolkit-hook:$PackName"
}

function Test-HookInstalled($ToolName, $PackName, $ResolvedScope, $ResolvedTargetRepo) {
    if ($ToolName -ne "claude") {
        return $false
    }

    $settingsPath = Get-SettingsPath $ToolName $ResolvedScope $ResolvedTargetRepo
    if (-not (Test-Path -LiteralPath $settingsPath)) {
        return $false
    }

    $text = Read-Utf8Text $settingsPath
    $marker = Get-HookMarker $PackName
    return $text -like "*$marker*"
}

function Format-StatusCell($Label, $Value) {
    return ("[{0} {1}]" -f $Label, $Value)
}

function Invoke-HooksCommand {
    $validCommands = @("list", "show", "apply", "remove", "verify", "shim", "help", "--help", "-h")
    if ($validCommands -notcontains $Command) {
        throw "Unknown command: $Command"
    }

    if (@("help", "--help", "-h") -contains $Command) {
        Show-Usage
        return
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

    $resolvedScope = $Scope
    if ($resolvedScope -notin @("project", "user")) {
        throw "Unknown scope: $resolvedScope. Use project or user."
    }

    switch ($Command) {
        "list" {
            $resolvedTarget = (Resolve-Path -LiteralPath $TargetRepo).Path
            $listTools = if ($toolsWereProvided) { Normalize-Tools $Tools } else { @("claude", "codex", "copilot") }

            Write-Output "Available hook packs  (target: $resolvedTarget, scope: $resolvedScope)"
            Write-Output ""

            Get-PackNames | ForEach-Object {
                $packName = $_
                $packInfo = Read-PackJson $packName
                $cells = @()
                foreach ($tool in $listTools) {
                    $status = switch ($tool) {
                        "codex"    { "n/i" }
                        "copilot"  { "n/a" }
                        default    { if (Test-HookInstalled $tool $packName $resolvedScope $resolvedTarget) { "+" } else { " " } }
                    }
                    $cells += Format-StatusCell $tool $status
                }
                Write-Output ("{0,-40} v{1,-8} {2}" -f $packInfo.name, $packInfo.version, ($cells -join "  "))
            }

            Write-Output ""
            Write-Output "Legend: [+ applied]  [ absent]  [n/i not yet implemented]  [n/a not applicable]"
        }

        "show" {
            $packs = Resolve-PackNames $Pack
            foreach ($packName in $packs) {
                $packInfo = Read-PackJson $packName
                $hookPath = Join-Path (Get-PackRoot $packName) "hook.md"
                Write-Output "# $($packInfo.name) $($packInfo.version) [$($packInfo.status)]"
                Write-Output ""
                Write-Output $packInfo.description
                Write-Output ""
                Write-Output "Adapters:"
                $packInfo.adapters.PSObject.Properties | ForEach-Object {
                    Write-Output "- $($_.Name): $($_.Value)"
                }
                Write-Output ""
                Write-Output (Read-Utf8Text $hookPath).Trim()
                Write-Output ""
            }
        }

        "apply" {
            $packs = Resolve-PackNames $Pack
            $resolvedTools = Normalize-Tools $Tools
            $resolvedTarget = (Resolve-Path -LiteralPath $TargetRepo).Path

            foreach ($packName in $packs) {
                $packInfo = Read-PackJson $packName

                foreach ($tool in $resolvedTools) {
                    if ($tool -eq "codex") {
                        Write-Output "skip $packName for codex: Codex hook support is not yet implemented"
                        continue
                    }
                    if ($tool -eq "copilot") {
                        Write-Output "skip $packName for copilot: Copilot does not support shell hooks"
                        continue
                    }

                    if (-not $packInfo.adapters.PSObject.Properties[$tool]) {
                        Write-Output "skip $packName for ${tool}: no adapter defined"
                        continue
                    }

                    $adapterRel = $packInfo.adapters.PSObject.Properties[$tool].Value
                    $adapterPath = Join-Path (Get-PackRoot $packName) $adapterRel
                    if (-not (Test-Path -LiteralPath $adapterPath)) {
                        Write-Output "skip $packName for ${tool}: adapter file missing: $adapterPath"
                        continue
                    }

                    $adapterText = Read-Utf8Text $adapterPath
                    $adapterBlock = $adapterText | ConvertFrom-Json

                    $settingsPath = Get-SettingsPath $tool $resolvedScope $resolvedTarget
                    $marker = Get-HookMarker $packName

                    # Read existing settings or start fresh
                    if (Test-Path -LiteralPath $settingsPath) {
                        $settingsText = Read-Utf8Text $settingsPath
                        $settings = $settingsText | ConvertFrom-Json
                    } else {
                        $settings = [PSCustomObject]@{}
                    }

                    # Ensure hooks key exists
                    if (-not $settings.PSObject.Properties["hooks"]) {
                        $settings | Add-Member -NotePropertyName "hooks" -NotePropertyValue ([PSCustomObject]@{})
                    }

                    $changed = $false

                    # Merge each event type from the adapter block
                    $adapterBlock.hooks.PSObject.Properties | ForEach-Object {
                        $eventType = $_.Name
                        $newEntries = $_.Value

                        if (-not $settings.hooks.PSObject.Properties[$eventType]) {
                            $settings.hooks | Add-Member -NotePropertyName $eventType -NotePropertyValue @()
                        }

                        foreach ($entry in $newEntries) {
                            # Check if an entry with this marker already exists
                            $exists = @($settings.hooks.PSObject.Properties[$eventType].Value) | Where-Object {
                                $_.command -like "*$marker*"
                            }
                            if ($exists.Count -gt 0) {
                                if ($DryRun) {
                                    Write-Output "would skip $packName ($eventType) for $tool in $($resolvedScope): already applied"
                                } else {
                                    Write-Output "skip $packName ($eventType) for $tool in ${resolvedScope}: already applied"
                                }
                                continue
                            }

                            if ($DryRun) {
                                Write-Output "would add $packName ($eventType) hook for $tool in ${resolvedScope}: $settingsPath"
                                $changed = $true
                                continue
                            }

                            $current = @($settings.hooks.PSObject.Properties[$eventType].Value)
                            $current += $entry
                            $settings.hooks.PSObject.Properties[$eventType].Value = $current
                            $changed = $true
                        }
                    }

                    if (-not $DryRun -and $changed) {
                        $json = $settings | ConvertTo-Json -Depth 10
                        Write-Utf8Text $settingsPath $json
                        Write-Output "added $packName hooks for $tool in ${resolvedScope}: $settingsPath"
                    }
                }
            }
        }

        "remove" {
            $packs = Resolve-PackNames $Pack
            $resolvedTools = Normalize-Tools $Tools
            $resolvedTarget = (Resolve-Path -LiteralPath $TargetRepo).Path

            foreach ($packName in $packs) {
                foreach ($tool in $resolvedTools) {
                    if ($tool -eq "codex") {
                        Write-Output "skip $packName for codex: Codex hook support is not yet implemented"
                        continue
                    }
                    if ($tool -eq "copilot") {
                        Write-Output "skip $packName for copilot: Copilot does not support shell hooks"
                        continue
                    }

                    $settingsPath = Get-SettingsPath $tool $resolvedScope $resolvedTarget
                    $marker = Get-HookMarker $packName

                    if (-not (Test-Path -LiteralPath $settingsPath)) {
                        Write-Output "skip $packName for $tool in ${resolvedScope}: settings file not found"
                        continue
                    }

                    $settingsText = Read-Utf8Text $settingsPath
                    $settings = $settingsText | ConvertFrom-Json

                    if (-not $settings.PSObject.Properties["hooks"]) {
                        Write-Output "skip $packName for $tool in ${resolvedScope}: no hooks section in settings"
                        continue
                    }

                    $changed = $false

                    $settings.hooks.PSObject.Properties | ForEach-Object {
                        $eventType = $_.Name
                        $entries = @($_.Value)
                        $filtered = @($entries | Where-Object { $_.command -notlike "*$marker*" })

                        if ($filtered.Count -lt $entries.Count) {
                            if ($DryRun) {
                                Write-Output "would remove $packName ($eventType) hook for $tool in ${resolvedScope}: $settingsPath"
                            } else {
                                $settings.hooks.PSObject.Properties[$eventType].Value = $filtered
                                $changed = $true
                            }
                        }
                    }

                    if (-not $DryRun -and $changed) {
                        $json = $settings | ConvertTo-Json -Depth 10
                        Write-Utf8Text $settingsPath $json
                        Write-Output "removed $packName hooks for $tool in ${resolvedScope}: $settingsPath"
                    } elseif (-not $DryRun -and -not $changed) {
                        Write-Output "skip $packName for $tool in ${resolvedScope}: no matching hooks found"
                    }
                }
            }
        }

        "verify" {
            if (-not $Pack -and -not $Name) {
                $script:Pack = "all"
            }
            $packs = Resolve-PackNames $Pack
            $resolvedTools = Normalize-Tools $Tools
            $resolvedTarget = (Resolve-Path -LiteralPath $TargetRepo).Path
            $allOk = $true

            foreach ($packName in $packs) {
                $packInfo = Read-PackJson $packName

                foreach ($tool in $resolvedTools) {
                    if ($tool -eq "codex") {
                        Write-Output "skip $packName for codex: Codex hook support is not yet implemented"
                        continue
                    }
                    if ($tool -eq "copilot") {
                        Write-Output "skip $packName for copilot: Copilot does not support shell hooks"
                        continue
                    }

                    $settingsPath = Get-SettingsPath $tool $resolvedScope $resolvedTarget
                    $marker = Get-HookMarker $packName

                    if (-not (Test-Path -LiteralPath $settingsPath)) {
                        Write-Output "missing $packName for $tool in ${resolvedScope}: settings file not found: $settingsPath"
                        $allOk = $false
                        continue
                    }

                    $settingsText = Read-Utf8Text $settingsPath
                    $settings = $settingsText | ConvertFrom-Json

                    $found = $false
                    if ($settings.PSObject.Properties["hooks"]) {
                        $settings.hooks.PSObject.Properties | ForEach-Object {
                            $entries = @($_.Value)
                            if ($entries | Where-Object { $_.command -like "*$marker*" }) {
                                $found = $true
                            }
                        }
                    }

                    if ($found) {
                        Write-Output "ok $packName for $tool in ${resolvedScope}: $settingsPath"
                    } else {
                        Write-Output "missing $packName for $tool in ${resolvedScope}: hook not found in $settingsPath"
                        $allOk = $false
                    }
                }
            }

            if (-not $allOk) {
                exit 1
            }
        }

        "shim" {
            if (@("install", "verify", "remove") -notcontains $ShimAction) {
                throw "Unknown shim action: $ShimAction. Use install, verify, or remove."
            }

            if ($IsMacOS -or $IsLinux) {
                $shimScript = Join-Path $scriptDir "hooks/install-shim.sh"
                $bashArgs = @()
                if ($InstallDir) { $bashArgs += "--install-dir"; $bashArgs += $InstallDir }
                if ($ShimAction -eq "verify") { $bashArgs += "--verify-only" }
                if ($ShimAction -eq "remove") { $bashArgs += "--remove" }
                & bash $shimScript @bashArgs
            } else {
                $shimScript = Join-Path $scriptDir "hooks\install-shim.ps1"
                $shimArgs = @{}
                if ($InstallDir) { $shimArgs.InstallDir = $InstallDir }
                if ($AddToUserPath) { $shimArgs.AddToUserPath = $true }
                if ($ShimAction -eq "verify") { $shimArgs.VerifyOnly = $true }
                if ($ShimAction -eq "remove") { $shimArgs.Remove = $true }
                & $shimScript @shimArgs
            }
        }
    }
}

try {
    Invoke-HooksCommand
} catch {
    Write-FriendlyError $_.Exception.Message
    exit 1
}
