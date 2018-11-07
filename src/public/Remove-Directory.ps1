<#
    .Synopsis
        Remove a directory if it exists.
    .Description
        Remove a directory if it exists.
    .Example
        PS C:\> Remove-Directory -Path "C:\Temp\New Folder"
        Removes "New Folder" if it exists.
#>
function Remove-Directory {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param (
        # The location of the directory to remove.
        [Parameter(Mandatory = $true)]
        [String]
        $Path
    )

    begin {
        Write-LogMessage -Message "Started execution"
    }

    process {
        if ((Test-Path -Path $Path) -and $PSCmdlet.ShouldProcess($Path, "removing file")) {
            Remove-Item -Force -Path $Path -Recurse
        }
    }

    end {
        Write-LogMessage -Message "Finished execution"
    }
}
