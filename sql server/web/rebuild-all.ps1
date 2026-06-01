# Regenerate manifest + offline bundle (run after adding/editing docs or SQL)
& "$PSScriptRoot\generate-manifest.ps1"
& "$PSScriptRoot\generate-manifest-js.ps1"
& "$PSScriptRoot\generate-content-bundle.ps1"
& "$PSScriptRoot\verify.ps1"
