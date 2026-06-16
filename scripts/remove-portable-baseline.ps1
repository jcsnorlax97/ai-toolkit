param(
    [string] $TargetRepo = (Get-Location).Path,

    [string] $Pack = "karpathy-principles",

    [string[]] $Tools = @("codex", "claude"),

    [switch] $DryRun
)

$ErrorActionPreference = "Stop"

$toolMap = @{
    codex = "AGENTS.md"
    claude = "CLAUDE.md"
    copilot = ".github\copilot-instructions.md"
}

function Read-Utf8Text($Path) {
    return [System.IO.File]::ReadAllText($Path, [System.Text.Encoding]::UTF8)
}

function Write-Utf8Text($Path, $Text) {
    $encoding = [System.Text.UTF8Encoding]::new($false)
    [System.IO.File]::WriteAllText($Path, $Text, $encoding)
}

$resolvedTarget = (Resolve-Path -LiteralPath $TargetRepo).Path
$packName = [regex]::Escape($Pack)
$pattern = "\r?\n?\r?\n?<!-- BEGIN portable-agent-baseline:$packName v[^>]+ -->.*?<!-- END portable-agent-baseline:$packName -->\r?\n?"

foreach ($tool in $Tools) {
    if (-not $toolMap.ContainsKey($tool)) {
        throw "Unsupported tool '$tool'. Supported tools: $($toolMap.Keys -join ', ')"
    }

    $targetRel = $toolMap[$tool]
    $targetPath = Join-Path $resolvedTarget $targetRel

    if (-not (Test-Path -LiteralPath $targetPath)) {
        Write-Output "skip missing $targetRel for $tool in $resolvedTarget"
        continue
    }

    $current = Read-Utf8Text $targetPath
    if (-not [regex]::IsMatch($current, $pattern, [System.Text.RegularExpressions.RegexOptions]::Singleline)) {
        Write-Output "skip absent $Pack in $targetRel for $tool"
        continue
    }

    $next = [regex]::Replace($current, $pattern, [Environment]::NewLine, [System.Text.RegularExpressions.RegexOptions]::Singleline).TrimEnd() + [Environment]::NewLine

    if ($DryRun) {
        Write-Output "would remove $Pack from $targetRel for $tool"
        continue
    }

    Write-Utf8Text $targetPath $next
    Write-Output "removed $Pack from $targetRel for $tool"
}
