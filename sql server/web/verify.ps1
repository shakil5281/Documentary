# Verify web viewer assets are in sync
$root = Split-Path $PSScriptRoot -Parent
$errors = @()

$required = @(
    "web\index.html",
    "web\files-manifest.json",
    "web\manifest-bundle.js",
    "web\content-bundle.js",
    "web\serve.ps1",
    "web\serve.bat"
)
foreach ($f in $required) {
    if (-not (Test-Path (Join-Path $root $f))) { $errors += "Missing: $f" }
}

$disk = Get-ChildItem -Path $root -Recurse -File | Where-Object { $_.Extension -in '.md', '.sql' }
$manifest = Get-Content (Join-Path $root "web\files-manifest.json") -Raw | ConvertFrom-Json
if ($disk.Count -ne $manifest.Count) {
    $errors += "Manifest count $($manifest.Count) != disk $($disk.Count). Run generate-manifest.ps1"
}

$bundle = Get-Content (Join-Path $root "web\content-bundle.js") -Raw
$testPaths = @(
    "docs/02-sql-fundamentals.md",
    "sql/01-create-sample-database.sql",
    "SYLLABUS.md",
    "POST-NEXT-STEPS.md"
)
foreach ($p in $testPaths) {
    if ($bundle -notmatch [regex]::Escape('"' + $p + '"')) {
        $errors += "Bundle missing key: $p. Run generate-content-bundle.ps1"
    }
}

if ($errors.Count) {
    Write-Host "FAILED:" -ForegroundColor Red
    $errors | ForEach-Object { Write-Host "  $_" }
    exit 1
}

Write-Host "OK: Web viewer ready ($($manifest.Count) files in manifest + bundle)" -ForegroundColor Green
Write-Host "  Open: web\index.html (offline) or run web\serve.bat"
