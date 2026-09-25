<#
.SYNOPSIS
    Removes the /ultra skill and its three subagents.
.EXAMPLE
    .\uninstall.ps1
.EXAMPLE
    .\uninstall.ps1 -Project C:\code\my-app
#>
param([string]$Project)

$ErrorActionPreference = 'Stop'

if ($Project) {
    if (-not (Test-Path -LiteralPath $Project -PathType Container)) { throw "Not a directory: $Project" }
    $Dest = Join-Path (Resolve-Path -LiteralPath $Project).ProviderPath '.agents'
} else {
    $Dest = Join-Path $HOME '.gemini\config'
}

# Never delete this repo's own sources.
if ($PSScriptRoot -and
    [IO.Path]::GetFullPath($Dest).TrimEnd('\') -ieq [IO.Path]::GetFullPath((Join-Path $PSScriptRoot '.agents')).TrimEnd('\')) {
    throw "$Dest holds this repo's sources; refusing to delete them"
}

$Removed = $false
# skills\gemini-ultra is what older releases of this repo installed.
foreach ($item in 'skills\ultra', 'agents\ultra-worker', 'agents\ultra-critic', 'agents\ultra-verifier', 'skills\gemini-ultra') {
    $path = Join-Path $Dest $item
    if (Test-Path -LiteralPath $path) {
        Remove-Item -LiteralPath $path -Recurse -Force
        Write-Host "Removed $path"
        $Removed = $true
    }
}
if (-not $Removed) { Write-Host "Nothing to remove in $Dest" }
