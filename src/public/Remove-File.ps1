<#
    .Synopsis
        Remove a file if it exists.
    .Description
        Remove a file if it exists.
    .Example
        PS C:\> Remove-File -Path "C:\Temp\file.txt"
        Removes "file.txt" if it exists.
#>
function Remove-File {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param (
        # The location of the file to remove.
        [Parameter(Mandatory = $true)]
        [String]
        $Path
    )

    begin {
        Write-LogMessage -Message "Started execution"
    }

    process {
        if ((Test-Path -Path $Path) -and $PSCmdlet.ShouldProcess($Path, "removing file")) {
            Remove-Item -Force -Path $Path
        }
    }

    end {
        Write-LogMessage -Message "Finished execution"
    }
}
