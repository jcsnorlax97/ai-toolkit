$ErrorActionPreference = "Stop"

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$impl = Join-Path $scriptDir "baselines\remove.ps1"
& $impl @args
