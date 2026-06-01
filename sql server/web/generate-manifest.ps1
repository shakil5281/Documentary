# Regenerate files-manifest.json after adding new .md or .sql files
$root = Split-Path $PSScriptRoot -Parent
$files = Get-ChildItem -Path $root -Recurse -File | Where-Object {
    $_.Extension -in '.md', '.sql' -and $_.FullName -notlike '*\web\index.html'
}
$items = foreach ($f in $files) {
    $rel = $f.FullName.Substring($root.Length + 1).Replace('\', '/')
    if ($rel -like 'web/files-manifest.json' -or $rel -like 'web/content-bundle.js') { continue }
    $cat = if ($rel -like 'sql/*') { 'sql' }
           elseif ($rel -like 'exercises/solutions/*') { 'solutions' }
           elseif ($rel -like 'exercises/*') { 'exercises' }
           elseif ($rel -like 'docs/*') { 'docs' }
           else { 'root' }
    $part = if ($rel -match 'part-01|/00-|/01-|/02-|module-0[0-3]|module-00') { 'I' }
            elseif ($rel -match 'part-02|/04-|/06-|module-0[4-6]') { 'II' }
            elseif ($rel -match 'part-03|03-server|05-security|06-prod|module-0[7-9]|module-10') { 'III' }
            elseif ($rel -match 'part-04|/11-|/12-|/13-|/14-|module-1[1-4]|capstone|ecommerce|school|library') { 'IV' }
            else { 'all' }
    [PSCustomObject]@{ path = $rel; name = $f.Name; ext = $f.Extension; category = $cat; part = $part; title = $f.BaseName }
}
$items | ConvertTo-Json -Depth 3 | Set-Content -Path "$PSScriptRoot\files-manifest.json" -Encoding UTF8
Write-Host "Wrote $($items.Count) entries to web/files-manifest.json"
