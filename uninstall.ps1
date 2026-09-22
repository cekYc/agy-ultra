<#
.SYNOPSIS
    GeminiUltra Uninstaller for Windows
#>

$TargetDir = Join-Path $HOME ".gemini\config\skills\gemini-ultra"

if (Test-Path $TargetDir) {
    Remove-Item -Recurse -Force $TargetDir
    Write-Host "[OK] GeminiUltra has been successfully removed from your Antigravity skills." -ForegroundColor Green
} else {
    Write-Host "[INFO] GeminiUltra is not installed in your global skills directory." -ForegroundColor Yellow
}
