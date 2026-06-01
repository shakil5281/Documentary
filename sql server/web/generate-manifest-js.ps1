# Embed files-manifest.json as manifest-bundle.js (works without HTTP server)
$manifestPath = Join-Path $PSScriptRoot "files-manifest.json"
if (-not (Test-Path $manifestPath)) {
    & "$PSScriptRoot\generate-manifest.ps1"
}
$json = Get-Content $manifestPath -Raw
$js = "window.FILES_MANIFEST = $json;"
$out = Join-Path $PSScriptRoot "manifest-bundle.js"
[System.IO.File]::WriteAllText($out, $js, [System.Text.UTF8Encoding]::new($false))
Write-Host "Wrote $out"
