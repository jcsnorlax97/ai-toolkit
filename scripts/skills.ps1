param(
    [Parameter(Position = 0)]
    [ValidateSet("list", "show", "install", "verify")]
    [string] $Command = "list",

    [Parameter(Position = 1)]
    [string] $Name = "",

    [ValidateSet("codex", "claude", "copilot", "all")]
    [string] $Target = "all",

    [ValidateSet("personal", "project")]
    [string] $Scope = "personal",

    [string] $TargetRepo = (Get-Location).Path,

    [switch] $Copy,

    [switch] $Link,

    [switch] $KeepExisting
)

$ErrorActionPreference = "Stop"

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$repoRoot = Split-Path -Parent $scriptDir
$skillsRoot = Join-Path $repoRoot "skills\engineering"

function Read-Utf8Text($Path) {
    return [System.IO.File]::ReadAllText($Path, [System.Text.Encoding]::UTF8)
}

function Get-SkillDirs {
    if (-not (Test-Path -LiteralPath $skillsRoot)) {
        throw "Missing skills directory: $skillsRoot"
    }

    return @(Get-ChildItem -LiteralPath $skillsRoot -Directory | Where-Object {
        Test-Path -LiteralPath (Join-Path $_.FullName "SKILL.md")
    })
}

function Resolve-SkillDir($SkillName) {
    if (-not $SkillName) {
        throw "Pass a skill name."
    }

    $path = Join-Path $skillsRoot $SkillName
    $skillFile = Join-Path $path "SKILL.md"
    if (-not (Test-Path -LiteralPath $skillFile)) {
        throw "Unknown skill: $SkillName"
    }

    return $path
}

function Get-FrontmatterValue($Content, $Field) {
    $pattern = "(?m)^$([regex]::Escape($Field)):\s*(.+?)\s*$"
    $match = [regex]::Match($Content, $pattern)
    if ($match.Success) {
        return $match.Groups[1].Value
    }

    return ""
}

function Get-BashPath {
    $gitBash = "C:\Program Files\Git\bin\bash.exe"
    if (Test-Path -LiteralPath $gitBash) {
        return $gitBash
    }

    $bashCommand = Get-Command bash -ErrorAction SilentlyContinue
    if ($bashCommand) {
        return $bashCommand.Source
    }

    throw "Git Bash or bash is required for personal skill installation."
}

function Convert-ToBashPath($Path) {
    $bashPath = $Path -replace "\\", "/"
    if ($bashPath -match "^([A-Za-z]):/(.*)$") {
        $drive = $matches[1].ToLowerInvariant()
        $rest = $matches[2]
        return "/$drive/$rest"
    }

    return $bashPath
}

function Invoke-SkillInstallScript($ScriptName, $VerifyOnly) {
    $scriptPath = Join-Path $scriptDir $ScriptName
    if (-not (Test-Path -LiteralPath $scriptPath)) {
        throw "Missing install script: $scriptPath"
    }

    $bash = Get-BashPath
    $bashScriptPath = Convert-ToBashPath $scriptPath

    $args = @()
    if ($VerifyOnly) {
        $args += "--verify-only"
    }
    if ($Copy) {
        $args += "--copy"
    }
    if ($Link) {
        $args += "--link"
    }
    if ($KeepExisting) {
        $args += "--keep-existing"
    }

    & $bash $bashScriptPath @args
    if ($LASTEXITCODE -ne 0) {
        throw "$ScriptName failed with exit code $LASTEXITCODE"
    }
}

function Get-Targets {
    if ($Target -eq "all") {
        return @("codex", "claude", "copilot")
    }

    return @($Target)
}

function Install-PersonalTarget($TargetName, $VerifyOnly) {
    switch ($TargetName) {
        "codex" {
            Invoke-SkillInstallScript "install-codex-skills.sh" $VerifyOnly
        }
        "claude" {
            Invoke-SkillInstallScript "install-claude-code-skills.sh" $VerifyOnly
        }
        "copilot" {
            if ($Target -eq "all") {
                Write-Warning "Skipping Copilot personal install: this repo does not define a Copilot skills runtime directory yet."
                return
            }
            throw "Copilot does not have a supported personal skills runtime directory in this repo yet."
        }
    }
}

function Install-ProjectTarget($TargetName, $VerifyOnly) {
    switch ($TargetName) {
        "claude" {
            $targetSkills = Join-Path $TargetRepo ".claude\skills"
            if ($VerifyOnly) {
                if (-not (Test-Path -LiteralPath $targetSkills)) {
                    throw "Missing project Claude skills directory: $targetSkills"
                }
                Write-Output "project claude skills ok: $targetSkills"
                return
            }

            throw "Project Claude skill adapter installation is not automated yet; use this repo's .claude/skills adapter as the model."
        }
        "codex" {
            if ($Target -eq "all") {
                Write-Warning "Skipping Codex project install: this repo does not define project-local Codex skills yet."
                return
            }
            throw "Codex project-local skills are not supported by this repo yet."
        }
        "copilot" {
            if ($Target -eq "all") {
                Write-Warning "Skipping Copilot project install: use baselines for Copilot instruction blocks until a skills contract exists."
                return
            }
            throw "Copilot project-local skills are not supported by this repo yet; use baselines for Copilot instruction blocks."
        }
    }
}

switch ($Command) {
    "list" {
        Get-SkillDirs | ForEach-Object {
            $skillFile = Join-Path $_.FullName "SKILL.md"
            $content = Read-Utf8Text $skillFile
            $description = Get-FrontmatterValue $content "description"
            Write-Output "$($_.Name) - $description"
        }
    }
    "show" {
        $skillDir = Resolve-SkillDir $Name
        Write-Output (Read-Utf8Text (Join-Path $skillDir "SKILL.md")).Trim()
    }
    "install" {
        foreach ($targetName in (Get-Targets)) {
            if ($Scope -eq "personal") {
                Install-PersonalTarget $targetName $false
            } else {
                Install-ProjectTarget $targetName $false
            }
        }
    }
    "verify" {
        $verifyScript = Join-Path $scriptDir "verify-skills.sh"
        if (-not (Test-Path -LiteralPath $verifyScript)) {
            throw "Missing verify script: $verifyScript"
        }

        & (Get-BashPath) (Convert-ToBashPath $verifyScript)
        if ($LASTEXITCODE -ne 0) {
            throw "verify-skills.sh failed with exit code $LASTEXITCODE"
        }

        $verifyInstall = $PSBoundParameters.ContainsKey("Target") -or $PSBoundParameters.ContainsKey("Scope")
        if ($verifyInstall) {
            foreach ($targetName in (Get-Targets)) {
                if ($Scope -eq "personal") {
                    Install-PersonalTarget $targetName $true
                } else {
                    Install-ProjectTarget $targetName $true
                }
            }
        }
    }
}
