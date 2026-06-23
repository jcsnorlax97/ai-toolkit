param(
    [string] $TargetRepo,

    [string] $Pack = "karpathy-principles",

    [string[]] $Tools = @("codex", "claude")
)

$ErrorActionPreference = "Stop"

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$repoRoot = Split-Path -Parent $scriptDir
$packRoot = Join-Path $repoRoot "portable-baselines\$Pack"

if (-not (Test-Path -LiteralPath $packRoot)) {
    throw "Unknown portable baseline pack: $Pack"
}

$packJsonPath = Join-Path $packRoot "pack.json"
$packInfo = ([System.IO.File]::ReadAllText($packJsonPath, [System.Text.Encoding]::UTF8) | ConvertFrom-Json)
$packVersion = $packInfo.version

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

$Tools = Normalize-Tools $Tools

$required = @(
    "pack.json",
    "baseline.md",
    "adapters\AGENTS.md.block",
    "adapters\CLAUDE.md.block",
    "adapters\copilot-instructions.md.block"
)

foreach ($rel in $required) {
    $path = Join-Path $packRoot $rel
    if (-not (Test-Path -LiteralPath $path)) {
        throw "Missing portable baseline file: $rel"
    }
}

$adapterFiles = @(
    (Join-Path $packRoot "adapters\AGENTS.md.block"),
    (Join-Path $packRoot "adapters\CLAUDE.md.block"),
    (Join-Path $packRoot "adapters\copilot-instructions.md.block")
)

foreach ($adapter in $adapterFiles) {
    $text = [System.IO.File]::ReadAllText($adapter, [System.Text.Encoding]::UTF8)
    if ($text -notmatch "<!-- BEGIN portable-agent-baseline:$([regex]::Escape($Pack)) v[^>]+ -->") {
        throw "Adapter missing BEGIN marker: $adapter"
    }
    if ($text -notmatch "<!-- END portable-agent-baseline:$([regex]::Escape($Pack)) -->") {
        throw "Adapter missing END marker: $adapter"
    }
}

Write-Output "pack ok: $Pack"

if ($TargetRepo) {
    $resolvedTarget = (Resolve-Path -LiteralPath $TargetRepo).Path
    $toolMap = @{
        codex = "AGENTS.md"
        claude = "CLAUDE.md"
        copilot = ".github\copilot-instructions.md"
    }
    $beginPattern = "<!-- BEGIN portable-agent-baseline:$([regex]::Escape($Pack)) v(?<version>[^ >]+) -->"
    $blockPattern = "$beginPattern.*?<!-- END portable-agent-baseline:$([regex]::Escape($Pack)) -->"

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

        $text = [System.IO.File]::ReadAllText($targetPath, [System.Text.Encoding]::UTF8)
        $match = [regex]::Match($text, $blockPattern, [System.Text.RegularExpressions.RegexOptions]::Singleline)
        if (-not $match.Success) {
            throw "Missing $Pack managed block in $targetRel"
        }

        $installedVersion = $match.Groups["version"].Value
        if ($installedVersion -ne $packVersion) {
            throw "Stale $Pack managed block in ${targetRel}: installed v$installedVersion, source v$packVersion"
        }

        Write-Output "target ok: $targetRel contains $Pack v$installedVersion"
    }
}
