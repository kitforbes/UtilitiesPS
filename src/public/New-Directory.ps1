<#
    .Synopsis
        Create a directory if it does not exist.
    .Description
        Create a directory if it does not exist.
    .Example
        PS C:\> New-Directory -Path "C:\Temp\New Folder"
        Creates "New Folder" if it does not exist.
#>
function New-Directory {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param (
        # The location of the directory to create.
        [Parameter(Mandatory = $true)]
        [String]
        $Path
    )

    begin {
        Write-LogMessage -Message "Started execution"
    }

    process {
        if (-not (Test-Path -Path $Path) -and $PSCmdlet.ShouldProcess($Path, "creating directory")) {
            New-Item -Path $Path -ItemType Directory -Force
        }
    }

    end {
        Write-LogMessage -Message "Finished execution"
    }
}
