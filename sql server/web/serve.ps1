# Start local web server from PROJECT ROOT (required for live fetch)
$root = Split-Path $PSScriptRoot -Parent
Set-Location $root

if (-not (Test-Path "web\content-bundle.js")) { & "$PSScriptRoot\generate-content-bundle.ps1" }
if (-not (Test-Path "web\manifest-bundle.js")) { & "$PSScriptRoot\generate-manifest-js.ps1" }

$port = 8080
$url = "http://localhost:$port/web/index.html"
Write-Host ""
Write-Host "  SQL Server Learning Viewer"
Write-Host "  Root folder: $root"
Write-Host "  Open: $url"
Write-Host "  Press Ctrl+C to stop."
Write-Host ""

$python = Get-Command python -ErrorAction SilentlyContinue
if (-not $python) { $python = Get-Command py -ErrorAction SilentlyContinue }
if ($python) {
    Start-Process $url
    & $python.Source -m http.server $port
} else {
    Write-Host "Python not found. Install Python 3, or open web/index.html (uses offline bundle)."
    Write-Host "Docs load from content-bundle.js without a server."
    pause
}
