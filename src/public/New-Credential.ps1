<#
    .Synopsis
        Create a PSCredential object.
    .Description
        Create a PSCredential object.
    .Example
        PS C:\> New-Credential -UserName 'user' -InsecurePassword 'My Password'
        Creates a PSCredential object from a plain text password.
    .Example
        PS C:\> New-Credential -UserName 'domain\user' -Password $mySecureStringPassword
        Creates a PSCredential object from a secure string password.
#>
function New-Credential {
    [System.Diagnostics.CodeAnalysis.SuppressMessage('PSAvoidUsingUserNameAndPassWordParams', '')]
    [System.Diagnostics.CodeAnalysis.SuppressMessage('PSAvoidUsingPlainTextForPassword', '')]
    [System.Diagnostics.CodeAnalysis.SuppressMessage('PSAvoidUsingConvertToSecureStringWithPlainText', '')]
    [CmdletBinding(SupportsShouldProcess = $true, DefaultParameterSetName = 'Secure')]
    param (
        # The name of the user.
        [Parameter(Mandatory = $true, Position = 0, ParameterSetName = 'Secure')]
        [Parameter(Mandatory = $true, Position = 0, ParameterSetName = 'Insecure')]
        [String]
        $UserName,
        # The password as a SecureString.
        [Parameter(Mandatory = $true, Position = 1, ParameterSetName = 'Secure')]
        [SecureString]
        $Password,
        # The password as an insecure String.
        [Parameter(Mandatory = $true, Position = 1, ParameterSetName = 'Insecure')]
        [String]
        $InsecurePassword
    )

    begin {
        Write-LogMessage -Message "Started execution"
    }

    process {
        switch ($PSCmdlet.ParameterSetName) {
            'Secure' {
                $securePassword = $Password
            }
            'Insecure' {
                $securePassword = ConvertTo-SecureString -String $InsecurePassword -AsPlainText -Force
                Remove-Variable -Name 'InsecurePassword' -Force
            }
        }

        $parameters = @{
            TypeName     = 'System.Management.Automation.PSCredential'
            ArgumentList = @(
                $UserName,
                $securePassword
            )
        }

        if ($PSCmdlet.ShouldProcess("UserName: $UserName", "Create credential")) {
            return New-Object @parameters
        }
    }

    end {
        Write-LogMessage -Message "Finished execution"
    }
}
