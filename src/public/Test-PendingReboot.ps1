<#
    .Synopsis
        Test whether or not a reboot is pending.
    .Description
        Test whether or not a reboot is pending.
    .Example
        PS C:\> Test-PendingReboot
        Tests to see if the local computer has a pending reboot.
    .Example
        PS C:\> Test-PendingReboot -ComputerName ABC -Credential $cred
        Tests to see if the remote computer has a pending reboot.
#>
function Test-PendingReboot {
    [CmdletBinding(SupportsShouldProcess = $true)]
    [OutputType([Boolean])]
    param (
        [Parameter(Mandatory = $false, ValueFromPipeline = $true)]
        [String]
        $ComputerName,
        [Parameter(Mandatory = $false)]
        [PSCredential]
        $Credential
    )

    begin {
        Write-LogMessage -Message "Started execution"
    }

    process {
        if ($PSCmdlet.ShouldProcess($ComputerName, "Querying registry for reboot flags")) {
            try {
                if ($Credential -and $ComputerName) {
                    $parameters = @{
                        ComputerName = $ComputerName
                        Credential   = $Credential
                        ErrorAction  = "Stop"
                        Verbose      = $true
                    }
                }
                else {
                    $parameters = @{
                        ErrorAction = "Stop"
                        Verbose     = $true
                    }
                }

                $result = Invoke-Command @parameters -ScriptBlock {
                    $VerbosePreference = "Continue"

                    # Vista + Server 2008 and newer may have reboots pending from CBS (Component Based Servicing).
                    if (Get-ChildItem "HKLM:\Software\Microsoft\Windows\CurrentVersion\Component Based Servicing\RebootPending" -ErrorAction SilentlyContinue) {
                        Write-Verbose -Message "Raised by 'Component Based Servicing'"
                        return $true
                    }

                    # RebootRequired key contains Update IDs with a value of 1 if they require a reboot.
                    # The existence of RebootRequired alone is sufficient on a Windows 8.1 workstation in Windows Update
                    if (Get-Item "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update\RebootRequired" -ErrorAction SilentlyContinue) {
                        Write-Verbose -Message "Raised by 'RebootRequired'"
                        return $true
                    }

                    # PendingFileRenameOperations contains pairs (REG_MULTI_SZ) of filenames that cannot be updated
                    # due to a file being in use (usually a temporary file and a system file)
                    # \??\c:\temp\test.sys!\??\c:\winnt\system32\test.sys
                    # http://technet.microsoft.com/en-us/library/cc960241.aspx
                    if (Get-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager" -Name "PendingFileRenameOperations" -ErrorAction SilentlyContinue) {
                        Write-Verbose -Message "Raised by 'PendingFileRenameOperations'"
                        return $true
                    }

                    try {
                        $util = [WmiClass]"\\.\root\ccm\clientsdk:CCM_ClientUtilities"
                        $status = $util.DetermineIfRebootPending()
                        if (($null -ne $status) -and $status.RebootPending) {
                            Write-Verbose -Message "Raised by 'CCM_ClientUtilities'"
                            return $true
                        }
                    }
                    catch {
                        Write-Verbose -Message "ERROR: Something went wrong."
                    }

                    return $false
                }
            }
            catch [System.Management.Automation.Remoting.PSRemotingTransportException] {
                Write-LogMessage -Message "PSRemoting failed to connect."
                return $null
            }
            catch {
                Write-LogMessage -Message "$($_.Exception | Select-Object -Property *)"
                Write-LogMessage -Message "Error Type: $($_.Exception.GetType().FullName)"

                throw
            }
        }

        Write-LogMessage -Message "Reboot required: $result"
        return $result
    }

    end {
        Write-LogMessage -Message "Finished execution"
    }
}
