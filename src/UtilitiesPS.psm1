if (-not $PSScriptRoot) {
    $PSScriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
}

$privateFunctions = @()
if (Test-Path -Path (Join-Path -Path $PSScriptRoot -ChildPath 'private')) {
    $privateFunctions = @(Get-ChildItem -Path (Join-Path -Path $PSScriptRoot -ChildPath 'private') -Filter '*.ps1' -File -ErrorAction Stop)
}

$publicFunctions = @()
if (Test-Path -Path (Join-Path -Path $PSScriptRoot -ChildPath 'public')) {
    $publicFunctions = @(Get-ChildItem -Path (Join-Path -Path $PSScriptRoot -ChildPath 'public') -Filter '*.ps1' -File -ErrorAction Stop)
}

foreach ($function in @($privateFunctions + $publicFunctions)) {
    try {
        . $function.FullName
    }
    catch {
        throw "Unable to dot source [$($function.FullName)]"
    }
}

foreach ($function in $publicFunctions) {
    Export-ModuleMember -Function $function.BaseName
}
