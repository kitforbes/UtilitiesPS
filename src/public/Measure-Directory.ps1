<#
    .Synopsis
        Calculate the size of files and directories at a location.
    .Description
        Calculate the size of files and directories at a location.
    .Example
        PS C:\> Measure-Directory -Path C:\Windows\Temp
        Calculate the size of files and directories at a location.
#>
function Measure-Directory {
    [CmdletBinding()]
    param (
        # The directory to measure.
        [Parameter(Mandatory = $true)]
        [String]
        $Path,
        # The list of files to exclude.
        [Parameter(Mandatory = $false)]
        [String[]]
        $Exclude = @('.gitkeep'),
        # The unit usd to display the file and directory sizes.
        [Parameter(Mandatory = $false)]
        [ValidateSet('KB', 'MB', 'GB')]
        [String]
        $Unit = 'MB'
    )

    begin {
        Write-LogMessage -Message "Started execution"
    }

    process {
        if (Test-Path -Path $Path) {
            Write-LogMessage -Message "Measuring '$Path'"
            Get-ChildItem -Path $Path -Include * -Exclude $Exclude | ForEach-Object {
                if ($_.PSIsContainer) {
                    $type = "Directory"
                    $size = Get-ChildItem -Path $_.FullName -Recurse |
                        Measure-Object -Property Length -Sum |
                        Select-Object -ExpandProperty Sum
                }
                else {
                    $type = "File"
                    $size = $_.Length
                }

                return [PSCustomObject] @{
                    Type = $type
                    Size = $size
                    Item = "$($_.Name)"
                }
            } | Format-Table -Property @(
                "Type",
                @{
                    Name       = "Size ($Unit)"
                    Expression = { "{0:N0}" -f ($_.Size / "1$Unit") }
                    Align      = "Right"
                },
                "Item"
            )
        }
    }

    end {
        Write-LogMessage -Message "Finished execution"
    }
}
