<#
    .Synopsis
        Split the path content for readability.
    .Description
        Split the path content for readability.
    .Example
        PS C:\> Read-Path
        Splits the the $env:PATH into an easily readable multiline string.
#>
function Read-Path {
    [CmdletBinding()]
    param (
    )

    begin {
        Write-LogMessage -Message "Started execution"
    }

    process {
        return ($env:Path).Split(';')
    }

    end {
        Write-LogMessage -Message "Finished execution"
    }
}
