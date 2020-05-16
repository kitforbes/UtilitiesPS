<#
    .Synopsis
        Get the time since the last reboot.
    .Description
        Get the time since the last reboot of the system.
    .Example
        PS C:\> Get-TimeSinceReboot
        Returns the time since the last system reboot.
#>
function Get-TimeSinceReboot {
    [CmdletBinding()]
    [OutputType([TimeSpan])]
    param (
    )

    begin {
        Write-LogMessage -Message "Started execution"
    }

    process {
        return New-TimeSpan -Start (Get-CimInstance -ClassName Win32_OperatingSystem).LastBootUpTime -End (Get-Date)
    }

    end {
        Write-LogMessage -Message "Finished execution"
    }
}
