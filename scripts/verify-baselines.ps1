$ErrorActionPreference = "Stop"

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$impl = Join-Path $scriptDir "baselines\verify.ps1"
& $impl @args
