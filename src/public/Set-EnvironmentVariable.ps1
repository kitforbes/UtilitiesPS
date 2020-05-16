<#
    .Synopsis
        Set a value as an environment variable.
    .Description
        Set a value as an environment variable.
    .Example
        PS C:\> Set-EnvironmentVariable -Name SECRET -Value Sauce
        Sets '$env:SECRET' in the current environment session.
#>
function Set-EnvironmentVariable {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param (
        # The name of the environment vairable to set.
        [Parameter(Mandatory = $true)]
        [String]
        $Name,
        # The value of the environment vairable to set.
        [Parameter(Mandatory = $true)]
        [String]
        $Value
    )

    begin {
        Write-LogMessage -Message "Started execution"
    }

    process {
        if ($PSCmdlet.ShouldProcess("Environment", "Adding '$Name'")) {
            [Environment]::SetEnvironmentVariable("$Name", "$Value")
        }
    }

    end {
        Write-LogMessage -Message "Finished execution"
    }
}
