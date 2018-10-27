<#
    .Synopsis
        Test for the presence of a command.
    .Description
        Test for the presence of a command, function, or executable.
    .Example
        PS C:\> Test-Command -Name packer
        Tests for the presence of "packer" and returns a boolean.
#>
function Test-Command {
    [CmdletBinding()]
    [OutputType([Boolean])]
    param (
        # The name of the command to test.
        [Parameter(Mandatory)]
        [String]
        $Name
    )

    end {
        try {
            Write-Verbose -Message "Looking for '$Name'."
            Get-Command -Name $Name -ErrorAction Stop | Out-Null
            return $true
        }
        catch {
            Write-Verbose -Message "Couldn't find '$Name'."
            $global:Error.RemoveAt(0)
            return $false
        }
    }
}
