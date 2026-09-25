<#
.SYNOPSIS
    Installs the /ultra skill and its three subagents for Google Antigravity.
.DESCRIPTION
    Global (default): ~\.gemini\config\skills\ultra + ~\.gemini\config\agents\ultra-*
    -Project DIR:     DIR\.agents\skills\ultra      + DIR\.agents\agents\ultra-*
    Run it from a clone of this repo. When piped (irm ... | iex) it downloads the repo first.
.EXAMPLE
    .\install.ps1
.EXAMPLE
    .\install.ps1 -Project C:\code\my-app
#>
param([string]$Project)

$ErrorActionPreference = 'Stop'
$ArchiveUrl = 'https://github.com/cekYc/GeminiUltra/archive/refs/heads/main.zip'
$Agents = 'ultra-worker', 'ultra-critic', 'ultra-verifier'

if ($Project) {
    if (-not (Test-Path -LiteralPath $Project -PathType Container)) { throw "Not a directory: $Project" }
    $Dest = Join-Path (Resolve-Path -LiteralPath $Project).ProviderPath '.agents'
} else {
    $Dest = Join-Path $HOME '.gemini\config'
}

$Src = $null
if ($PSScriptRoot) { $Src = Join-Path $PSScriptRoot '.agents' }
$Tmp = $null
try {
    if (-not $Src -or -not (Test-Path -LiteralPath (Join-Path $Src 'skills\ultra\SKILL.md'))) {
        $Tmp = Join-Path ([IO.Path]::GetTempPath()) ('ultra-install-' + [Guid]::NewGuid().ToString('N'))
        New-Item -ItemType Directory -Path $Tmp | Out-Null
        $Zip = Join-Path $Tmp 'repo.zip'
        Write-Host "Downloading $ArchiveUrl"
        [Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12
        Invoke-WebRequest -Uri $ArchiveUrl -OutFile $Zip -UseBasicParsing
        Expand-Archive -LiteralPath $Zip -DestinationPath $Tmp
        $Src = Join-Path $Tmp 'GeminiUltra-main\.agents'
        if (-not (Test-Path -LiteralPath (Join-Path $Src 'skills\ultra\SKILL.md'))) {
            throw 'Downloaded archive has no .agents\skills\ultra\SKILL.md'
        }
    }

    $Items = @('skills\ultra') + @($Agents | ForEach-Object { "agents\$_" })
    if ([IO.Path]::GetFullPath($Src).TrimEnd('\') -ieq [IO.Path]::GetFullPath($Dest).TrimEnd('\')) {
        Write-Host "Source and target are the same ($Dest); nothing to copy."
    } else {
        foreach ($item in $Items) {
            $target = Join-Path $Dest $item
            if (Test-Path -LiteralPath $target) { Remove-Item -LiteralPath $target -Recurse -Force }
            New-Item -ItemType Directory -Force -Path (Split-Path -Parent $target) | Out-Null
            Copy-Item -LiteralPath (Join-Path $Src $item) -Destination $target -Recurse
        }
    }
} finally {
    if ($Tmp -and (Test-Path -LiteralPath $Tmp)) { Remove-Item -LiteralPath $Tmp -Recurse -Force }
}

# Older releases of this repo installed "gemini-ultra", which also claims /ultra.
$Legacy = Join-Path $Dest 'skills\gemini-ultra'
if (Test-Path -LiteralPath $Legacy) {
    Remove-Item -LiteralPath $Legacy -Recurse -Force
    Write-Host "Removed old skill: $Legacy"
}

Write-Host 'Installed:'
foreach ($file in @('skills\ultra\SKILL.md') + @($Agents | ForEach-Object { "agents\$_\agent.md" })) {
    $path = Join-Path $Dest $file
    if (-not (Test-Path -LiteralPath $path)) { throw "Missing after install: $path" }
    Write-Host "  $path"
}
Write-Host 'Open a project in Antigravity and type: /ultra <task>'
