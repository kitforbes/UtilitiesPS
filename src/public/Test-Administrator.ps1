<#
    .Synopsis
        Test to see if the current user is an administrator.
    .Description
        Test to see if the current user is an administrator.
    .Example
        PS C:\> Test-Administrator
        Test to see if the current user is an administrator and returns a boolean.
#>
function Test-Administrator {
    [CmdletBinding()]
    [OutputType([Boolean])]
    param (
    )

    begin {
        Write-LogMessage -Message "Started execution"
    }

    process {
        $currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
        return (New-Object Security.Principal.WindowsPrincipal $currentUser).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
    }

    end {
        Write-LogMessage -Message "Finished execution"
    }
}
