# Regenerate web/content-bundle.js so docs work without a local server
$root = Split-Path $PSScriptRoot -Parent
$ht = [ordered]@{}
Get-ChildItem -Path $root -Recurse -File | Where-Object { $_.Extension -in '.md', '.sql' } | ForEach-Object {
    $rel = $_.FullName.Substring($root.Length + 1).Replace('\', '/')
    $ht[$rel] = [System.IO.File]::ReadAllText($_.FullName, [System.Text.UTF8Encoding]::new($false))
}
$json = $ht | ConvertTo-Json -Depth 5 -Compress
$js = "window.CONTENT_BUNDLE = $json;"
$out = Join-Path $PSScriptRoot 'content-bundle.js'
[System.IO.File]::WriteAllText($out, $js, [System.Text.UTF8Encoding]::new($false))
Write-Host "Wrote $out ($([math]::Round((Get-Item $out).Length/1KB, 1)) KB)"
