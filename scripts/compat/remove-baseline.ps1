$ErrorActionPreference = "Stop"

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$scriptsRoot = Split-Path -Parent $scriptDir
$impl = Join-Path $scriptsRoot "baselines\remove.ps1"
& $impl @args
