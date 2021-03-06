[CmdletBinding()]
param (
    # The task to pass to the psake build script.
    [Parameter(Mandatory = $false)]
    [ValidateSet('Clean', 'Build', 'Sign', 'BuildHelp', 'Install', 'Test', 'Publish')]
    [String]
    $Task = 'Test',
    # NuGet API key used during publishing.
    [Parameter(Mandatory = $false)]
    [String]
    $NuGetApiKey
)

begin {
    $ConfirmPreference = 'None'
    $ProgressPreference = 'SilentlyContinue'
    $ErrorActionPreference = 'Stop'

    if ($Task -eq 'Publish') {
        if (-not [Boolean](Get-PSRepository -Name 'PSGallery' -ErrorAction SilentlyContinue)) {
            Register-PSRepository -Default
        }
    }
}

end {
    $parameters = @{
        buildFile = "$PSScriptRoot\build.psake.ps1"
        taskList  = $Task
        nologo    = $true
        notr      = $true
        Verbose   = $VerbosePreference
    }

    if ($NuGetApiKey) {
        $parameters.Add('NuGetApiKey', $NuGetApiKey)
    }

    Write-Verbose -Message "Executing '$Task' task."
    Invoke-psake @parameters
    exit !$psake.build_success
}
