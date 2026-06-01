# Regenerate files-manifest.json after adding new .md files
$root = Split-Path $PSScriptRoot -Parent
$files = Get-ChildItem -Path $root -Recurse -File -Filter '*.md' | Where-Object {
    $_.FullName -notlike '*\web\index.html'
}

function Get-PartForPath($rel) {
    if ($rel -match 'part-01-foundations|/00-|/01-|/02-|/03-|/04-|module-0[0-4]|module-00') { return 'I' }
    if ($rel -match 'part-02-core-architecture|/05-|/06-|/07-|/08-|/09-|/10-|module-0[5-9]|module-10') { return 'II' }
    if ($rel -match 'part-03-production|/11-|/12-|/13-|/14-|/15-|module-1[1-5]') { return 'III' }
    if ($rel -match 'part-04-advanced|/16-|/17-|/18-|/19-|/20-|/21-|module-1[6-9]|module-2[01]|capstone') { return 'IV' }
    return 'all'
}

function Get-CategoryForPath($rel) {
    if ($rel -like 'docs/appendices/*') { return 'appendices' }
    if ($rel -like 'exercises/solutions/*') { return 'solutions' }
    if ($rel -like 'exercises/*') { return 'exercises' }
    if ($rel -like 'docs/*') { return 'docs' }
    if ($rel -like 'theory/*') { return 'theory' }
    return 'root'
}

$items = foreach ($f in $files) {
    $rel = $f.FullName.Substring($root.Length + 1).Replace('\', '/')
    if ($rel -like 'web/files-manifest.json') { continue }
    [PSCustomObject]@{
        path     = $rel
        name     = $f.Name
        ext      = $f.Extension
        category = Get-CategoryForPath $rel
        part     = Get-PartForPath $rel
        title    = $f.BaseName
    }
}

$items | ConvertTo-Json -Depth 3 | Set-Content -Path "$PSScriptRoot\files-manifest.json" -Encoding UTF8
Write-Host "Wrote $($items.Count) entries to web/files-manifest.json"
